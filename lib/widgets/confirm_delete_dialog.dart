import 'package:flutter/material.dart';

/// Shows a confirmation dialog before deleting selected portions
///
/// Returns true if the user confirms deletion, false otherwise.
///
/// Example usage:
/// ```dart
/// final confirmed = await showConfirmDeleteDialog(
///   context,
///   count: logProvider.selectedPortionCount,
/// );
///
/// if (confirmed == true) {
///   await logProvider.deleteSelectedPortions();
/// }
/// ```
Future<bool?> showConfirmDeleteDialog(BuildContext context, {int count = 1}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete selected items?'),
        content: Text(
          count == 1
              ? 'Are you sure you want to delete this item?'
              : 'Are you sure you want to delete $count items?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
