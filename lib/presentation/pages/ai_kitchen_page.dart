import 'package:flutter/material.dart';
import '../../data/models/recipe_model.dart';
import '../../data/services/api_service.dart';
import '../../data/services/favorites_service.dart';

/// 智能私厨 - 根据食材推荐菜谱
class AIKitchenPage extends StatefulWidget {
  const AIKitchenPage({super.key});

  @override
  State<AIKitchenPage> createState() => _AIKitchenPageState();
}

class _AIKitchenPageState extends State<AIKitchenPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _ingredientController = TextEditingController();
  final List<String> _selectedIngredients = [];
  
  // 可选偏好
  String? _selectedTaste;
  String? _selectedDiet;
  int _selectedCount = 3; // 默认推荐3个
  
  List<Recipe> _recommendations = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _error;

  final List<String> _tasteOptions = ['辣', '清淡', '甜', '酸', '咸'];
  final List<String> _dietOptions = ['素食', '低糖', '低脂', '无辣', '清真'];

  // 常用食材快捷添加
  final List<String> _quickIngredients = [
    '鸡蛋', '番茄', '鸡肉', '牛肉', '猪肉',
    '土豆', '洋葱', '胡萝卜', '青椒', '豆腐',
    '米饭', '面条', '白菜', '菠菜', '大蒜',
  ];

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  void _addIngredient(String ingredient) {
    final trimmed = ingredient.trim();
    if (trimmed.isNotEmpty && !_selectedIngredients.contains(trimmed)) {
      setState(() {
        _selectedIngredients.add(trimmed);
        _ingredientController.clear();
      });
    }
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      _selectedIngredients.remove(ingredient);
    });
  }

  Future<void> _getRecommendations() async {
    if (_selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请至少添加一种食材')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _hasSearched = true;
    });

    try {
      final recipes = await _apiService.getAIRecommendations(
        ingredients: _selectedIngredients,
        taste: _selectedTaste,
        diet: _selectedDiet,
        count: _selectedCount,
      );

      if (!mounted) return;

      setState(() {
        _recommendations = recipes;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('智能私厨'),
        actions: [
          if (_selectedIngredients.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedIngredients.clear();
                  _recommendations.clear();
                  _hasSearched = false;
                  _selectedCount = 3;
                });
              },
              icon: const Icon(Icons.clear_all),
              label: const Text('清空'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 说明文字
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, color: Color(0xFFFF6B35)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '输入你冰箱里有的食材，智能私厨为你推荐合适的菜谱',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 食材输入
            const Text(
              '我的食材',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // 已选食材标签
            if (_selectedIngredients.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedIngredients.map((ing) {
                  return Chip(
                    label: Text(ing),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => _removeIngredient(ing),
                    backgroundColor: const Color(0xFFFF6B35).withAlpha(30),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // 输入框
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ingredientController,
                    decoration: InputDecoration(
                      hintText: '输入食材，按回车添加',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: _addIngredient,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: () => _addIngredient(_ingredientController.text),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 快捷食材
            const Text(
              '快捷添加',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickIngredients
                  .where((ing) => !_selectedIngredients.contains(ing))
                  .take(10)
                  .map((ing) {
                return ActionChip(
                  label: Text(ing),
                  onPressed: () => _addIngredient(ing),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // 口味偏好
            const Text(
              '口味偏好（可选）',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('不限'),
                  selected: _selectedTaste == null,
                  onSelected: (selected) {
                    setState(() => _selectedTaste = null);
                  },
                ),
                ..._tasteOptions.map((taste) {
                  return ChoiceChip(
                    label: Text(taste),
                    selected: _selectedTaste == taste,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTaste = selected ? taste : null;
                      });
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),

            // 饮食限制
            const Text(
              '饮食限制（可选）',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('无限制'),
                  selected: _selectedDiet == null,
                  onSelected: (selected) {
                    setState(() => _selectedDiet = null);
                  },
                ),
                ..._dietOptions.map((diet) {
                  return ChoiceChip(
                    label: Text(diet),
                    selected: _selectedDiet == diet,
                    onSelected: (selected) {
                      setState(() {
                        _selectedDiet = selected ? diet : null;
                      });
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),

            // 推荐数量
            const Text(
              '推荐数量',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [1, 2, 3].map((num) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text('$num 个'),
                    selected: _selectedCount == num,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCount = num;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // 推荐按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _getRecommendations,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(_isLoading ? '智能推荐中...' : '智能推荐菜谱'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 推荐结果
            if (_hasSearched) ...[
              const Divider(),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    '推荐结果',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_recommendations.length} 个菜谱',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              if (_error != null)
                _buildError()
              else if (_recommendations.isEmpty)
                _buildEmpty()
              else
                _buildRecommendationsList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '推荐失败',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? '未知错误',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _getRecommendations,
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '没有找到合适的菜谱',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '试试添加更多食材',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsList() {
    return Column(
      children: _recommendations.map((recipe) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/detail', arguments: recipe);
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // 占位图
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35).withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.restaurant,
                          size: 40,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    recipe.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (recipe.tags.contains('智能推荐'))
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6B35).withAlpha(30),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      '智能',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFFFF6B35),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              recipe.description,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.timer, size: 14, color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Text(
                                  '${recipe.cookingTime}分钟',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.restaurant, size: 14, color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Text(
                                  recipe.difficulty,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // 收藏按钮
                      FutureBuilder<bool>(
                        future: FavoritesService.getInstance().then((s) => s.isFavorite(recipe.id)),
                        builder: (context, snapshot) {
                          final isFav = snapshot.data ?? false;
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.grey,
                            ),
                            onPressed: () async {
                              final service = await FavoritesService.getInstance();
                              await service.toggleFavorite(recipe);
                              setState(() {}); // 刷新列表
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isFav ? '已取消收藏' : '已收藏'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  // 推荐理由
                  if (recipe.reason.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(25),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb_outline, size: 14, color: Colors.green),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              recipe.reason,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  // 缺失食材
                  if (recipe.missingIngredients.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        Text(
                          '还需：',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        ...recipe.missingIngredients.take(4).map((ing) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.withAlpha(25),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              ing,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.orange[800],
                              ),
                            ),
                          );
                        }),
                        if (recipe.missingIngredients.length > 4)
                          Text(
                            '+${recipe.missingIngredients.length - 4}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // 收藏按钮
                  FutureBuilder<bool>(
                    future: FavoritesService.getInstance().then((s) => s.isFavorite(recipe.id)),
                    builder: (context, snapshot) {
                      final isFav = snapshot.data ?? false;
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                        ),
                        onPressed: () async {
                          final service = await FavoritesService.getInstance();
                          await service.toggleFavorite(recipe);
                          setState(() {}); // 刷新列表
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isFav ? '已取消收藏' : '已收藏'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
