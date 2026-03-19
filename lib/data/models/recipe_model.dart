/// 菜谱数据模型
class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final int cookingTime; // 分钟
  final String difficulty; // 简单/中等/困难
  final int servings; // 几人份
  final String category; // 分类：中餐/西餐/日料等
  final List<String> tags; // 标签：下饭、快手、减脂等
  final bool isFavorite;
  final List<String> missingIngredients; // 缺失食材，做这道菜还需要什么
  final String reason; // 推荐理由

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.cookingTime,
    required this.difficulty,
    required this.servings,
    required this.category,
    this.tags = const [],
    this.isFavorite = false,
    this.missingIngredients = const [],
    this.reason = "",
  });

  /// 从 JSON 创建 Recipe
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      steps: List<String>.from(json['steps'] ?? []),
      cookingTime: json['cooking_time'] ?? 0,
      difficulty: json['difficulty'] ?? '简单',
      servings: json['servings'] ?? 2,
      category: json['category'] ?? '中餐',
      tags: List<String>.from(json['tags'] ?? []),
      isFavorite: json['is_favorite'] ?? false,
      missingIngredients: List<String>.from(json['missing_ingredients'] ?? []),
      reason: json['reason'] ?? '',
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'ingredients': ingredients,
      'steps': steps,
      'cooking_time': cookingTime,
      'difficulty': difficulty,
      'servings': servings,
      'category': category,
      'tags': tags,
      'is_favorite': isFavorite,
      'missing_ingredients': missingIngredients,
      'reason': reason,
    };
  }

  /// 创建副本（用于更新收藏状态等）
  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    List<String>? ingredients,
    List<String>? steps,
    int? cookingTime,
    String? difficulty,
    int? servings,
    String? category,
    List<String>? tags,
    bool? isFavorite,
    List<String>? missingIngredients,
    String? reason,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      cookingTime: cookingTime ?? this.cookingTime,
      difficulty: difficulty ?? this.difficulty,
      servings: servings ?? this.servings,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      missingIngredients: missingIngredients ?? this.missingIngredients,
      reason: reason ?? this.reason,
    );
  }
}
