import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/equipment_item.dart';
import 'checklist_screen.dart';
import '../services/equipment_service.dart';

class PackingScreen extends StatefulWidget {
  final List<EquipmentItem> items;
  final EquipmentService equipmentService;

  const PackingScreen({
    super.key,
    required this.items,
    required this.equipmentService,
  });

  @override
  State<PackingScreen> createState() => _PackingScreenState();
}

class _PackingScreenState extends State<PackingScreen> {
  Future<void> _updateState(EquipmentItem item) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('checked_${item.title}', item.checked);
  }

  @override
  Widget build(BuildContext context) {
    final packedItems = widget.items.where((i) => i.checked).toList();
    final groupedByCategory = <String, List<EquipmentItem>>{};

    for (var item in packedItems) {
      groupedByCategory.putIfAbsent(item.category, () => []).add(item);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Mode Packing")),
      body: packedItems.isEmpty
          ? const Center(
              child: Text(
                "Aucun équipement sélectionné.\nAjoutez-en depuis la checklist.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                for (var entry in groupedByCategory.entries) ...[
                  Text(
                    entry.key,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  ...entry.value.map(
                    (item) => Card(
                      child: ListTile(
                        title: Text(item.title),
                        subtitle: Text('${item.weight}g'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline,
                              color: Colors.red),
                          onPressed: () {
                            setState(() {
                              item.checked = false;
                            });
                            _updateState(item);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ]
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ChecklistScreen(
                    equipmentService: widget.equipmentService,
                  ),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Text(
                "Éditer la liste",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
