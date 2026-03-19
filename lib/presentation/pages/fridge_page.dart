import 'package:flutter/material.dart';
import '../../data/models/fridge_model.dart';
import '../../data/services/fridge_service.dart';

/// 冰箱管理页面
class FridgePage extends StatefulWidget {
  const FridgePage({super.key});

  @override
  State<FridgePage> createState() => _FridgePageState();
}

class _FridgePageState extends State<FridgePage> {
  final FridgeService _service = FridgeService();
  List<FridgeItem> _items = [];
  String _selectedCategory = '全部';

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final service = await FridgeService.getInstance();
    setState(() {
      _items = service.getItems();
    });
  }

  List<FridgeItem> get _filteredItems {
    if (_selectedCategory == '全部') {
      return _items;
    }
    return _items.where((e) => e.category == _selectedCategory).toList();
  }

  Map<String, List<FridgeItem>> get _itemsByCategory {
    return _service.getItemsByCategory();
  }

  Future<void> _addItem() async {
    final result = await showModalBottomSheet<FridgeItem>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _AddFridgeItemSheet(),
    );

    if (result != null) {
      final service = await FridgeService.getInstance();
      await service.addItem(result);
      await _loadItems();
    }
  }

  Future<void> _deleteItem(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除食材'),
        content: const Text('确定要删除这个食材吗？'),
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
      final service = await FridgeService.getInstance();
      await service.removeItem(id);
      await _loadItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的冰箱'),
        actions: [
          if (_items.isNotEmpty)
            TextButton(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('清空冰箱'),
                    content: const Text('确定要清空所有食材吗？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('清空'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  final service = await FridgeService.getInstance();
                  await service.clear();
                  await _loadItems();
                }
              },
              child: const Text('清空'),
            ),
        ],
      ),
      body: Column(
        children: [
          // 分类筛选
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryChip('全部'),
                ...FridgeCategory.all.map(_buildCategoryChip),
              ],
            ),
          ),
          // 食材列表
          Expanded(
            child: _filteredItems.isEmpty
                ? _buildEmpty()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return _buildItemCard(item);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.kitchen, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '冰箱空空如也',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '点击 + 添加食材',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(FridgeItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getCategoryColor(item.category).withAlpha(30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(item.category),
            color: _getCategoryColor(item.category),
          ),
        ),
        title: Text(item.name),
        subtitle: Text(
          '${item.quantity}${item.unit} · ${item.category}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.isExpired)
              const Chip(
                label: Text('已过期', style: TextStyle(fontSize: 10)),
                backgroundColor: Colors.red,
                labelStyle: TextStyle(color: Colors.white),
                padding: EdgeInsets.zero,
              )
            else if (item.isExpiringSoon)
              const Chip(
                label: Text('快过期', style: TextStyle(fontSize: 10)),
                backgroundColor: Colors.orange,
                labelStyle: TextStyle(color: Colors.white),
                padding: EdgeInsets.zero,
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.grey),
              onPressed: () => _deleteItem(item.id),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '肉类':
        return Colors.red;
      case '蔬菜':
        return Colors.green;
      case '水果':
        return Colors.orange;
      case '蛋类':
        return Colors.amber;
      case '海鲜':
        return Colors.blue;
      case '乳制品':
        return Colors.purple;
      case '主食':
        return Colors.brown;
      case '调料':
        return Colors.grey;
      default:
        return Colors.teal;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '肉类':
        return Icons.set_meal;
      case '蔬菜':
        return Icons.eco;
      case '水果':
        return Icons.apple;
      case '蛋类':
        return Icons.egg;
      case '海鲜':
        return Icons.water;
      case '乳制品':
        return Icons.icecream;
      case '主食':
        return Icons.rice_bowl;
      case '调料':
        return Icons.blender;
      default:
        return Icons.kitchen;
    }
  }
}

/// 添加食材表单
class _AddFridgeItemSheet extends StatefulWidget {
  const _AddFridgeItemSheet();

  @override
  State<_AddFridgeItemSheet> createState() => _AddFridgeItemSheetState();
}

class _AddFridgeItemSheetState extends State<_AddFridgeItemSheet> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  String _selectedCategory = '蔬菜';
  String _selectedUnit = '个';

  final List<String> _units = ['个', '克', '斤', '盒', '袋', '袋'];

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '添加食材',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // 食材名称
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '食材名称',
                hintText: '例如：鸡蛋、番茄',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            // 分类
            const Text('分类', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: FridgeCategory.all.map((cat) {
                return ChoiceChip(
                  label: Text(cat),
                  selected: _selectedCategory == cat,
                  onSelected: (selected) {
                    setState(() => _selectedCategory = cat);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // 数量和单位
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '数量',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedUnit,
                    decoration: const InputDecoration(
                      labelText: '单位',
                      border: OutlineInputBorder(),
                    ),
                    items: _units.map((u) => DropdownMenuItem(
                      value: u,
                      child: Text(u),
                    )).toList(),
                    onChanged: (value) {
                      setState(() => _selectedUnit = value!);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // 提交按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('添加'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入食材名称')),
      );
      return;
    }

    final item = FridgeItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: _selectedCategory,
      quantity: double.tryParse(_quantityController.text) ?? 1,
      unit: _selectedUnit,
      addedAt: DateTime.now(),
    );

    Navigator.pop(context, item);
  }
}
