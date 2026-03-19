import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fridge_model.dart';

/// 冰箱管理服务 - 本地存储
class FridgeService {
  static const String _key = 'fridge_items';
  static FridgeService? _instance;
  static SharedPreferences? _prefs;

  FridgeService._();

  static Future<FridgeService> getInstance() async {
    _instance ??= FridgeService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  /// 获取所有冰箱食材
  List<FridgeItem> getItems() {
    final jsonStr = _prefs?.getString(_key);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    
    try {
      final List<dynamic> jsonList = json.decode(jsonStr);
      return jsonList.map((e) => FridgeItem.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// 保存食材列表
  Future<void> saveItems(List<FridgeItem> items) async {
    final jsonStr = json.encode(items.map((e) => e.toJson()).toList());
    await _prefs?.setString(_key, jsonStr);
  }

  /// 添加食材
  Future<void> addItem(FridgeItem item) async {
    final items = getItems();
    items.add(item);
    await saveItems(items);
  }

  /// 删除食材
  Future<void> removeItem(String id) async {
    final items = getItems();
    items.removeWhere((e) => e.id == id);
    await saveItems(items);
  }

  /// 更新食材
  Future<void> updateItem(FridgeItem item) async {
    final items = getItems();
    final index = items.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      items[index] = item;
      await saveItems(items);
    }
  }

  /// 获取食材名称列表（给智能私厨用）
  List<String> getIngredientNames() {
    return getItems().map((e) => e.name).toList();
  }

  /// 按分类获取食材
  Map<String, List<FridgeItem>> getItemsByCategory() {
    final items = getItems();
    final Map<String, List<FridgeItem>> result = {};
    
    for (var category in FridgeCategory.all) {
      result[category] = items.where((e) => e.category == category).toList();
    }
    
    return result;
  }

  /// 清空冰箱
  Future<void> clear() async {
    await _prefs?.remove(_key);
  }
}
