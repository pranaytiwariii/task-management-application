import 'package:flutter/material.dart';
import '../config/theme.dart';

class OfflineIndicator extends StatelessWidget {
  final bool isOnline;

  const OfflineIndicator({Key? key, required this.isOnline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isOnline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.red.shade300,
      child: Row(
        children: [
          const Icon(Icons.cloud_off, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'You are offline. Some features may be limited.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
