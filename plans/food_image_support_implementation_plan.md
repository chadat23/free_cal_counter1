# Food Image Support Implementation Plan

## Overview
Add custom image support for foods with camera/gallery picker, crop tool, backup/restore, and proper food revision handling.

## Architecture Decisions

### Image Storage
- Store images as files in app documents directory (persistent across updates)
- Store file names (GUIDs) in database `thumbnail` field
- Use `local:` prefix to distinguish local images from URLs
- Image size: 200x200 max, preserve aspect ratio
- Delete old image as last step when replacing (after new image saved)
- Garbage collection: Delete unreferenced images during backup

### Display Priority
1. Custom local image (`local:GUID`)
2. OFF thumbnail URL
3. Emoji
4. Nothing

### Food Revision Logic
- Macros changed: Create new food version (new ID)
- Only image/name changed: Update in place (same ID)
- Old references keep old IDs
- New references (in-progress portion/ingredient) use new ID

### Backup/Restore
- Backup: Zip live DB + only referenced images (garbage collect unreferenced)
- Restore: Unzip, overwrite DB + images (no merge)
- Ensure DB consistency: Use read transaction during backup to get consistent snapshot
- Prevent backup during active writes: Check for in-progress operations before starting

---

## Implementation Chunks

### Chunk 1: Image Storage Service
**File:** `lib/services/image_storage_service.dart`

**Responsibilities:**
- Get/create images folder in documents directory
- Generate GUIDs for image filenames
- Save image file to folder
- Delete image file
- Get image file path from GUID
- Check if thumbnail is local or URL

**Dependencies:**
- `path_provider` for documents directory
- `uuid` for GUID generation
- `image` package for resizing

**Key Functions:**
- `init()` - Ensure images folder exists
- `saveImage(File sourceFile)` - Save, resize to 200x200, return GUID
- `deleteImage(String guid)` - Delete file
- `getImagePath(String guid)` - Get full file path
- `isLocalImage(String? thumbnail)` - Check if starts with `local:`
- `extractGuid(String thumbnail)` - Remove `local:` prefix
- `getAllReferencedGuids()` - Get all GUIDs referenced in database
- `deleteUnreferencedImages()` - Delete images not in database (garbage collection)

---

### Chunk 2: Update Food Model and Database
**Files:** `lib/models/food.dart`, `lib/data/database/tables.dart`

**Changes:**
- No schema changes needed (thumbnail field already exists)
- Update Food model to handle `local:` prefix in thumbnail
- Add helper methods to Food model:
  - `isLocalImage()` - Check if thumbnail is local
  - `getLocalImageGuid()` - Extract GUID if local
  - `getDisplayThumbnail()` - Return local path or URL

---

### Chunk 3: Image Picker and Crop UI
**Files:** `lib/screens/food_edit_screen.dart`

**Dependencies:**
- `image_picker` package
- `image_cropper` package

**UI Changes:**
- Add image picker button in metadata section (next to emoji field)
- Show current image preview if exists
- On tap: Show dialog with options (Camera, Gallery, Remove)
- After selection: Open crop tool
- After crop: Save via ImageStorageService, update `_thumbnail`

**Flow:**
1. User taps image picker button
2. Show dialog: Camera / Gallery / Remove
3. User selects source
4. Image picker opens
5. User selects image
6. Crop tool opens
7. User crops and confirms
8. Image saved to storage, GUID returned
9. `_thumbnail` updated to `local:GUID`
10. Old image deleted if existed (last step, after new saved)

---

### Chunk 4: Image Display Logic
**Files:** Create `lib/widgets/food_image_widget.dart`

**Responsibilities:**
- Display food image based on priority
- Handle local images, URLs, emojis
- Show placeholder if none

**Logic:**
```
if thumbnail starts with "local:":
  load from ImageStorageService
else if thumbnail is URL:
  load from network
else if emoji exists:
  display emoji
else:
  display placeholder
```

**Usage:**
- Replace emoji-only displays throughout app
- Use in search results, food lists, etc.

---

### Chunk 5: Quantity Edit Screen - Food Display
**File:** `lib/screens/quantity_edit_screen.dart`

**Changes:**
- Add food name + image display above bar charts
- Use FoodImageWidget
- Show food name text below image

**Layout:**
```
[Food Image Widget]
[Food Name]
[Bar Charts]
...
```

---

### Chunk 6: Food Edit from Quantity Edit - Revision Handling
**Files:** `lib/screens/quantity_edit_screen.dart`, `lib/screens/food_edit_screen.dart`

**Current Behavior:**
- `_handleEditDefinition()` navigates to FoodEditScreen
- On return, reloads food from DB and updates `_food` in place

**Required Changes:**
- FoodEditScreen needs to detect if macros changed
- If macros changed: Create new food version (new ID)
- If only image/name changed: Update in place
- Return FoodEditResult with new food ID
- QuantityEditScreen updates `_food` with new food

**Detection Logic:**
- Compare original food macros with edited food macros
- If any macro differs: macros changed
- Else: only metadata changed

