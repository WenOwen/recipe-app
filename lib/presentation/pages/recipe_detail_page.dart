import 'package:flutter/material.dart';
import '../../data/models/recipe_model.dart';
import '../../data/services/favorites_service.dart';

/// 菜谱详情页
class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late Recipe _recipe;
  bool _isFavorite = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final service = await FavoritesService.getInstance();
    setState(() {
      _isFavorite = service.isFavorite(_recipe.id);
      _isLoading = false;
    });
  }

  Future<void> _toggleFavorite() async {
    final service = await FavoritesService.getInstance();
    await service.toggleFavorite(_recipe);
    
    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? '已收藏' : '已取消收藏'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 顶部图片
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFFFF6B35).withAlpha(50),
                child: Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 100,
                    color: const Color(0xFFFF6B35).withAlpha(100),
                  ),
                ),
              ),
            ),
            actions: [
              // 收藏按钮
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: _toggleFavorite,
              ),
              // 分享按钮
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('分享功能开发中...')),
                  );
                },
              ),
            ],
          ),
          // 内容
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    _recipe.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 描述
                  Text(
                    _recipe.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 标签信息
                  _buildInfoRow(),
                  const SizedBox(height: 24),
                  // 食材
                  _buildSectionTitle('食材'),
                  const SizedBox(height: 12),
                  _buildIngredients(_recipe.ingredients),
                  const SizedBox(height: 24),
                  // 步骤
                  _buildSectionTitle('做法'),
                  const SizedBox(height: 12),
                  _buildSteps(_recipe.steps),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildInfoRow() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _InfoChip(
          icon: Icons.timer_outlined,
          label: '${_recipe.cookingTime}分钟',
        ),
        _InfoChip(
          icon: Icons.restaurant_outlined,
          label: _recipe.difficulty,
        ),
        _InfoChip(
          icon: Icons.people_outline,
          label: '${_recipe.servings}人份',
        ),
        _InfoChip(
          icon: Icons.category_outlined,
          label: _recipe.category,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildIngredients(List<String> ingredients) {
    return Column(
      children: ingredients.map((ingredient) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B35),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                ingredient,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSteps(List<String> steps) {
    return Column(
      children: steps.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B35),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${entry.key + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  entry.value,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton.icon(
          onPressed: () {
            // TODO: 跳转 AI 推荐类似菜谱
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('AI 推荐功能开发中...')),
            );
          },
          icon: const Icon(Icons.auto_awesome),
          label: const Text('AI 推荐类似菜谱'),
        ),
      ),
    );
  }
}

/// 信息标签组件
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
