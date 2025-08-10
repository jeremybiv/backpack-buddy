import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/equipment_item.dart';
import '../services/equipment_service.dart';
import 'suggestions_screen.dart';

class ChecklistScreen extends StatefulWidget {
  final EquipmentService equipmentService;

  const ChecklistScreen({super.key, required this.equipmentService});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  List<EquipmentItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedItems = await widget.equipmentService.loadEquipment();
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _items = loadedItems;
      for (var item in _items) {
        item.checked = prefs.getBool('checked_${item.title}') ?? false;
        item.notNeeded = prefs.getBool('notNeeded_${item.title}') ?? false;
      }
      _loading = false;
    });
  }

  Future<void> _updateState(EquipmentItem item) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('checked_${item.title}', item.checked);
    await prefs.setBool('notNeeded_${item.title}', item.notNeeded);
  }

  Future<void> _persistAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (var item in _items) {
      await prefs.setBool('checked_${item.title}', item.checked);
      await prefs.setBool('notNeeded_${item.title}', item.notNeeded);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Checklist')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Opacity(
                  opacity: item.notNeeded ? 0.4 : 1.0,
                  child: Card(
                    child: ListTile(
                      title: Text(item.title),
                      subtitle: Text('${item.category} • ${item.weight}g'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Toggle "J'ai"
                          SizedBox(
                            width: 100,
                            child: ToggleButtons(
                              isSelected: [item.checked],
                              onPressed: (index) {
                                setState(() {
                                  item.checked = !item.checked;
                                  if (item.checked) {
                                    item.notNeeded = false;
                                  }
                                });
                                _updateState(item);
                              },
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.blue, // texte off
                              selectedColor: Colors.white, // texte on
                              fillColor: item.checked
                                  ? Colors.green
                                  : Colors.grey[300],
                              selectedBorderColor: Colors.green,
                              borderColor: Colors.grey,
                              constraints: const BoxConstraints(
                                  minHeight: 36, minWidth: 80),
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (item.checked)
                                      const Icon(Icons.check,
                                          size: 16, color: Colors.white),
                                    if (item.checked) const SizedBox(width: 4),
                                    Text(item.checked ? "Ajouté" : "J'ai"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Bouton "Pas besoin"
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: item.notNeeded
                                  ? Colors.grey
                                  : Colors.redAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                item.notNeeded = !item.notNeeded;
                                if (item.notNeeded) {
                                  item.checked = false;
                                }
                              });
                              _updateState(item);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _persistAll();
                  Navigator.of(context).push(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 450),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SuggestionsScreen(items: _items),
                      );
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      final tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: Curves.easeInOut));
                      return SlideTransition(
                          position: animation.drive(tween), child: child);
                    },
                  ));
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  child: Text(
                    "Voir suggestions",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