**DatabaseService Changes:**
- Add method to detect if food needs new version
- Add method to create new version (copy food, new ID)
- Add method to update in place

---

### Chunk 7: Backup Service - Include Images
**File:** `lib/services/google_drive_service.dart` (or new backup service)

**Changes:**
- Modify backup flow to create zip file
- Zip contents:
  - Live DB file
  - Images folder (all files)
- Upload zip to Google Drive

**Dependencies:**
- `archive` package for zip creation

**Flow:**
1. Check if any write operations are in progress
2. If writes in progress: Wait or abort backup
3. Start read transaction on database (ensures consistent snapshot)
4. Get all referenced image GUIDs from database
5. Get all image files in images folder
6. Identify unreferenced images (garbage)
7. Delete unreferenced images
8. End read transaction
9. Create zip file
10. Add DB to zip
11. Add only referenced images to zip
12. Upload zip

---

### Chunk 8: Restore Service - Handle Images
**File:** `lib/services/google_drive_service.dart` (or new restore service)

**Changes:**
- Download zip from Google Drive
- Extract to temp location
- Close DB connections
- Replace live DB file
- Replace images folder (delete old, extract new)
- Re-initialize DB

**Flow:**
1. Download latest backup zip
2. Extract to temp directory
3. Close all DB connections
4. Delete old live DB
5. Copy new DB from temp
6. Delete old images folder
7. Copy new images folder from temp
8. Re-initialize DB
9. Clean up temp files

---

### Chunk 9: Testing and Verification
**Test Scenarios:**
1. Add image to new food via camera
2. Add image to new food via gallery
3. Crop image and verify aspect ratio preserved
4. Replace existing image (verify old deleted)
5. Remove image from food
6. Display priority: local > URL > emoji
7. Edit food from Quantity Edit (macros unchanged)
8. Edit food from Quantity Edit (macros changed)
9. Verify old references keep old IDs
10. Verify new references use new IDs
11. Backup with images
12. Restore with images
13. Verify images persist after app restart

---

## Dependencies to Add
```yaml
dependencies:
  image_picker: ^1.0.0
  image_cropper: ^5.0.0
  path_provider: ^2.1.0
  uuid: ^4.0.0
  image: ^4.0.0
  archive: ^3.4.0
```

---

## Data Flow Diagrams

### Image Upload Flow
```
User taps image picker
  → Show dialog (Camera/Gallery/Remove)
  → User selects source
  → Image picker opens
  → User selects image
  → Crop tool opens
  → User crops and confirms
  → ImageStorageService.saveImage()
  → Resize to 200x200
  → Generate GUID
  → Save to documents/images/GUID.jpg
  → Return GUID
  → Update food.thumbnail = "local:GUID"
  → Delete old image if existed
```

### Food Edit from Quantity Edit Flow
```
QuantityEditScreen
  → User taps "Edit Definition"
  → Navigate to FoodEditScreen with originalFood
  → User edits food
  → User saves
  → FoodEditScreen detects changes:
    - Macros changed? → Create new version (new ID)
    - Only metadata changed? → Update in place
  → Return FoodEditResult(foodId)
  → QuantityEditScreen reloads food from DB
  → Update _food in place
  → UI refreshes with updated food
```

### Backup Flow
```
User triggers backup
  → BackupService.createBackup()
  → Check if any write operations in progress
  → If writes in progress: Wait or abort
  → Start read transaction (consistent snapshot)
  → Get all referenced image GUIDs from database
  → Get all image files in images folder
  → Identify unreferenced images (garbage)
  → Delete unreferenced images
  → End read transaction
  → Create zip file
  → Add DB to zip
  → Add only referenced images to zip
  → Upload zip to Google Drive
  → Enforce retention policy
  → Mark dirty flag cleared
```

### Restore Flow
```
User triggers restore
  → RestoreService.restore()
  → Download latest backup zip
  → Extract to temp
  → Close DB connections
  → Replace live DB file
  → Replace images folder
  → Re-initialize DB
  → Mark dirty flag cleared
```

---

## Edge Cases to Handle

1. **Image picker cancelled**: No changes to thumbnail
2. **Crop cancelled**: No changes to thumbnail
3. **Image save fails**: Show error, keep old image
4. **Old image delete fails**: Log warning, continue with new image
5. **Backup fails**: Show error, don't mark dirty cleared
6. **Restore fails**: Show error, keep old data
7. **Images folder doesn't exist on restore**: Create it
8. **GUID collision**: UUID makes this extremely unlikely
9. **Thumbnail is null**: Display emoji or placeholder
10. **Food from reference DB**: Always create new live DB entry
11. **Backup during active DB writes**: Check for writes, wait or abort, use read transaction
12. **Image file exists but not in DB**: Deleted during backup garbage collection

---

## Notes for Future Recipe Image Support

When adding recipe images later:
- Add `thumbnail` field to Recipe model (already has emoji)
- Add `thumbnail` column to Recipes table
- Same image picker/crop flow in RecipeEditScreen
- Same display priority logic
- Same backup/restore handling (images folder shared)
- Recipe revision logic may differ (recipes don't have macros)
