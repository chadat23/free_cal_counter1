import 'package:shared_preferences/shared_preferences.dart';

class BackupConfigService {
  static const String _keyAutoBackupEnabled = 'backup_auto_enabled';
  static const String _keyRetentionCount = 'backup_retention_count';
  static const String _keyLastBackupTime = 'backup_last_time';
  static const String _keyIsDirty = 'backup_is_dirty';

  // Singleton instance
  static final BackupConfigService instance = BackupConfigService._();
  BackupConfigService._();

  Future<void> setAutoBackupEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoBackupEnabled, enabled);
  }

  Future<bool> isAutoBackupEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAutoBackupEnabled) ?? false;
  }

  Future<void> setRetentionCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyRetentionCount, count);
  }

  Future<int> getRetentionCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyRetentionCount) ?? 7; // Default to 7
  }

  Future<void> markDirty() async {
    final prefs = await SharedPreferences.getInstance();
    // Only write if not already dirty to save IO
    if (prefs.getBool(_keyIsDirty) != true) {
      await prefs.setBool(_keyIsDirty, true);
    }
  }

  Future<void> clearDirty() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsDirty, false);
  }

  Future<bool> isDirty() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsDirty) ?? false;
  }

  Future<void> updateLastBackupTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _keyLastBackupTime,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<DateTime?> getLastBackupTime() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_keyLastBackupTime);
    return ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
  }
}
