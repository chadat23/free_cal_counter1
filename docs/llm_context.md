# App usage summary

FreeCalCounter is to help people track calories, macros, and weight over time. 

At a high level, eventually, it should be able to do things like track calories, fat, carbs, and protein per meal, day, and week, enable visualizing, easy data entry and editing from sources such as the FDA as well as OpenFoodFacts (OFF). There should be a local db (parsed and pruned from FDA data) to search, a local db of logged foods to expedite reselecting foods, and the ability to reach out to OFF as well. Local stuff should be prioritized since it's faster, but other than that basic workflow divergence, any source should seamlessly integrated. It should also be able to track and visualize a person's weight over time, and to make recommendations regarding macro nutrient targets. While the goal isn't infinite flexibility or to allow any work flow, it needs to be flexible, we always want it to be easy for users to fix input mistakes.

# Terminology

To ensure consistency across the application and codebase, the following terms are defined:

- **Food**: The reference data for a specific item (e.g., "Apple" or "Chicken Breast"). It contains the master macro values (Calories, Protein, Fat, Carbs, Fiber) which are stored and calculated based on 1 gram of the food.
- **Serving**: A definition of a unit of measurement for a Food. It defines the name of the unit (e.g., "cup", "piece", "container") and how many grams that unit weighs. A Food can have many Servings defined.
- **Quantity**: The numeric value entered by the user (corresponds to "Amount" in the UI) or calculated by the app to specify how much of a unit or macro is being referred to (e.g., the "1.5" in "1.5 cups").
- **Portion**: A specific instance of a Food (or Recipe) being used, logged, or added as an ingredient. A Portion stores the reference, the total weight in grams, and the unit name used to define it. A Portion is what appears in the Log, Log Queue, and as Ingredients in a Recipe.

# 1 Screens Overview

## 1.1 Overview: basic summaries of the week's macros. The macros are to be in tables of bar charts as well as some text labels. Additionally, there should be buttons to toggle between showing the consumed macros and the remaining macros.
- 1.1.1 Each column of bar charts represents a day of the current week: Monday through Sunday, and each row represents a macro, one bar chart per day. 
- 1.1.2 There should also be a column of text, to the right of the bar charts, representing the current day's consumed or remaining (depending on button selection) macro amount for each macro as well as the day's target for said macro.
- 1.1.3 The Consumed/Remaining buttons should set a global state so that it'll be persistent even when the screen if left and returned to.
- 1.1.4 The below that should show a Search bar, globe button representing an OpenFoodFacts (OFF) search, and then a Log button.
- 1.1.5 The Search bar should bring up the consolidated Search screen.
- 1.1.6 The OFF button performs a search using the external OpenFoodFacts database for the current query.
- 1.1.7 Below that should be a set of tabs: Overview, Log, Weight, and Settings which should bring the user to the Overview, Log, Weight, and Settings screens respectively.

## 1.2 Log: the person's logged foods. 
- 1.2.1 The top should have a label for the day: a date, "Yesterday", "Today", or "Tomorrow" with simple navigation to move between days.
- 1.2.2 The navigation buttons should let the user switch to see what was logged on any given day by letting the user move one day at a time into the future or past relative to the currently selected day. It should default to today.
- 1.2.3 There should then be a row of bar charts representing the Consumed or Remaining macros for the selected day based on the global state.
- 1.2.4 Each set of foods that are logged together should have a timestamp above the group (Meal) as well as the total macros for the meal.
- 1.2.5 Each portion of each food item should be in its own little bubble (Slidable Portion Widget which contains a Portion Widget) and should contain the size of the portion, the unit of measure of the portion, the macros of the portion, and the image of the food. The image should be a thumbnail if available, and if not, should default back to the emoji, and only if there's no emoji for the food of the portion, should it fall back to a default emoji.
- 1.2.6 The Slidable Portion Widget combined with the contained Portion Widget should allow deleting, copying, and editing logged items. The Portion Widget should have an always visible edit button on the right side. Sliding the portion to the left should reveal the delete button, and having it work this way means that two actions are needed to help avoid accidental deletions.
- 1.2.7 Long pressing a portion should select it. Clicking elsewhere should unselect it but the particulars of what that mean needs to be sorted out so that it's done in a practical yet intuitive way. Once one portion is selected, tapping on additional portions should select them as well. Tapping a selected portion should unselect it. Again, if any portions are selected, tapping off of any portion should unselect them all. If any portions are selected, a context sensitive set of buttons should be brought up: Copy, Move, Delete, and Make Recipe. The Copy button should copy the selected portions to the Log Queue, the Move button should move the selected portions to a user specified date and time with the Log, so should update the logged time based on a calendar and time picker that should be presented to the user that should default to the present date and time, the Delete button should delete the selected portions, and the Make Recipe button should open the recipe screen and prepopulate the ingredients with the selected portions. (Tapping an ingredient in the recipe screen should also bring up the Quantity Edit Screen).
- 1.2.8 The bottom should show a Search bar, globe button representing an OpenFoodFacts search, and then a Log button.
- 1.2.9 The Search bar should bring up the Search screen.
- 1.2.10 The OFF button should either do nothing and be there for consistencies sake, or should search for whatever is in the search box, but clicking on the search box to enter text should open the Search screen so there shouldn't be anything in the search box so maybe the button should do nothing at that point to avoid empty searches?

