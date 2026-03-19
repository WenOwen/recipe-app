/// 冰箱食材模型
class FridgeItem {
  final String id;
  final String name;
  final String category; // 分类：肉类、蔬菜、水果、调料、主食、乳制品、蛋类、海鲜
  final double quantity;
  final String unit; // 单位：个、克、斤、盒、袋
  final DateTime addedAt;
  final DateTime? expireAt; // 保质期（可选）

  FridgeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.addedAt,
    this.expireAt,
  });

  factory FridgeItem.fromJson(Map<String, dynamic> json) {
    return FridgeItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '其他',
      quantity: (json['quantity'] ?? 1).toDouble(),
      unit: json['unit'] ?? '个',
      addedAt: DateTime.tryParse(json['addedAt'] ?? '') ?? DateTime.now(),
      expireAt: json['expireAt'] != null ? DateTime.tryParse(json['expireAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'addedAt': addedAt.toIso8601String(),
      'expireAt': expireAt?.toIso8601String(),
    };
  }

  FridgeItem copyWith({
    String? id,
    String? name,
    String? category,
    double? quantity,
    String? unit,
    DateTime? addedAt,
    DateTime? expireAt,
  }) {
    return FridgeItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      addedAt: addedAt ?? this.addedAt,
      expireAt: expireAt ?? this.expireAt,
    );
  }

  /// 是否即将过期（3天内）
  bool get isExpiringSoon {
    if (expireAt == null) return false;
    return expireAt!.difference(DateTime.now()).inDays <= 3;
  }

  /// 是否已过期
  bool get isExpired {
    if (expireAt == null) return false;
    return expireAt!.isBefore(DateTime.now());
  }
}

/// 冰箱食材分类
class FridgeCategory {
  static const List<String> all = [
    '肉类',
    '蔬菜',
    '水果',
    '蛋类',
    '海鲜',
    '乳制品',
    '主食',
    '调料',
    '其他',
  ];
}
