import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/equipment_service.dart';
import 'checklist_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            Card(
              child: ListTile(
                title: const Text("Liste Trek 2J - En refuge"),
                subtitle: const Text("23 équipements - 6.4 kg"),
                trailing: const Icon(Icons.check_circle_outline),
                onTap: () {
                  final service = Provider.of<EquipmentService>(context, listen: false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChecklistScreen(equipmentService: service),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Trek bivouac 3 jours"),
                subtitle: const Text("31 équipements - 7.8 kg"),
                trailing: const Icon(Icons.check_circle_outline),
                onTap: () {
                  final service = Provider.of<EquipmentService>(context, listen: false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChecklistScreen(equipmentService: service),
                    ),
                  );
                },
              ),
            ),
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
