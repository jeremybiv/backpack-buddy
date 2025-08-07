import 'package:flutter/material.dart';
import '../../models/equipment_item.dart';
import 'summary_screen.dart';

class SuggestionsScreen extends StatelessWidget {
  final List<EquipmentItem> items;

  const SuggestionsScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final suggestions = items.where((e) => !e.checked && !e.notNeeded).toList();
    final notNeeded = items.where((e) => e.notNeeded).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Suggestions")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Voilà ce qu’on te propose", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...suggestions.map((item) => ListTile(
                leading: item.image != null ? Image.network(item.image!, width: 40, height: 40) : null,
                title: Text(item.title),
                subtitle: Text("${item.price} € • ${item.weight}g"),
              )),
          const SizedBox(height: 24),
          const Text("Sûr que tu n’en as pas besoin ?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...notNeeded.map((item) => ListTile(
                leading: Icon(Icons.remove_circle_outline),
                title: Text(item.title),
              )),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SummaryScreen(items: items)),
            ),
            child: const Text("Voir mon sac"),
          )
        ],
      ),
    );
  }
}
