import 'package:flutter/material.dart';
import 'screens/checklist_screen.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savedLists = ['Liste 1 - Week-end', 'Liste 2 - Bivouac 4 jours'];

    return Scaffold(
      appBar: AppBar(title: const Text('Backpack Buddy')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Mes listes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...savedLists.map((listName) => ListTile(
                title: Text(listName),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChecklistScreen()),
                  );
                },
              )),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChecklistScreen()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text("Créer une nouvelle liste"),
          ),
        ],
      ),
    );
  }
}
