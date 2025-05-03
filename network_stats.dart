// widgets/network_stats.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../network_service.dart';

class NetworkStats extends StatelessWidget {
  const NetworkStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkService>(
      builder: (context, service, child) {
        final totalPackets = service.packets.length;
        final anomalyCount = service.anomalies.length;
        final anomalyPercentage =
            totalPackets > 0
                ? (anomalyCount / totalPackets * 100).toStringAsFixed(2)
                : '0.00';

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Network Statistics',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('Total Packets', totalPackets.toString()),
                    _buildStatCard('Anomalies', anomalyCount.toString()),
                    _buildStatCard('Anomaly %', '$anomalyPercentage%'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
