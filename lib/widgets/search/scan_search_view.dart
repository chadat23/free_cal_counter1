import 'package:flutter/material.dart';

class ScanSearchView extends StatelessWidget {
  const ScanSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_scanner, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Scan Tab Placeholder',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
