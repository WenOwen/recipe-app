import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shopping_model.dart';

/// 购物清单服务 - 本地存储
class ShoppingService {
  static const String _key = 'shopping_list';
  static ShoppingService? _instance;
  static SharedPreferences? _prefs;

  ShoppingService._();

  static Future<ShoppingService> getInstance() async {
    _instance ??= ShoppingService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  /// 获取所有购物清单
  List<ShoppingItem> getItems() {
    final jsonStr = _prefs?.getString(_key);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    
    try {
      final List<dynamic> jsonList = json.decode(jsonStr);
      return jsonList.map((e) => ShoppingItem.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// 保存清单
  Future<void> saveItems(List<ShoppingItem> items) async {
    final jsonStr = json.encode(items.map((e) => e.toJson()).toList());
    await _prefs?.setString(_key, jsonStr);
  }

  /// 添加物品
  Future<void> addItem(ShoppingItem item) async {
    final items = getItems();
    items.add(item);
    await saveItems(items);
  }

  /// 删除物品
  Future<void> removeItem(String id) async {
    final items = getItems();
    items.removeWhere((e) => e.id == id);
    await saveItems(items);
  }

  /// 切换勾选状态
  Future<void> toggleChecked(String id) async {
    final items = getItems();
    final index = items.indexWhere((e) => e.id == id);
    if (index != -1) {
      items[index] = items[index].copyWith(checked: !items[index].checked);
      await saveItems(items);
    }
  }

  /// 清空已购
  Future<void> clearChecked() async {
    final items = getItems();
    items.removeWhere((e) => e.checked);
    await saveItems(items);
  }

  /// 清空全部
  Future<void> clearAll() async {
    await _prefs?.remove(_key);
  }

  /// 从菜谱添加多个缺失食材
  Future<void> addFromRecipe(String recipeName, List<String> ingredients) async {
    final items = getItems();
    final now = DateTime.now();
    
    for (var name in ingredients) {
      // 避免重复添加
      if (!items.any((e) => e.name == name && !e.checked)) {
        items.add(ShoppingItem(
          id: '${now.millisecondsSinceEpoch}_$name',
          name: name,
          quantity: 1,
          unit: '个',
          fromRecipe: recipeName,
          createdAt: now,
        ));
      }
    }
    
    await saveItems(items);
  }

  /// 获取未购物品数
  int get uncheckedCount {
    return getItems().where((e) => !e.checked).length;
  }
}
