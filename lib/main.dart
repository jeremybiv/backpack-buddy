
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const BackpackBuddyApp());
}

class BackpackBuddyApp extends StatelessWidget {
  const BackpackBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backpack Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ChecklistScreen(),
    );
  }
}

class EquipmentItem {
  String title;
  String category;
  String link;
  double price;
  int weight;
  int quantity;
  bool checked;

  EquipmentItem({
    required this.title,
    required this.category,
    required this.link,
    required this.price,
    required this.weight,
    required this.quantity,
    required this.checked,
  });

  factory EquipmentItem.fromJson(Map<String, dynamic> json) {
    return EquipmentItem(
      title: json['title'],
      category: json['category'],
      link: json['link'],
      price: json['price'],
      weight: json['weight'],
      quantity: json['quantity'],
      checked: json['checked'],
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'category': category,
    'link': link,
    'price': price,
    'weight': weight,
    'quantity': quantity,
    'checked': checked,
  };
}

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  List<EquipmentItem> items = [];

  @override
  void initState() {
    super.initState();
    loadChecklist();
  }

  Future<void> loadChecklist() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString('checklist');

    if (storedData != null) {
      final decoded = json.decode(storedData) as List;
      setState(() {
        items = decoded.map((item) => EquipmentItem.fromJson(item)).toList();
      });
    } else {
      final data = await rootBundle.loadString('assets/checklist.json');
      final decoded = json.decode(data) as List;
      setState(() {
        items = decoded.map((item) => EquipmentItem.fromJson(item)).toList();
      });
    }
  }

  Future<void> saveChecklist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(items.map((e) => e.toJson()).toList());
    await prefs.setString('checklist', encoded);
  }

  Widget buildCategory(String category) {
    final filtered = items.where((e) => e.category == category).toList();
    if (filtered.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 16),
          child: Text(category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        ...filtered.map((e) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: ListTile(
              title: Text(e.title),
              trailing: Switch(
                value: e.checked,
                onChanged: (val) {
                  setState(() {
                    e.checked = val;
                  });
                  saveChecklist();
                },
              ),
              onTap: () {},
            ),
          ),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = items.map((e) => e.category).toSet().toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Check list")),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          for (var cat in categories) buildCategory(cat),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => SuggestionsScreen(items: items))
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(16),
              ),
              child: const Text("Suggestions produits", style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class SuggestionsScreen extends StatelessWidget {
  final List<EquipmentItem> items;

  const SuggestionsScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final missing = items.where((e) => !e.checked).toList();
    final maybe = items.where((e) => e.checked).toList();

    Widget buildProductCard(EquipmentItem item) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            Container(width: 64, height: 64, color: Colors.grey[300]), // Placeholder image
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("${item.price.toStringAsFixed(2)} €"),
                  Text("${item.weight}g"),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("View Product"),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Suggestions")),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Voila ce qu’on te propose :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          ...missing.map(buildProductCard),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Sûr que t'en as pas besoin ?", style: TextStyle(fontSize: 16)),
          ),
          ...maybe.map(buildProductCard),
        ],
      ),
    );
  }
}
