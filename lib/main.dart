import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/equipment_service.dart';
import 'screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => EquipmentService()),
      ],
      child: const BackpackBuddyApp(),
    ),
  );
}

class BackpackBuddyApp extends StatelessWidget {
  const BackpackBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backpack Buddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
