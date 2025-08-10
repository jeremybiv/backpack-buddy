import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/equipment_item.dart';

/*
Future<List<EquipmentItem>> loadEquipmentItems() async {
  try {
    final jsonString = await rootBundle.loadString('assets/checklist.json');
    print("✅ JSON chargé avec succès !");
    final List jsonData = json.decode(jsonString);
    print("👀 Contenu JSON : $jsonData");
    return jsonData.map((e) => EquipmentItem.fromJson(e)).toList();
  } catch (e) {
    print("❌ Erreur de chargement JSON : $e");
    return [];
  }
}*/

Future<List<EquipmentItem>> loadEquipmentItems() async {
  final jsonString = await rootBundle.loadString('assets/checklist.json');
  final List jsonData = json.decode(jsonString);
  return jsonData.map((e) => EquipmentItem.fromJson(e)).toList();
}
