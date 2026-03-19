import 'package:flutter/material.dart';
import '../../data/models/shopping_model.dart';
import '../../data/services/shopping_service.dart';

/// 购物清单页面
class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  List<ShoppingItem> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final service = await ShoppingService.getInstance();
    setState(() {
      _items = service.getItems();
    });
  }

  List<ShoppingItem> get _uncheckedItems =>
      _items.where((e) => !e.checked).toList();

  List<ShoppingItem> get _checkedItems =>
      _items.where((e) => e.checked).toList();

  Future<void> _toggleItem(String id) async {
    final service = await ShoppingService.getInstance();
    await service.toggleChecked(id);
    await _loadItems();
  }

  Future<void> _deleteItem(String id) async {
    final service = await ShoppingService.getInstance();
    await service.removeItem(id);
    await _loadItems();
  }

  Future<void> _addItem() async {
    final result = await showDialog<ShoppingItem>(
      context: context,
      builder: (context) => const _AddShoppingItemDialog(),
    );

    if (result != null) {
      final service = await ShoppingService.getInstance();
      await service.addItem(result);
      await _loadItems();
    }
  }

  Future<void> _clearChecked() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空已购'),
        content: const Text('确定要清空所有已勾选的物品吗？'),
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
      final service = await ShoppingService.getInstance();
      await service.clearChecked();
      await _loadItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('购物清单'),
        actions: [
          if (_checkedItems.isNotEmpty)
            TextButton(
              onPressed: _clearChecked,
              child: const Text('清空已购'),
            ),
        ],
      ),
      body: _items.isEmpty ? _buildEmpty() : _buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '购物清单为空',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '智能私厨推荐后可一键添加缺失食材',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 未购物品
        if (_uncheckedItems.isNotEmpty) ...[
          _buildSectionTitle('待购买 (${_uncheckedItems.length})'),
          const SizedBox(height: 8),
          ..._uncheckedItems.map((item) => _buildItem(item, false)),
        ],
        // 已购物品
        if (_checkedItems.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionTitle('已购买 (${_checkedItems.length})'),
          const SizedBox(height: 8),
          ..._checkedItems.map((item) => _buildItem(item, true)),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildItem(ShoppingItem item, bool isChecked) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteItem(item.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Checkbox(
            value: isChecked,
            onChanged: (_) => _toggleItem(item.id),
          ),
          title: Text(
            item.name,
            style: TextStyle(
              decoration: isChecked ? TextDecoration.lineThrough : null,
              color: isChecked ? Colors.grey : null,
            ),
          ),
          subtitle: Text(
            '${item.quantity}${item.unit}${item.fromRecipe != null ? ' · 来自${item.fromRecipe}' : ''}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: () => _deleteItem(item.id),
          ),
        ),
      ),
    );
  }
}

/// 添加购物物品对话框
class _AddShoppingItemDialog extends StatefulWidget {
  const _AddShoppingItemDialog();

  @override
  State<_AddShoppingItemDialog> createState() => _AddShoppingItemDialogState();
}

class _AddShoppingItemDialogState extends State<_AddShoppingItemDialog> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加物品'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: '物品名称',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '数量',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('添加'),
        ),
      ],
    );
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final item = ShoppingItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      quantity: double.tryParse(_quantityController.text) ?? 1,
      unit: '个',
      createdAt: DateTime.now(),
    );

    Navigator.pop(context, item);
  }
}