## 1.3 Search: shows results from various search types (text, barcode, recipe) and sources (local, OFF).
- 1.3.0 The Search Screen is a consolidated, configurable component (`SearchScreen`) that adapts to different usage contexts (e.g., adding to a day log vs. adding a recipe ingredient) via a `SearchConfig`.
- 1.3.1 The top should have a row with an exit button that should bring the user back to the home screen (prompting the user that the Log Queue will be emptied if it isn't already so), a list of images showing what's in the Log Queue, and a down arrow button to navigate to the Log Queue screen.
- 1.3.2 Next are two rows of bar charts, one representing the day's macros (including what's in the Log Queue), one for the Log Queue's macros.
- 1.3.3 Below that are three buttons: a Text-based search button, a Barcode-based Search, and a Recipe tab, representing the three main forms of item lookup.
  - 1.3.3.1 The Text based search:
    - 1.3.3.1.1 Defaults to searching the local food databases.
    - 1.3.3.1.2 The OFF button can be used for additional data options. Pressing it should perform an OFF search for the text that's in the Search bar (handled by the `SearchRibbon`).
    - 1.3.3.1.3 Search results are to be color coded based on the original source of the data (USDA Foundation Foods, USDA SR Foods, OFF Foods, user entered, Recipe). That said, since once a portion is logged that refers to a food, said food needs to be added to the logged foods table, so there simultaneously needs to be a way to distinguish previously logged vs not logged foods. This should be achieved via a small icon or a "Note" section displayed on the food item; since space is at a premium, this should be subtle enough to not clutter the UI but still be identifiable (squinting is an acceptable tradeoff for density).
    - 1.3.3.1.4 For each food, there should be an icon/image, the name, a dropdown of proposed portion units and sizes, and the macros for the currently selected portion, as well as an add button.
    - 1.3.3.1.5 Selecting the add button should add the current portion to the Log Queue.
    - 1.3.3.1.6 Selecting other parts of a search result should bring up the Quantity Edit Screen.
    - 1.3.3.1.7 Kind of like with the Slidable Portion Widgets, the search results should be slidable. Each result is displayed using a `SearchResultTile`.
      - 1.3.3.1.7.1 The previous functionality can all be handled by the Search Result Widget, but that should be a child widget of the Slidable Search Result Widget.
      - 1.3.3.1.7.2 Sliding the search result to the left should reveal the delete button, and having it work this way means that two actions are needed to help avoid accidental deletions.
        - 1.3.3.1.7.2.1 Sliding the search result to the right should reveal the Edit and Copy buttons.
          - 1.3.3.1.7.2.1.1 The Edit button needs to bring up a yet to be implemented (or at least flushed out) Food Edit Screen that lets the user modify an existing food.
            - 1.3.3.1.7.2.1.1.1 If the search result is from the reference db, then at least upon submitting/entering the edit, the food needs to be copied to the live db logged_foods table with all of the user viewed data copied over (other than whatever the user changes via the edit screen) with all other stuff being updated as needed to maintain overarching app functionality (so it probably shouldn't have a parent).
            - 1.3.3.1.7.2.1.1.2 If the parent food is in the reference db, then ideally, since foods point to the parent's id, the source data from the reference db would be able to be filtered out of search results. This is low priority and can be done later, especially if there aren't clear and high confidence ways to achieve this.
            - 1.3.3.1.7.2.1.1.3 In cases where the parent is also in the logged_foods table, all parents should be recursively filtered out of the search results so only the newest version of the food will be shown. This will yield unfindable foods; this may bring about future features.
            - 1.3.3.1.7.2.1.1.4 By doing this we won't break old logs, yet we'll be able to update future search results.
          - 1.3.3.1.7.2.1.2 The Copy button should work about like the edit button, only a copied item seemingly won't have a parent.
            - 1.3.3.1.7.2.1.2.1 So unlike with the edit button, whatever its data's being copied from, won't be filtered out of the search results.
            - 1.3.3.1.7.2.1.2.2 When the Edit Food Screen opens, the food name should be the same as the source food, only with " - Copy" appended to the end of it.
        - 1.3.3.1.7.2.2 In theory, from the user's perspective, the Delete button will delete foods.
          - 1.3.3.1.7.2.2.1 Since the reference db is read only, if the user tries to delete a search result from the reference db, the user should be succinctly be prompted to let them know that the food can't be deleted and why.
          - 1.3.3.1.7.2.2.2 If the search result that's to be deleted is from the logged_foods table, and isn't referenced by anything (presumably just portions or recipes), then it can be deleted.
          - 1.3.3.1.7.2.2.3 If the search result that's to be deleted is from the logged_foods table, and is referenced by something (presumably just portions or recipes), then it can't be deleted, so some sort of flag needs to be set in the food so that it's filtered from future search results without breaking old logged portions or recipes.
  - 1.3.3.2 The Barcode search isn't to be worried about for now.
  - 1.3.3.3 The Recipe Search button is next.
    - 1.3.3.3.1 Below the row of 3 buttons (text search, barcode search, and recipe search) should be a Create New Recipe button to bring the user to the Edit Recipe Screen.
    - 1.3.3.3.2 Adjacent to the Create New Recipe button should be a dropdown to let the user select what Category of recipe they want to search.
    - 1.3.3.3.3 Below that should be the returned list of recipes.
      - 1.3.3.3.3.1 When the pace is initially loaded, when no search term has yet been entered, it should default to showing all of the latest versions of recipes, so if a recipe has been saved a number of times, only the latest version should be shown.
      - 1.3.3.3.3.2 Entering a search term at the bottom of the page should search recipes, not foods, and I suppose the OFF button shouldn't do anything since it doesn't seem like that'd make sense.
      - 1.3.3.3.3.3 Much like with the text based search, the results should be displayed in the Search Result Widget, and the Slidable Search Result Widget, but maybe the Slidable Search Widget needs a flag and configurability, or maybe it needs to be a different widget.
        - 1.3.3.3.3.3.1 Like with search results, sliding a recipe to the left should reveal a delete button, but like with the text based search results, in order to ensure data integrity, it should hide the recipe if it's ever been logged or added to another recipe as an ingredient.
        - 1.3.3.3.3.3.2 Sliding the recipe to the right should reveal the Edit, Copy, and Dump buttons.
          - 1.3.3.3.3.3.2.1 The Edit button should bring the user to the Edit Recipe Screen, where, again like with the logged_foods table, in order to ensure data integrity, if the current version of the recipe has ever been logged or used as an ingredient in another recipe, it needs to be duplicated and then the user should be able to edit the copy. This should seamlessly be done behind the screens because the user doesn't need to know how this works. Additionally, the new version of the recipe needs to have it's parent Id set so that old versions of it can be filtered out of search results. However, if the current version of the recipe has never been logged or added as in ingredient to another recipe, it can be updated in place since that won't change any past logs. Any past logged items that point to the recipe should be left to refer to the old version, but the new version should be used for any future logs.
          - 1.3.3.3.3.3.2.2 The Copy button should bring the user to the Edit Recipe Screen, where it should look/behave about like what the Edit button does, only with " - Copy" appended to the end of the new recipe's name. However, since we're copying the recipe, we're creating a new one rather than replacing an old one in search results so we'll leave the parent Id blank, always create a new entry, never update an old one, and not worry about filtering out old versions since it has no parent.
          - 1.3.3.3.3.3.2.3 The Dump button should dump one serving's worth of ingredients into the Log Queue. The idea is that, while, for instance, if you were making a cookie recipe, you'd never make one cookie or only eat most of the ingredients, but you might, for instance, have a standard dinner salad recipe that you work from most nights, but where, unlike the cookie recipe, instead of making it exactly the same every time, each night will be a little different depending on what's on hand. So the user may create a generic Dinner Salad recipe, and then when making it, hit the Dump button to avoid having to add each individual ingredient/portion to the Log Queue, then they can switch over to the Log Queue, delete anything that they're not having that night, and update portion amounts/units for the remaining ingredients/portions. Also, there's to be an option to set in the Edit Recipe Screen to set that the recipe is only Dumpable (this will avoid accidentally adding the recipe as is and which would inhibit the ability to edit the recipe in place (with the salad recipe example, the recipe may be updated frequently depending on what's in season and ensuring that it's always dumped ensures that the user doesn't end up with a bunch of versions of it in the db)). If the recipe is only dumpable then hitting the plus button should dump the recipe into the Log Queue and tapping the recipe (such as to bring up the Quantity Edit Screen) should prompt the user that that isn't an option since the recipe is only dumpable.
        - 1.3.3.3.3.3.3 The plus button should add one portion (as specified by the dropdown of the Search Result Widget) to the Log Queue.
        - 1.3.3.3.3.3.4 Tapping elsewhere on the widget should bring up the Quantity Edit Screen so that the user can enter the exact Quantity and Unit of recipe that they're having.
