import 'package:dio/dio.dart';
import '../models/recipe_model.dart';

/// API 服务类 - 负责 HTTP 请求
class ApiService {
  late final Dio _dio;

  // 生产环境 - 服务器部署
  static const String baseUrl = 'http://38.55.133.88:8000/api';

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // 添加日志拦截器（开发用）
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  /// AI 专用的 Dio 实例（超时更长）
  late final Dio _dioAI = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 60),  // AI 可能需要更长时间
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  /// 获取菜谱列表
  Future<List<Recipe>> getRecipes({
    int page = 1,
    int pageSize = 20,
    String? category,
    String? difficulty,
    String? keyword,
  }) async {
    try {
      final response = await _dio.get(
        '/recipes',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          if (category != null && category != '全部') 'category': category,
          if (difficulty != null && difficulty != '全部') 'difficulty': difficulty,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        },
      );

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Recipe.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取菜谱详情
  Future<Recipe> getRecipeDetail(String id) async {
    try {
      final response = await _dio.get('/recipes/$id');
      return Recipe.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 智能私厨推荐
  Future<List<Recipe>> getAIRecommendations({
    required List<String> ingredients,
    String? taste, // 口味偏好
    String? diet, // 饮食限制
    int count = 3, // 推荐数量：1、2、3
  }) async {
    try {
      // 使用 AI 专用实例，超时更长
      final response = await _dioAI.post(
        '/ai/recommend',
        data: {
          'ingredients': ingredients,
          if (taste != null) 'taste': taste,
          if (diet != null) 'diet': diet,
          'count': count,
        },
      );

      // 后端直接返回数组，不需要取 data 字段
      final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? []);
      return data.map((json) => Recipe.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 搜索菜谱
  Future<List<Recipe>> searchRecipes(String keyword) async {
    try {
      final response = await _dio.get(
        '/recipes/search',
        queryParameters: {'q': keyword},
      );

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Recipe.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 处理 Dio 错误
  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return '网络连接超时，请检查网络';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) {
          return '请求的资源不存在';
        } else if (statusCode == 500) {
          return '服务器内部错误';
        }
        return '请求失败: $statusCode';
      case DioExceptionType.cancel:
        return '请求已取消';
      default:
        return '网络错误，请检查网络连接';
    }
  }
}
