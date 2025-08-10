import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/equipment_item.dart';
import 'package:provider/provider.dart';
import '../services/equipment_service.dart';
import 'packing_screen.dart';


class SuggestionsScreen extends StatelessWidget {
  final List<EquipmentItem> items;

  const SuggestionsScreen({super.key, required this.items});

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final suggestedItems =
        items.where((item) => !item.checked && !item.notNeeded).toList();
    final notNeededItems = items.where((item) => item.notNeeded).toList();
    final equipmentService = Provider.of<EquipmentService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Suggestions')),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          const Text(
            "Voilà ce qu'on te propose",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...suggestedItems.map((item) => Card(
                child: ListTile(
                  title: Text(item.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${item.category} • ${item.weight}g'),
                      if (item.price != null)
                        Text('${item.price!.toStringAsFixed(2)} €'),
                      if (item.link != null && item.link!.isNotEmpty)
                        GestureDetector(
                          onTap: () => _openLink(item.link!),
                          child: Text(
                            item.link!,
                            style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 20),
          const Text(
            "Sûr, tu n'en as pas besoin",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...notNeededItems.map((item) => Card(
                color: Colors.grey[200],
                child: ListTile(
                  title: Text(
                    item.title,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${item.category} • ${item.weight}g',
                          style: const TextStyle(color: Colors.grey)),
                      if (item.price != null)
                        Text('${item.price!.toStringAsFixed(2)} €',
                            style: const TextStyle(color: Colors.grey)),
                      if (item.link != null && item.link!.isNotEmpty)
                        GestureDetector(
                          onTap: () => _openLink(item.link!),
                          child: Text(
                            item.link!,
                            style: const TextStyle(
                              color: Colors.blueGrey,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PackingScreen(
                        items: items,
                        equipmentService: equipmentService,
                      ),
                    ),
                  );
                },
                child: const Text("Voir ma check-list finale"),
              )
        ],
      ),
    );
  }
}
