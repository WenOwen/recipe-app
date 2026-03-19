import 'package:flutter/material.dart';
import '../../data/services/settings_service.dart';

/// 设置页面
class SettingsPage extends StatefulWidget {
  final VoidCallback? onThemeChanged;

  const SettingsPage({super.key, this.onThemeChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  int _cacheSize = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final service = await SettingsService.getInstance();
    setState(() {
      _darkMode = service.getDarkMode();
      _cacheSize = 12; // MB
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    final service = await SettingsService.getInstance();
    await service.setDarkMode(value);
    setState(() {
      _darkMode = value;
    });
    widget.onThemeChanged?.call();
  }

  Future<void> _clearCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除缓存'),
        content: const Text('确定要清除所有缓存吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('清除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _cacheSize = 0);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('缓存已清除')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          // 外观设置
          _buildSectionTitle('外观'),
          SwitchListTile(
            title: const Text('深色模式'),
            subtitle: const Text('切换深色/浅色主题'),
            value: _darkMode,
            onChanged: _toggleDarkMode,
            secondary: Icon(
              _darkMode ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
          const Divider(),

          // 存储设置
          _buildSectionTitle('存储'),
          ListTile(
            title: const Text('清除缓存'),
            subtitle: Text('当前缓存 ${_cacheSize}MB'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _clearCache,
          ),
          const Divider(),

          // 关于
          _buildSectionTitle('关于'),
          const ListTile(
            title: Text('版本'),
            subtitle: Text('1.0.0'),
          ),
          ListTile(
            title: const Text('关于我们'),
            subtitle: const Text('智能菜谱推荐 App'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: '智能菜谱',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2026 智能菜谱团队',
              );
            },
          ),
          ListTile(
            title: const Text('开放源代码许可'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: '智能菜谱',
                applicationVersion: '1.0.0',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
