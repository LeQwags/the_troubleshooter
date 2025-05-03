// widgets/packet_list.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../network_service.dart';

class PacketList extends StatelessWidget {
  const PacketList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkService>(
      builder: (context, service, child) {
        if (service.packets.isEmpty) {
          return const Center(child: Text('No network traffic captured yet'));
        }

        return ListView.builder(
          itemCount: service.packets.length,
          itemBuilder: (context, index) {
            final packet = service.packets[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
              color: packet.isAnomaly ? Colors.red[50] : null,
              child: ListTile(
                title: Text('${packet.protocol} Packet'),
                subtitle: Text(
                  '${packet.srcIp}:${packet.srcPort} → ${packet.dstIp}:${packet.dstPort}',
                ),
                trailing: Text('${packet.length} bytes'),
                onTap: () {
                  _showPacketDetails(context, packet);
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showPacketDetails(BuildContext context, NetworkPacket packet) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Packet Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Source IP', packet.srcIp),
                _buildDetailRow('Destination IP', packet.dstIp),
                _buildDetailRow('Source Port', packet.srcPort.toString()),
                _buildDetailRow('Destination Port', packet.dstPort.toString()),
                _buildDetailRow('Protocol', packet.protocol),
                _buildDetailRow('Length', '${packet.length} bytes'),
                _buildDetailRow(
                  'Timestamp',
                  packet.timestamp.toStringAsFixed(6),
                ),
                _buildDetailRow('Anomaly', packet.isAnomaly ? 'Yes' : 'No'),
              ],
            ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
