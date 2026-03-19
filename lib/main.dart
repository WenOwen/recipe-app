import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'data/models/recipe_model.dart';
import 'data/services/settings_service.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/search_page.dart';
import 'presentation/pages/favorites_page.dart';
import 'presentation/pages/profile_page.dart';
import 'presentation/pages/recipe_detail_page.dart';
import 'presentation/pages/ai_kitchen_page.dart';
import 'presentation/pages/add_recipe_page.dart';
import 'presentation/pages/settings_page.dart';
import 'presentation/pages/fridge_page.dart';
import 'presentation/pages/shopping_list_page.dart';
import 'presentation/pages/cook_records_page.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatefulWidget {
  const RecipeApp({super.key});

  @override
  State<RecipeApp> createState() => _RecipeAppState();
}

class _RecipeAppState extends State<RecipeApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final service = await SettingsService.getInstance();
    setState(() {
      _isDarkMode = service.getDarkMode();
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '智能菜谱',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // 路由配置
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => MainNavigation(
                onThemeChanged: _toggleTheme,
              ),
            );
          case '/detail':
            final recipe = settings.arguments as Recipe;
            return MaterialPageRoute(
              builder: (_) => RecipeDetailPage(recipe: recipe),
            );
          case '/search':
            return MaterialPageRoute(
              builder: (_) => const SearchPage(),
            );
          case '/add-recipe':
            return MaterialPageRoute(
              builder: (_) => const AddRecipePage(),
            );
          case '/settings':
            return MaterialPageRoute(
              builder: (_) => SettingsPage(onThemeChanged: _toggleTheme),
            );
          case '/fridge':
            return MaterialPageRoute(
              builder: (_) => const FridgePage(),
            );
          case '/shopping':
            return MaterialPageRoute(
              builder: (_) => const ShoppingListPage(),
            );
          case '/cook-records':
            return MaterialPageRoute(
              builder: (_) => const CookRecordsPage(),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => MainNavigation(
                onThemeChanged: _toggleTheme,
              ),
            );
        }
      },
    );
  }
}

/// 主导航页面（含底部导航栏）
class MainNavigation extends StatefulWidget {
  final VoidCallback? onThemeChanged;

  const MainNavigation({super.key, this.onThemeChanged});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // 页面构建器，切换 tab 时重建页面
  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const AIKitchenPage();
      case 2:
        return const SearchPage();
      case 3:
        return const FavoritesPage();
      case 4:
        return const ProfilePage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(_currentIndex),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'AI厨房',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: '搜索',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: '收藏',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}
