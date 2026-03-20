/// 菜谱分类
class RecipeCategories {
  static const List<String> categories = [
    '全部',
    '中餐',
    '西餐',
    '日料',
    '韩餐',
    '东南亚',
    '早餐',
    '快手菜',
    '甜点',
    '饮品',
  ];

  /// 分类图标映射
  static String getIcon(String category) {
    switch (category) {
      case '中餐':
        return '🍜';
      case '西餐':
        return '🍝';
      case '日料':
        return '🍣';
      case '韩餐':
        return '🍲';
      case '东南亚':
        return '🥘';
      case '早餐':
        return '🍳';
      case '快手菜':
        return '⚡';
      case '甜点':
        return '🍰';
      case '饮品':
        return '🥤';
      default:
        return '🍽️';
    }
  }
}

/// API 配置
class ApiConstants {
  // 生产环境 - 服务器部署
  static const String baseUrl = 'http://38.55.133.88:8000/api';
  static const String wsUrl = 'ws://38.55.133.88:8000/ws';
}

/// 本地存储 Key
class StorageKeys {
  static const String favorites = 'favorites';
  static const String searchHistory = 'search_history';
  static const String userPreferences = 'user_preferences';
}
