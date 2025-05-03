import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'network_service.dart';
import 'screens/screen_dashboard.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NetworkService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Troubleshooter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
