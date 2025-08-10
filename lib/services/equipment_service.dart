import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/equipment_item.dart';

class EquipmentService {
  List<EquipmentItem> _items = [];

  Future<List<EquipmentItem>> loadEquipment() async {
    if (_items.isEmpty) {
      final String response = await rootBundle.loadString('assets/checklist.json');
      final List data = json.decode(response);
      _items = data.map((item) => EquipmentItem.fromJson(item)).toList();
    }
    return _items;
  }
}
