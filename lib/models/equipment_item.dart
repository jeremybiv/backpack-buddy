class EquipmentItem {
  final String title;
  final String category;
  final String link;
  final double price;
  final int weight;
  final int quantity;
  bool checked;
  bool notNeeded;
  final String? image;

  EquipmentItem({
    required this.title,
    required this.category,
    required this.link,
    required this.price,
    required this.weight,
    required this.quantity,
    required this.checked,
    required this.notNeeded,
    this.image,
  });

  factory EquipmentItem.fromJson(Map<String, dynamic> json) => EquipmentItem(
        title: json['title'],
        category: json['category'],
        link: json['link'],
        price: (json['price'] ?? 0).toDouble(),
        weight: json['weight'],
        quantity: json['quantity'],
        checked: json['checked'],
        notNeeded: json['notNeeded'] ?? false,
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'category': category,
        'link': link,
        'price': price,
        'weight': weight,
        'quantity': quantity,
        'checked': checked,
        'notNeeded': notNeeded,
        'image': image,
      };
}
