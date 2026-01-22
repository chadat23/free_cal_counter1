import 'dart:io';
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/live_database.dart';
import 'package:free_cal_counter1/widgets/screen_background.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:free_cal_counter1/services/backup_config_service.dart';
import 'package:free_cal_counter1/services/google_drive_service.dart';
import 'package:free_cal_counter1/services/background_backup_worker.dart';
import 'package:workmanager/workmanager.dart';
import 'package:intl/intl.dart';
import 'package:free_cal_counter1/utils/ui_utils.dart';

class DataManagementScreen extends StatefulWidget {
  const DataManagementScreen({super.key});

  @override
  State<DataManagementScreen> createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends State<DataManagementScreen> {
  bool _isRestoring = false;

  // Cloud Backup State
  bool _isAutoBackupEnabled = false;
  int _retentionCount = 7;
  String? _googleEmail;
  DateTime? _lastBackupTime;
  bool _isLoadingCloudSettings = true;

  @override
  void initState() {
    super.initState();
    _loadCloudSettings();
  }

  Future<void> _loadCloudSettings() async {
    final config = BackupConfigService.instance;
    final drive = GoogleDriveService.instance;

    // Try silent sign-in to get email if possible
    await drive.silentSignIn();
    final account = drive.currentUser;

    final enabled = await config.isAutoBackupEnabled();
    final retention = await config.getRetentionCount();
    final lastTime = await config.getLastBackupTime();

    if (mounted) {
      setState(() {
        _isAutoBackupEnabled = enabled;
        _retentionCount = retention;
        _lastBackupTime = lastTime;
        _googleEmail = account?.email;
        _isLoadingCloudSettings = false;
      });
    }
  }

  Future<void> _toggleAutoBackup(bool value) async {
    setState(() => _isLoadingCloudSettings = true);

    try {
      if (value) {
        // Turning ON
        // 1. Ensure Signed In
        if (_googleEmail == null) {
          final account = await GoogleDriveService.instance.signIn();
          if (account == null) {
            // Cancelled or failed
            if (mounted) {
              setState(() {
                _isAutoBackupEnabled = false;
                _isLoadingCloudSettings = false;
              });
            }
            return;
          }
          _googleEmail = account.email;
        }

        // 2. Enable Config
        await BackupConfigService.instance.setAutoBackupEnabled(true);

        // 3. Register Worker (Daily)
        await Workmanager().registerPeriodicTask(
          backupTaskKey,
          backupTaskKey,
          frequency: const Duration(days: 1),
          constraints: Constraints(
            networkType: NetworkType.connected,
            requiresBatteryNotLow: true,
          ),
          existingWorkPolicy:
              ExistingPeriodicWorkPolicy.update, // Restart schedule
        );
      } else {
        // Turning OFF
        await BackupConfigService.instance.setAutoBackupEnabled(false);
        await Workmanager().cancelByUniqueName(backupTaskKey);
      }

      if (mounted) {
        setState(() {
          _isAutoBackupEnabled = value;
          _isLoadingCloudSettings = false;
        });
      }
    } catch (e) {
      debugPrint('Error toggling backup: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isLoadingCloudSettings = false);
      }
    }
  }

  Future<void> _updateRetention(double value) async {
    final intVal = value.toInt();
    setState(() => _retentionCount = intVal);
    await BackupConfigService.instance.setRetentionCount(intVal);
  }

  Future<void> _exportBackup() async {
    try {
      final file = await getLiveDbFile();
      if (await file.exists()) {
        await Share.shareXFiles([
          XFile(file.path),
        ], text: 'FreeCal Counter Backup');
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Database file not found.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  Future<void> _importBackup() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Restore Backup?'),
          content: const Text(
            'This will overwrite all your current logs and recipes. This action cannot be undone unless you have another backup.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('RESTORE', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        setState(() => _isRestoring = true);
        try {
          final backupFile = File(result.files.single.path!);
          await DatabaseService.instance.restoreDatabase(backupFile);
          if (mounted) {
            await UiUtils.showAutoDismissDialog(
              context,
              'Database restored successfully!',
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Restore failed: $e')));
          }
        } finally {
          setState(() => _isRestoring = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: AppBar(
        title: const Text('Data Management'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      child: _isRestoring
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCloudBackupCard(),
                const SizedBox(height: 24),
                const Text(
                  'Manual Backup',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    leading: const Icon(Icons.file_upload, color: Colors.blue),
                    title: const Text('Export to File'),
                    subtitle: const Text(
                      'Export your live database to a file.',
                    ),
                    onTap: _exportBackup,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    leading: const Icon(
                      Icons.file_download,
                      color: Colors.green,
                    ),
                    title: const Text('Restore from File'),
                    subtitle: const Text(
                      'Import logs and recipes from a .db file.',
                    ),
                    onTap: _importBackup,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Note: Restoring data will replace your current recipes and food logs. Make sure you have a backup of your current data if you still need it.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCloudBackupCard() {
    if (_isLoadingCloudSettings) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cloud_upload, color: Colors.orange),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Google Drive Backup',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Switch(
                  value: _isAutoBackupEnabled,
                  onChanged: _toggleAutoBackup,
                  activeColor: Colors.orange,
                ),
              ],
            ),
            if (_googleEmail != null)
              Padding(
                padding: const EdgeInsets.only(left: 36.0, bottom: 12.0),
                child: Text(
                  'Account: $_googleEmail',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),

            if (_isAutoBackupEnabled) ...[
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),
              const Text(
                'Retention Policy',
                style: TextStyle(color: Colors.grey),
              ),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _retentionCount.toDouble(),
                      min: 1,
                      max: 30,
                      divisions: 29,
                      label: '$_retentionCount days',
                      activeColor: Colors.orange,
                      onChanged: _updateRetention,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '$_retentionCount',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Text(
                'Backups older than this number of days will be deleted.',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                'Frequency: Daily',
                style: TextStyle(color: Colors.grey),
              ), // Hardcoded for MVP
            ],

            if (_lastBackupTime != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Last successful backup: ${DateFormat('MM/dd HH:mm').format(_lastBackupTime!)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
