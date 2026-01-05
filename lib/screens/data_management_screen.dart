import 'dart:io';
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/live_database.dart';
import 'package:free_cal_counter1/widgets/screen_background.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

class DataManagementScreen extends StatefulWidget {
  const DataManagementScreen({super.key});

  @override
  State<DataManagementScreen> createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends State<DataManagementScreen> {
  bool _isRestoring = false;

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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Database restored successfully!')),
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
                Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    leading: const Icon(Icons.file_upload, color: Colors.blue),
                    title: const Text('Backup Data'),
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
                    title: const Text('Restore Data'),
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
}
