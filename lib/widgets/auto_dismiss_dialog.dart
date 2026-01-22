import 'package:flutter/material.dart';

class AutoDismissDialog extends StatefulWidget {
  final Widget content;
  final Duration duration;

  const AutoDismissDialog({
    super.key,
    required this.content,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<AutoDismissDialog> createState() => _AutoDismissDialogState();
}

class _AutoDismissDialogState extends State<AutoDismissDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(widget.duration, () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(content: widget.content);
  }
}
