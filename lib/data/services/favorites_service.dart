import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';
import '../../core/constants/app_constants.dart';

/// 收藏服务 - 使用 shared_preferences 持久化
class FavoritesService {
  static FavoritesService? _instance;
  static SharedPreferences? _prefs;

  FavoritesService._();

  static Future<FavoritesService> getInstance() async {
    if (_instance == null) {
      _instance = FavoritesService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  /// 获取所有收藏
  List<Recipe> getFavorites() {
    final jsonString = _prefs?.getString(StorageKeys.favorites) ?? '[]';
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((j) => Recipe.fromJson(j)).toList();
  }

  /// 保存所有收藏
  Future<bool> saveFavorites(List<Recipe> favorites) async {
    final jsonString = json.encode(favorites.map((r) => r.toJson()).toList());
    return await _prefs?.setString(StorageKeys.favorites, jsonString) ?? false;
  }

  /// 添加收藏
  Future<bool> addFavorite(Recipe recipe) async {
    final favorites = getFavorites();
    // 如果已收藏，不重复添加
    if (favorites.any((r) => r.id == recipe.id)) {
      return true;
    }
    favorites.add(recipe.copyWith(isFavorite: true));
    return await saveFavorites(favorites);
  }

  /// 取消收藏
  Future<bool> removeFavorite(String recipeId) async {
    final favorites = getFavorites();
    favorites.removeWhere((r) => r.id == recipeId);
    return await saveFavorites(favorites);
  }

  /// 检查是否已收藏
  bool isFavorite(String recipeId) {
    final favorites = getFavorites();
    return favorites.any((r) => r.id == recipeId);
  }

  /// 切换收藏状态
  Future<bool> toggleFavorite(Recipe recipe) async {
    if (isFavorite(recipe.id)) {
      return await removeFavorite(recipe.id);
    } else {
      return await addFavorite(recipe);
    }
  }
}
