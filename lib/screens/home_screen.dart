// Dart

// lib/screens/home_screen.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/equipment_service.dart';
import 'checklist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> checklists = [];

  @override
  void initState() {
    super.initState();
    loadChecklists();
  }

  Future<void> loadChecklists() async {
    List<Map<String, dynamic>> loaded = [];

    // Always load the main checklist.json
    try {
      final mainData = await rootBundle.loadString('assets/checklist.json');
      loaded.add({'title': 'Trekking 3 jours', 'path': 'assets/checklist.json', 'data': json.decode(mainData)});
    } catch (e) {
      // ignore
    }

    // Discover other checklist assets by reading the Flutter asset manifest.
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      final checklistAssets = manifestMap.keys
          .where((k) => k.endsWith('-checklist.json') || k.endsWith('checklist.json'))
          .where((k) => k != 'assets/checklist.json')
          .toList();

      for (final assetPath in checklistAssets) {
        try {
          final data = await rootBundle.loadString(assetPath);
          // Use a nicer title from filename
          final fileName = assetPath.split('/').last;
          final title = fileName.replaceAll('-checklist.json', '').replaceAll('.json', '').replaceAll('-', ' ').trim();
          loaded.add({'title': _capitalizeEachWord(title), 'path': assetPath, 'data': json.decode(data)});
        } catch (_) {
          // ignore missing/invalid
        }
      }
    } catch (_) {
      // If AssetManifest.json unavailable, fallback to a small hardcoded list
      final dynamicFiles = [
        'assets/trail-1d-checklist.json',
      ];
      for (final path in dynamicFiles) {
        try {
          final data = await rootBundle.loadString(path);
          final fileName = path.split('/').last;
          final title = fileName.replaceAll('-checklist.json', '').replaceAll('.json', '').replaceAll('-', ' ').trim();
          loaded.add({'title': _capitalizeEachWord(title), 'path': path, 'data': json.decode(data)});
        } catch (_) {}
      }
    }

    setState(() {
      checklists = loaded;
    });
  }

  String _capitalizeEachWord(String s) {
    return s.split(' ').map((w) => w.isEmpty ? w : (w[0].toUpperCase() + w.substring(1))).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backpack Buddy')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Mes listes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Show a card per checklist
            ...checklists.map((checklist) {
              return Card(
                child: ListTile(
                  title: Text(checklist['title'] ?? 'Checklist'),
                  subtitle: Text('${(checklist['data'] as List?)?.length ?? 0} équipements'),
                  trailing: const Icon(Icons.check_circle_outline),
                  onTap: () {
                    final service = Provider.of<EquipmentService>(context, listen: false);
                    // If the checklist asset is not the main one, we need to load its items into the service
                    if (checklist['path'] != null && checklist['path'] != 'assets/checklist.json') {
                      // Replace service load by directly setting items in a temporary EquipmentService wrapper is more involved.
                      // Simpler approach: navigate to a ChecklistScreen that accepts preloaded data.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChecklistScreen(equipmentService: service),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChecklistScreen(equipmentService: service),
                        ),
                      );
                    }
                  },
                ),
              );
            }).toList(),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                final service = Provider.of<EquipmentService>(context, listen: false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChecklistScreen(equipmentService: service),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Créer une nouvelle liste"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}