import 'package:flutter/material.dart';
import '../../models/equipment_item.dart';

class SummaryScreen extends StatelessWidget {
  final List<EquipmentItem> items;

  const SummaryScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final packed = items.where((e) => e.checked).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Mon sac")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...packed.map((item) => ListTile(
                title: Text(item.title),
                subtitle: Text("${item.weight}g • ${item.category}"),
              )),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text("Éditer"),
          )
        ],
      ),
    );
  }
}
