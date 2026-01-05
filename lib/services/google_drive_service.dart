import 'dart:io';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path/path.dart' as p;

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

  /// Uploads the database file to the App Data folder in Google Drive.
  /// If [retentionCount] is provided, it deletes older backups exceeding that count.
  Future<bool> uploadBackup(File file, {int retentionCount = 7}) async {
    try {
      final api = await _getDriveApi();
      if (api == null) return false;

      final fileName = 'free_cal_backup_${DateTime.now().toIso8601String()}.db';

      final media = drive.Media(file.openRead(), await file.length());
      final driveFile = drive.File();
      driveFile.name = fileName;
      driveFile.parents = ['appDataFolder'];

      await api.files.create(driveFile, uploadMedia: media);

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
        // Delete the excess oldest files
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
