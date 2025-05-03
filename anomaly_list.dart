// widgets/anomaly_list.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../network_service.dart';

class AnomalyList extends StatelessWidget {
  final Function(String) onBlockIp;

  const AnomalyList({super.key, required this.onBlockIp});

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkService>(
      builder: (context, service, child) {
        if (service.anomalies.isEmpty) {
          return const Center(child: Text('No anomalies detected'));
        }

        return ListView.builder(
          itemCount: service.anomalies.length,
          itemBuilder: (context, index) {
            final anomaly = service.anomalies[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
              color: Colors.red[50],
              child: ListTile(
                title: Text('Anomaly from ${anomaly.ipAddress}'),
                subtitle: Text(anomaly.reason),
                trailing: Chip(
                  label: Text(
                    'Severity: ${anomaly.severity.toStringAsFixed(2)}',
                  ),
                  backgroundColor: _getSeverityColor(anomaly.severity),
                ),
                onTap: () {
                  _showAnomalyActions(context, anomaly.ipAddress);
                },
              ),
            );
          },
        );
      },
    );
  }

  Color _getSeverityColor(double severity) {
    if (severity < 0.3) return Colors.orange;
    if (severity < 0.7) return Colors.deepOrange;
    return Colors.red;
  }

  void _showAnomalyActions(BuildContext context, String ipAddress) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Anomaly from $ipAddress'),
          content: const Text('What action would you like to take?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onBlockIp(ipAddress);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Block IP'),
            ),
            TextButton(
              onPressed: () {
                // Add functionality to whitelist IP if needed
                Navigator.pop(context);
              },
              child: const Text('Whitelist IP'),
            ),
          ],
        );
      },
    );
  }
}
