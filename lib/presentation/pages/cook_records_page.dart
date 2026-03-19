import 'package:flutter/material.dart';
import '../../data/models/cook_record_model.dart';
import '../../data/services/cook_record_service.dart';

/// 做菜记录页面
class CookRecordsPage extends StatefulWidget {
  const CookRecordsPage({super.key});

  @override
  State<CookRecordsPage> createState() => _CookRecordsPageState();
}

class _CookRecordsPageState extends State<CookRecordsPage> {
  List<CookRecord> _records = [];
  int _consecutiveDays = 0;
  Map<String, int> _topRecipes = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final service = await CookRecordService.getInstance();
    setState(() {
      _records = service.getRecords();
      _consecutiveDays = service.getConsecutiveDays();
      _topRecipes = service.getTopRecipes();
    });
  }

  Future<void> _deleteRecord(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除记录'),
        content: const Text('确定要删除这条做菜记录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = await CookRecordService.getInstance();
      await service.deleteRecord(id);
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('做菜记录'),
      ),
      body: _records.isEmpty ? _buildEmpty() : _buildContent(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '还没有做菜记录',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '做完菜后可以记录一下',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 统计卡片
        _buildStatsCard(),
        const SizedBox(height: 24),
        // 最常做的菜
        if (_topRecipes.isNotEmpty) ...[
          _buildSectionTitle('最常做的菜'),
          const SizedBox(height: 8),
          _buildTopRecipes(),
          const SizedBox(height: 24),
        ],
        // 记录列表
        _buildSectionTitle('全部记录'),
        const SizedBox(height: 8),
        ..._records.reversed.map((record) => _buildRecordCard(record)),
      ],
    );
  }

  Widget _buildStatsCard() {
    final thisMonth = _records.where((r) {
      final now = DateTime.now();
      return r.cookedAt.year == now.year && r.cookedAt.month == now.month;
    }).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8F5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('本月做菜', '$thisMonth 道'),
          Container(width: 1, height: 40, color: Colors.white30),
          _buildStatItem('累计做菜', '${_records.length} 道'),
          Container(width: 1, height: 40, color: Colors.white30),
          _buildStatItem('连续天数', '$_consecutiveDays 天'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTopRecipes() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: _topRecipes.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(entry.key)),
                  Text(
                    '${entry.value}次',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRecordCard(CookRecord record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getRatingColor(record.rating).withAlpha(30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '${record.rating}星',
              style: TextStyle(
                fontSize: 10,
                color: _getRatingColor(record.rating),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(record.recipeName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDate(record.cookedAt),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            if (record.note != null && record.note!.isNotEmpty)
              Text(
                record.note!,
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, size: 20),
          onPressed: () => _deleteRecord(record.id),
        ),
      ),
    );
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow[700]!;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) {
      return '今天';
    } else if (diff.inDays == 1) {
      return '昨天';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return '${date.month}月${date.day}日';
    }
  }
}
