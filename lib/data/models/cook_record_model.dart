/// 做菜记录模型
class CookRecord {
  final String id;
  final String recipeId;
  final String recipeName;
  final DateTime cookedAt;
  final int rating; // 评分 1-5
  final String? note; // 备注
  final List<String>? photos; // 照片（可选）

  CookRecord({
    required this.id,
    required this.recipeId,
    required this.recipeName,
    required this.cookedAt,
    required this.rating,
    this.note,
    this.photos,
  });

  factory CookRecord.fromJson(Map<String, dynamic> json) {
    return CookRecord(
      id: json['id'] ?? '',
      recipeId: json['recipeId'] ?? '',
      recipeName: json['recipeName'] ?? '',
      cookedAt: DateTime.tryParse(json['cookedAt'] ?? '') ?? DateTime.now(),
      rating: json['rating'] ?? 3,
      note: json['note'],
      photos: json['photos'] != null ? List<String>.from(json['photos']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipeId': recipeId,
      'recipeName': recipeName,
      'cookedAt': cookedAt.toIso8601String(),
      'rating': rating,
      'note': note,
      'photos': photos,
    };
  }

  CookRecord copyWith({
    String? id,
    String? recipeId,
    String? recipeName,
    DateTime? cookedAt,
    int? rating,
    String? note,
    List<String>? photos,
  }) {
    return CookRecord(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      recipeName: recipeName ?? this.recipeName,
      cookedAt: cookedAt ?? this.cookedAt,
      rating: rating ?? this.rating,
      note: note ?? this.note,
      photos: photos ?? this.photos,
    );
  }

  /// 评分文字描述
  String get ratingText {
    switch (rating) {
      case 1:
        return '太难了';
      case 2:
        return '一般';
      case 3:
        return '还行';
      case 4:
        return '好吃';
      case 5:
        return '完美！';
      default:
        return '还行';
    }
  }
}
