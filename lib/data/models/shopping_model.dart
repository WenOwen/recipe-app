/// 购物清单模型
class ShoppingItem {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final String? fromRecipe; // 来自哪个菜谱推荐
  final bool checked;
  final DateTime createdAt;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    this.fromRecipe,
    this.checked = false,
    required this.createdAt,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      quantity: (json['quantity'] ?? 1).toDouble(),
      unit: json['unit'] ?? '个',
      fromRecipe: json['fromRecipe'],
      checked: json['checked'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'fromRecipe': fromRecipe,
      'checked': checked,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ShoppingItem copyWith({
    String? id,
    String? name,
    double? quantity,
    String? unit,
    String? fromRecipe,
    bool? checked,
    DateTime? createdAt,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      fromRecipe: fromRecipe ?? this.fromRecipe,
      checked: checked ?? this.checked,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
