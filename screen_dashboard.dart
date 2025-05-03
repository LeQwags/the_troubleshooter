// screens/dashboard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/anomaly_list.dart';
import '../../widgets/controls_panel.dart';
import '../../widgets/network_stats.dart';
import '../../widgets/packet_list.dart';
import '../network_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Troubleshooter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status bar
            Consumer<NetworkService>(
              builder: (context, service, child) {
                return Text(
                  service.status,
                  style: TextStyle(
                    color: service.isMonitoring ? Colors.green : Colors.grey,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Controls panel
            const ControlsPanel(),
            const SizedBox(height: 24),

            // Network stats
            const Expanded(flex: 1, child: NetworkStats()),
            const SizedBox(height: 16),

            // Tabbed view for packets and anomalies
            Expanded(
              flex: 3,
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Network Traffic'),
                        Tab(text: 'Anomalies'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          const PacketList(),
                          AnomalyList(
                            onBlockIp:
                                (ip) =>
                                    context.read<NetworkService>().blockIp(ip),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    final service = context.read<NetworkService>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Network Interface',
                ),
                controller: TextEditingController(
                  text: service.selectedInterface,
                ),
                onChanged: (value) => service.updateSettings(interface: value),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Capture Timeout (seconds)',
                ),
                controller: TextEditingController(
                  text: service.timeout.toString(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final timeout = double.tryParse(value);
                  if (timeout != null) {
                    service.updateSettings(timeout: timeout);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
