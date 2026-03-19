import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cook_record_model.dart';

/// 做菜记录服务 - 本地存储
class CookRecordService {
  static const String _key = 'cook_records';
  static CookRecordService? _instance;
  static SharedPreferences? _prefs;

  CookRecordService._();

  static Future<CookRecordService> getInstance() async {
    _instance ??= CookRecordService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  /// 获取所有记录
  List<CookRecord> getRecords() {
    final jsonStr = _prefs?.getString(_key);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    
    try {
      final List<dynamic> jsonList = json.decode(jsonStr);
      return jsonList.map((e) => CookRecord.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// 保存记录
  Future<void> saveRecords(List<CookRecord> records) async {
    final jsonStr = json.encode(records.map((e) => e.toJson()).toList());
    await _prefs?.setString(_key, jsonStr);
  }

  /// 添加记录
  Future<void> addRecord(CookRecord record) async {
    final records = getRecords();
    records.add(record);
    await saveRecords(records);
  }

  /// 删除记录
  Future<void> deleteRecord(String id) async {
    final records = getRecords();
    records.removeWhere((e) => e.id == id);
    await saveRecords(records);
  }

  /// 获取本月记录
  List<CookRecord> getThisMonthRecords() {
    final now = DateTime.now();
    return getRecords().where((r) => 
      r.cookedAt.year == now.year && r.cookedAt.month == now.month
    ).toList();
  }

  /// 获取连续做菜天数
  int getConsecutiveDays() {
    final records = getRecords();
    if (records.isEmpty) return 0;

    // 按日期分组
    final Map<int, List<CookRecord>> byDate = {};
    for (var record in records) {
      final day = record.cookedAt.day;
      byDate[day] ??= [];
      byDate[day]!.add(record);
    }

    // 计算连续天数
    int consecutive = 0;
    int expectedDay = DateTime.now().day;
    
    for (int i = 0; i < 30; i++) {
      final checkDay = expectedDay - i;
      if (checkDay < 1) break;
      if (byDate.containsKey(checkDay)) {
        consecutive++;
      } else if (i > 0) {
        break; // 中间断开
      }
    }
    
    return consecutive;
  }

  /// 获取最常做的菜 TOP5
  Map<String, int> getTopRecipes({int limit = 5}) {
    final records = getRecords();
    final Map<String, int> counts = {};
    
    for (var record in records) {
      counts[record.recipeName] = (counts[record.recipeName] ?? 0) + 1;
    }
    
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(sorted.take(limit));
  }

  /// 获取总记录数
  int get totalCount => getRecords().length;
}
