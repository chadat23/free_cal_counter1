import 'package:workmanager/workmanager.dart';
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/services/backup_config_service.dart';
import 'package:free_cal_counter1/services/google_drive_service.dart';
import 'package:free_cal_counter1/services/live_database.dart';

const String backupTaskKey = "com.free_cal_counter1.backupTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == backupTaskKey) {
      debugPrint("Starting background backup task...");

      try {
        final config = BackupConfigService.instance;
        final isEnabled = await config.isAutoBackupEnabled();

        if (!isEnabled) {
          debugPrint("Auto backup disabled. Skipping.");
          return Future.value(true);
        }

        final isDirty = await config.isDirty();
        if (!isDirty) {
          debugPrint("Database not dirty. Skipping backup.");
          return Future.value(true);
        }

        final driveService = GoogleDriveService.instance;
        final account = await driveService.refreshCurrentUser();

        if (account == null) {
          debugPrint("Not signed in to Google. Cannot backup.");
          return Future.value(true);
        }

        final dbFile = await getLiveDbFile();
        if (!dbFile.existsSync()) {
          debugPrint("Live database file not found.");
          return Future.value(true);
        }

        final retention = await config.getRetentionCount();
        final success = await driveService.uploadBackup(
          dbFile,
          retentionCount: retention,
        );

        if (success) {
          await config.clearDirty();
          await config.updateLastBackupTime();
          debugPrint("Backup successful!");
        } else {
          debugPrint("Backup failed during upload.");
          return Future.value(false); // Retry
        }
      } catch (e) {
        debugPrint("Background Backup Error: $e");
        return Future.value(false);
      }
    }
    return Future.value(true);
  });
}
