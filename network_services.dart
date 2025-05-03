// services/network_service.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NetworkService extends ChangeNotifier {
  final String _apiUrl =
      'http://your-python-server:5000'; // Update with your server URL
  bool _isMonitoring = false;
  List<NetworkPacket> _packets = [];
  List<NetworkAnomaly> _anomalies = [];
  String _selectedInterface = 'eth0';
  double _timeout = 60;
  String _status = 'Ready';

  // Getters
  bool get isMonitoring => _isMonitoring;
  List<NetworkPacket> get packets => _packets;
  List<NetworkAnomaly> get anomalies => _anomalies;
  String get selectedInterface => _selectedInterface;
  double get timeout => _timeout;
  String get status => _status;

  // Start live monitoring
  Future<void> startMonitoring() async {
    _isMonitoring = true;
    _status = 'Capturing traffic...';
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/start_monitoring'),
        body: json.encode({
          'interface': _selectedInterface,
          'timeout': _timeout,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _processPacketData(data['packets']);
        _processAnomalyData(data['anomalies']);
        _status = 'Monitoring complete';
      } else {
        _status = 'Error: ${response.reasonPhrase}';
      }
    } catch (e) {
      _status = 'Connection error: $e';
    } finally {
      _isMonitoring = false;
      notifyListeners();
    }
  }

  // Process packet data from backend
  void _processPacketData(List<dynamic> packetData) {
    _packets = packetData.map((p) => NetworkPacket.fromJson(p)).toList();
  }

  // Process anomaly data from backend
  void _processAnomalyData(List<dynamic> anomalyData) {
    _anomalies = anomalyData.map((a) => NetworkAnomaly.fromJson(a)).toList();
  }

  // Update settings
  void updateSettings({String? interface, double? timeout}) {
    if (interface != null) _selectedInterface = interface;
    if (timeout != null) _timeout = timeout;
    notifyListeners();
  }

  // Block an IP address
  Future<void> blockIp(String ipAddress) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/block_ip'),
        body: json.encode({'ip_address': ipAddress}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _status = 'Blocked IP: $ipAddress';
      } else {
        _status = 'Failed to block IP: ${response.reasonPhrase}';
      }
    } catch (e) {
      _status = 'Error blocking IP: $e';
    }
    notifyListeners();
  }
}

// Data models
class NetworkPacket {
  final String srcIp;
  final String dstIp;
  final int srcPort;
  final int dstPort;
  final String protocol;
  final int length;
  final double timestamp;
  final bool isAnomaly;

  NetworkPacket({
    required this.srcIp,
    required this.dstIp,
    required this.srcPort,
    required this.dstPort,
    required this.protocol,
    required this.length,
    required this.timestamp,
    required this.isAnomaly,
  });

  factory NetworkPacket.fromJson(Map<String, dynamic> json) {
    return NetworkPacket(
      srcIp: json['src_ip'] ?? '0.0.0.0',
      dstIp: json['dst_ip'] ?? '0.0.0.0',
      srcPort: json['src_port'] ?? 0,
      dstPort: json['dst_port'] ?? 0,
      protocol: json['protocol'] ?? 'UNKNOWN',
      length: json['length'] ?? 0,
      timestamp: json['packet_time']?.toDouble() ?? 0,
      isAnomaly: json['is_anomaly'] ?? false,
    );
  }
}

class NetworkAnomaly {
  final String ipAddress;
  final String reason;
  final double severity;
  final String protocol;
  final int port;

  NetworkAnomaly({
    required this.ipAddress,
    required this.reason,
    required this.severity,
    required this.protocol,
    required this.port,
  });

  factory NetworkAnomaly.fromJson(Map<String, dynamic> json) {
    return NetworkAnomaly(
      ipAddress: json['src_ip'] ?? '0.0.0.0',
      reason: json['reason'] ?? 'Unknown anomaly',
      severity: json['severity']?.toDouble() ?? 0.0,
      protocol: json['protocol'] ?? 'UNKNOWN',
      port: json['src_port'] ?? 0,
    );
  }
}
