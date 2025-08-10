import 'package:flutter/material.dart';
import '../../models/equipment_item.dart';
import '../../data/equipment_loader.dart';
import 'suggestions_screen.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  late Future<List<EquipmentItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = loadEquipmentItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checklist')),
      body: FutureBuilder<List<EquipmentItem>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final items = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...items.map((item) {
                final isNotNeeded = item.notNeeded;

                return Opacity(
                  opacity: isNotNeeded ? 0.4 : 1.0,
                  child: Card(
                    child: ListTile(
                      title: Text(item.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.category),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Checkbox(
                                value: item.checked,
                                onChanged: isNotNeeded
                                    ? null
                                    : (val) {
                                        setState(() => item.checked = val ?? false);
                                      },
                              ),
                              const Text(
                                "J’ai déjà",
                                style: TextStyle(color: Colors.blue),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    item.notNeeded = !item.notNeeded;

                                    // Si on dit "pas besoin", on décoche automatiquement
                                    if (item.notNeeded) {
                                      item.checked = false;
                                    }
                                  });
                                },
                                icon: const Icon(Icons.delete_outline),
                                label: Text(item.notNeeded ? "Annuler" : " "),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: item.notNeeded ? Colors.grey : Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SuggestionsScreen(items: items)),
                ),
                child: const Text("Voir suggestions"),
              )
            ],
          );
        },
      ),
    );
  }
}