- 1.3.5 Selecting the Log button should log the Log Queue to the LoggedPortions table in the db and then navigate the user back to the Overview screen.
- 1.3.6 Some additional requirements are covered under 1.7.6 on how it must be made flexible for reuse for searching for and adding ingredient to recipes.

## 1.4 Quantity Edit Screen: a place for a user to edit how much of a particular food was eaten (Portion) or is in a recipe (Ingredient).
- 1.4.1 The top left is to have a back button that brings the user back to wherever they navigated from (Search Screen, Log Screen, Log Queue Screen, or Recipe Edit Screen) without making any changes.
- 1.4.2 Should have two rows of macros: the parent context's macros (Day's Macros or Recipe's Macros) and the item's macros (Portion or Ingredient). Both should update in real time.
- 1.4.3 If updating an existing item, the parent macros should subtract the old version and add the new version. Otherwise, just add the new version.
- 1.4.4 For recipes, an additional toggle for "Total" vs "Per Serving" should be available:
  - 1.4.4.1 Total (default): Recipe macros show sum of all ingredients. Item macros show macros for the entered Quantity.
  - 1.4.4.2 Per Serving: Recipe macros show one serving's worth. Item macros show 1/Nth of the Quantity's macros (where N is number of servings).
  - 1.4.4.3 The Quantity always represents the total physical amount added; the toggle only affects visualization.
