// widgets/controls_panel.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../network_service.dart';

class ControlsPanel extends StatelessWidget {
  const ControlsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Network Monitoring Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Consumer<NetworkService>(
              builder: (context, service, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed:
                          service.isMonitoring
                              ? null
                              : () => service.startMonitoring(),
                      child: const Text('Start Monitoring'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add functionality to stop monitoring if needed
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Stop Monitoring'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
