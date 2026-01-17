import 'package:flutter/material.dart';
import 'package:free_cal_counter1/widgets/screen_background.dart';
import 'package:free_cal_counter1/config/app_router.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.storage, color: Colors.blue),
            title: const Text('Data Management'),
            subtitle: const Text('Backup and restore your data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Provider.of<NavigationProvider>(
                context,
                listen: false,
              ).goToDataManagement();
              Navigator.pushNamed(context, AppRouter.dataManagementRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.track_changes, color: Colors.green),
            title: const Text('Goals & Targets'),
            subtitle: const Text('Configure calorie and macro targets'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, AppRouter.goalSettingsRoute);
            },
          ),
        ],
      ),
    );
  }
}