- 1.4.5 Parent Macro Targets:
  - 1.4.5.1 For Day's Macros, the bar charts use the user's daily goals.
  - 1.4.5.2 For Recipe Macros, it is undecided if they should have a target; as such, not having a target for recipe bar charts is an acceptable simplification.
- 1.4.6 There should be a user editable Quantity and a user editable Unit (list of all available units for the food, e.g., grams, cups, pieces).
- 1.4.7 Target Selection: A row of buttons for "Unit" (default), Calories, Carbs, Protein, and Fat.
  - 1.4.7.1 If "Unit" is selected, the numeric input is treated as the Quantity of the selected Unit.
  - 1.4.7.2 If another target is selected (Calories, Carbs, Protein, or Fat), the selected Unit must automatically switch to "g" (grams). The food's macro values are used to calculate the number of grams required to achieve the target numeric value of the selected macro.
  - 1.4.7.3 If the user manually changes the Unit selection while a macro target (Calories, Carbs, Protein, or Fat) is active, the Target Selection must automatically switch back to "Unit".
- 1.4.8 Calculated Output: Below the targets, show the resulting number of grams required.
- 1.4.9 Pre-population: When the screen opens, the Quantity (Amount) and Unit fields must be pre-populated with the values from the source that triggered the screen (e.g., the selected unit in a search result or the current quantity/unit of a logged portion).
- 1.4.10 The Cancel button discards changes and returns the user to the previous screen.
- 1.4.10 The Action button:
  - 1.4.10.1 Label: Dynamically displays "Add" if adding a new item, or "Update" if modifying an existing one. 
  - 1.4.10.2 Behavior: Adds/updates the item in the appropriate collection (Log Queue, Logged Portions, or Recipe ingredients) and navigates back. Adding an ingredient to a recipe should NOT add it to the Log Queue.

