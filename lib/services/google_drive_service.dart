import 'dart:io';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path/path.dart' as p;
import 'package:archive/archive.dart';
import 'package:free_cal_counter1/services/image_storage_service.dart';

class GoogleDriveService {
  // Singleton pattern
  GoogleDriveService._();
  static final GoogleDriveService instance = GoogleDriveService._();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveAppdataScope],
  );

  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  Future<GoogleSignInAccount?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      return account;
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<bool> isSignedIn() async {
    return _googleSignIn.currentUser != null ||
        await _googleSignIn.isSignedIn();
  }

  Future<void> silentSignIn() async {
    try {
      await _googleSignIn.signInSilently();
    } catch (e) {
      debugPrint('Silent Sign-In Error: $e');
    }
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    final account = _googleSignIn.currentUser;
    if (account == null) return null;

    final authClient = await _googleSignIn.authenticatedClient();
    if (authClient == null) return null;

    return drive.DriveApi(authClient);
  }

  /// Uploads database file and images to App Data folder in Google Drive.
  /// Creates a zip file containing the database and images folder.
  /// If [retentionCount] is provided, it deletes older backups exceeding that count.
  Future<bool> uploadBackup(File file, {int retentionCount = 7}) async {
    try {
      final api = await _getDriveApi();
      if (api == null) return false;

      // Create zip file containing database and images
      final archive = Archive();

      // Add database file to archive
      final dbBytes = await file.readAsBytes();
      final dbFile = ArchiveFile('free_cal.db', dbBytes.length, dbBytes);
      archive.addFile(dbFile);

      // Add images folder to archive
      final imagesDir = await ImageStorageService.instance.getImagesDirectory();
      if (await imagesDir.exists()) {
        await for (final entity in imagesDir.list(recursive: true)) {
          if (entity is File) {
            final relativePath = p.relative(
              entity.path,
              from: imagesDir.parent.path,
            );
            final imageBytes = await entity.readAsBytes();
            final imageFile = ArchiveFile(
              relativePath,
              imageBytes.length,
              imageBytes,
            );
            archive.addFile(imageFile);
          }
        }
      }

      // Create zip file
      final zipBytes = ZipEncoder().encode(archive);
      if (zipBytes == null) {
        debugPrint('Failed to create zip file');
        return false;
      }
      final zipFile = File(
        '${file.parent.path}/backup_${DateTime.now().millisecondsSinceEpoch}.zip',
      );
      await zipFile.writeAsBytes(zipBytes);

      final fileName =
          'free_cal_backup_${DateTime.now().toIso8601String()}.zip';

      final media = drive.Media(zipFile.openRead(), await zipFile.length());
      final driveFile = drive.File();
      driveFile.name = fileName;
      driveFile.parents = ['appDataFolder'];

      await api.files.create(driveFile, uploadMedia: media);

      // Clean up temporary zip file
      await zipFile.delete();

      if (retentionCount > 0) {
        await _enforceRetentionPolicy(api, retentionCount);
      }

      return true;
    } catch (e) {
      debugPrint('Drive Upload Error: $e');
      return false;
    }
  }

  Future<void> _enforceRetentionPolicy(
    drive.DriveApi api,
    int maxBackups,
  ) async {
    try {
      final fileList = await api.files.list(
        spaces: 'appDataFolder',
        $fields: 'files(id, name, createdTime)',
        orderBy: 'createdTime desc', // Newest first
      );

      final files = fileList.files;
      if (files != null && files.length > maxBackups) {
        // Delete excess oldest files
        final toDelete = files.sublist(maxBackups);
        for (final file in toDelete) {
          if (file.id != null) {
            try {
              await api.files.delete(file.id!);
              debugPrint('Deleted old backup: ${file.name}');
            } catch (e) {
              debugPrint('Error deleting file ${file.id}: $e');
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Retention Policy Error: $e');
    }
  }
}
