import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../data/models/recipe_model.dart';
import '../../data/services/api_service.dart';
import '../../core/constants/app_constants.dart';

/// 首页
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  
  String _selectedCategory = '全部';
  String _selectedDifficulty = '全部';
  bool _isLoading = true;
  String? _error;
  List<Recipe> _recipes = [];
  List<Recipe> _recommendedRecipes = [];

  /// 难度选项
  static const List<String> _difficulties = ['全部', '简单', '中等', '困难'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 调用真实 API
      final recipes = await _apiService.getRecipes(
        category: _selectedCategory == '全部' ? null : _selectedCategory,
        difficulty: _selectedDifficulty == '全部' ? null : _selectedDifficulty,
      );
      
      if (!mounted) return;
      
      setState(() {
        _recipes = recipes;
        _recommendedRecipes = recipes.take(5).toList();
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
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? _buildError()
                : RefreshIndicator(
                    onRefresh: _loadData,
                    child: CustomScrollView(
                      slivers: [
                        // 搜索栏
                        SliverToBoxAdapter(
                          child: _buildSearchBar(),
                        ),
                        // 轮播推荐
                        SliverToBoxAdapter(
                          child: _buildCarousel(),
                        ),
                        // 分类选择
                        SliverToBoxAdapter(
                          child: _buildCategoryChips(),
                        ),
                        // 难度选择
                        SliverToBoxAdapter(
                          child: _buildDifficultyChips(),
                        ),
                        // 菜谱网格
                        SliverPadding(
                          padding: const EdgeInsets.all(16),
                          sliver: _buildRecipeGrid(),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '加载失败',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? '未知错误',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          // TODO: 跳转到搜索页
          Navigator.pushNamed(context, '/search');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 12),
              Text(
                '搜索菜谱...',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    if (_recommendedRecipes.isEmpty) return const SizedBox();

    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        viewportFraction: 0.9,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
      ),
      items: _recommendedRecipes.map((recipe) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/detail', arguments: recipe);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFFFF6B35).withAlpha(50),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(180),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.timer, color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.cookingTime}分钟',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.restaurant, color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        recipe.difficulty,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text('分类', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: RecipeCategories.categories.length,
            itemBuilder: (context, index) {
              final category = RecipeCategories.categories[index];
              final isSelected = category == _selectedCategory;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text(
                    '${RecipeCategories.getIcon(category)} $category',
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                    _loadData();
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 难度筛选
  Widget _buildDifficultyChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text('难度', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _difficulties.length,
            itemBuilder: (context, index) {
              final difficulty = _difficulties[index];
              final isSelected = difficulty == _selectedDifficulty;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  avatar: isSelected ? null : _getDifficultyIcon(difficulty),
                  label: Text(difficulty),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedDifficulty = difficulty;
                    });
                    _loadData();
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 获取难度图标
  Widget? _getDifficultyIcon(String difficulty) {
    switch (difficulty) {
      case '简单':
        return const Text('🟢', style: TextStyle(fontSize: 12));
      case '中等':
        return const Text('🟡', style: TextStyle(fontSize: 12));
      case '困难':
        return const Text('🔴', style: TextStyle(fontSize: 12));
      default:
        return null;
    }
  }

  Widget _buildRecipeGrid() {
    if (_recipes.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Text('暂无菜谱'),
        ),
      );
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final recipe = _recipes[index];
          return _RecipeCard(
            recipe: recipe,
            onTap: () {
              Navigator.pushNamed(context, '/detail', arguments: recipe);
            },
          );
        },
        childCount: _recipes.length,
      ),
    );
  }
}

/// 菜谱卡片组件
class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const _RecipeCard({required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片 - 使用本地占位
            Expanded(
              flex: 3,
              child: Container(
                color: const Color(0xFFFF6B35).withAlpha(30),
                child: Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 50,
                    color: const Color(0xFFFF6B35).withAlpha(150),
                  ),
                ),
              ),
            ),
            // 信息
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.timer, size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 2),
                        Text(
                          '${recipe.cookingTime}分钟',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
