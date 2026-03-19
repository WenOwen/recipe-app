import 'package:flutter/material.dart';
import '../../data/services/favorites_service.dart';

/// 个人中心页
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _favoriteCount = 0;
  int _publishedCount = 0;
  int _cookedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final service = await FavoritesService.getInstance();
    setState(() {
      _favoriteCount = service.getFavorites().length;
      _publishedCount = 0; // TODO: 从后端获取
      _cookedCount = 0;    // TODO: 从后端获取
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 用户信息卡片
            _buildUserCard(),
            const SizedBox(height: 24),
            // 统计信息
            _buildStatsRow(),
            const SizedBox(height: 24),
            // 菜单列表
            _buildMenuList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8F5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withAlpha(80),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // 头像
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: Color(0xFFFF6B35),
            ),
          ),
          const SizedBox(width: 16),
          // 用户名和简介
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '美食爱好者',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '编辑个人简介...',
                  style: TextStyle(
                    color: Colors.white.withAlpha(200),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.white.withAlpha(200),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(count: '$_favoriteCount', label: '收藏'),
        _VerticalDivider(),
        _StatItem(count: '$_publishedCount', label: '发布'),
        _VerticalDivider(),
        _StatItem(count: '$_cookedCount', label: '做过'),
      ],
    );
  }

  Widget _buildMenuList(BuildContext context) {
    final menus = [
      _MenuItem(
        icon: Icons.kitchen,
        title: '我的冰箱',
        onTap: () {
          Navigator.pushNamed(context, '/fridge');
        },
      ),
      _MenuItem(
        icon: Icons.shopping_cart,
        title: '购物清单',
        onTap: () {
          Navigator.pushNamed(context, '/shopping');
        },
      ),
      _MenuItem(
        icon: Icons.restaurant,
        title: '做菜记录',
        onTap: () {
          Navigator.pushNamed(context, '/cook-records');
        },
      ),
      _MenuItem(
        icon: Icons.add_circle_outline,
        title: '发布菜谱',
        onTap: () {
          Navigator.pushNamed(context, '/add-recipe');
        },
      ),
      _MenuItem(
        icon: Icons.restaurant_menu,
        title: '我的发布',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('我的发布功能开发中...')),
          );
        },
      ),
      _MenuItem(
        icon: Icons.history,
        title: '做过的菜',
        onTap: () {
          Navigator.pushNamed(context, '/cook-records');
        },
      ),
      _MenuItem(
        icon: Icons.workspace_premium,
        title: '成就',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('成就功能开发中...')),
          );
        },
      ),
      _MenuItem(
        icon: Icons.help_outline,
        title: '帮助与反馈',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('帮助与反馈功能开发中...')),
          );
        },
      ),
    ];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: menus.asMap().entries.map((entry) {
          final index = entry.key;
          final menu = entry.value;
          return Column(
            children: [
              ListTile(
                leading: Icon(menu.icon, color: const Color(0xFFFF6B35)),
                title: Text(menu.title),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: menu.onTap,
              ),
              if (index < menus.length - 1)
                const Divider(height: 1, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;

  const _StatItem({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF6B35),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[300],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