## 1.5 Log Queue: A screen for viewing in process logging activities, what and how much food is being proposed to have been eaten.
- 1.5.1 The top should have a row with an exit button that should bring the user back to the home screen (prompting the user that the Log Queue will be emptied if it isn't already so), a list of images showing what's in the Log Queue, and then an up arrow button to navigate to the Search screen.
- 1.5.2 Next should be two rows of macros: the day's expected macro including the current proposed portion, and then the portion's macros. Both should update in real time.
- 1.5.3 Then should be a list of food bubbles, each with an image, name, quantity, unit, and macros.
- 1.5.4 There should be an edit button that brings the user to the Quantity Edit Screen so that it can be edited.
- 1.5.5 Sliding the portion to the left should reveal the delete button. 
  - 1.5.5.1 Clicking the delete button should delete the portion from the Log Queue
  - 1.5.5.2 Clicking on the slid portion somewhere other than the delete button should slide the portion back to its nominal position.
  - 1.5.5.3 This is achieved by having the text, image, macros, and edit button in the Portion Widget, and having that wrapped in a parent Slidable Portion Widget that handles the sliding stuff as well as the delete button and subsequent functionality.
- 1.5.6 The bottom has the standard Search bar, OFF button, and Log button.
- 1.5.7 Clicking the Log button will commit the Log Queue to the LoggedPortion table and then bring the user back to the Overview screen.
- 1.5.8 When the Log Queue is logged, everything in the log queue should receive the same, current, time as the timestamp for when the portions were logged, that said, said time should be passed into the logging function since that's what allows moving portions, editing their logged time.


## 1.7 Recipe Edit: a screen for editing and creating recipes
- 1.7.1 The top row of the screen should have a back button that'll bring the user back to the Search Screen, the recipe name (if its previously been saved), and a save button that'll save the recipe. If there are unsaved changes, if the user hits the back button, they should get a succinct message asking if they want to discard unsaved changes.
- 1.7.2 Next down should be a place for the user to enter a recipe name
- 1.7.3 Next should be a row to allow the user to enter the number of portions as well as the name of what a portion is, for example Cookie, Slice, Piece, etc. 
- 1.7.4 Next should be a row with a Total Weight input. The total final weight must sometimes be updated to account for the addition or subtraction of calorie free stuff such as water that isn't tracked in the app (e.g., if making sugar water, identifying the final weight as 100g even if only 50g of sugar was added, so that a 50g serving correctly calculates as having 25g of sugar). Next to that should be a button to specify that the recipe is purely a dumpable template that is, that while the user should be able to "dump" the ingredients into the Log Queue, the user shouldn't be able to add the recipe itself to the Log Queue. This like like with the cookie vs salad example from 1.3.3.3.3.3.2.3. The Dump Only button/checkbox/whatever, should default to unselected since this is the exception to the rule.
- 1.7.5 Next should be two rows of bar charts. The top row should be labeled "Total Recipe Macros" reflecting the sum of all ingredients. The bottom row should be labeled "Macros per [Portion Unit Name]" (e.g., "Macros per Cookie"), representing the total divided by the number of portions.
- 1.7.6 Below the metadata and macros, there should be a Categories section:
  - 1.7.6.1 It should have a multi-select category picker that looks like a dropdown field.
  - 1.7.6.2 Tapping it opens a dialog with a checklist of all available categories and a (+) button to add new ones.
  - 1.7.6.3 Selected categories should be displayed as chips within the picker field for easy identification and removal.
- 1.7.7 Next should a button to add ingredients. this means a number of things must be configurable on the search screen:
  - 1.7.7.1 The exit icon at the top must bring the user back to the recipe screen.
  - 1.7.7.2 The navigation and visibility of UI elements (like the macro ribbon) are dynamically controlled via the `SearchConfig` passed to the `SearchScreen`.
  - 1.7.7.3 The down arrow in the top right should bring the user back to the recipe screen if that's where the search screen was reached from.
  - 1.7.7.4 The bar charts should show the total recipe's macros on the top line and the ingredient's macros on the second line and the labels should update accordingly.
  - 1.7.7.5 The plus button or `onSave` action needs to know to add the ingredient to the recipe but not the Log Queue and to go back to the Recipe Edit screen. This can be handled by an `onSaveOverride` in the `SearchConfig`.
  - 1.7.7.6 Clicking on the `SearchResultTile` needs to bring up the Quantity Edit Screen with the appropriate context.
  - 1.7.7.7 The log button should be hidden or inactive in this context if not needed.
- 1.7.8 Next should be a list of the ingredients in the recipe, with the ability to edit each one. They should use the same Portion Widget and Slidable Portion Widget as the Log and Log Queue. this may take some reworking and should be done so thoughtfully to ensure it still works as desired and expected for all use cases.

# Notes, Quirks, and Idiosyncrasies
- The Quantity Edit Screen dynamically updates its action button to say "Add" or "Update" based on context.
- On the Search Screen, in addition to the 3 kinds of searches, maybe that's where it'd make sense to have an Add Food button.
