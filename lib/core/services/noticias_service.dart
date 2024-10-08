import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:miutem/core/models/noticia.dart';
import 'package:miutem/core/utils/http/interceptors/headers_interceptor.dart';
import 'package:miutem/core/utils/http/interceptors/log_interceptor.dart';

const String noticiasUrl = "https://noticias.utem.cl";

class NoticiasService {

  final _httpClient = Dio(BaseOptions(baseUrl: noticiasUrl))..interceptors.addAll([
    HeadersInterceptor(),
    logInterceptor,
    DioCacheManager(CacheConfig(
      baseUrl: noticiasUrl,
      defaultMaxAge: const Duration(days: 7),
      defaultMaxStale: const Duration(days: 14),
    )).interceptor,
  ]);

  Future<List<Noticia>> getNoticias({ bool forceRefresh = false }) async {
    final hasta = DateTime.now().toUtc().toIso8601String();
    final desde = DateTime.now().subtract(const Duration(days: 180)).toUtc().toIso8601String();
    final categoryIdResponse = await _httpClient.get("/wp-json/wp/v2/categories",
      options: buildCacheOptions(const Duration(days: 14), forceRefresh: forceRefresh, subKey: "/noticias/categorias"),
      queryParameters: {
        "_fields": "id",
        "slug": "todas-las-noticias",
      },
    );
    final categoryId = ((categoryIdResponse.data as List<dynamic>).first as Map<String, dynamic>)['id'];
    final response = await _httpClient.get("/wp-json/wp/v2/posts",
      options: buildCacheOptions(const Duration(days: 14), forceRefresh: forceRefresh, subKey: "/noticias"),
      queryParameters: {
        "_fields": ["id", "yoast_head_json.title", "yoast_head_json.og_description", "yoast_head_json.og_image"].join(','),
        "categories": categoryId,
        "per_page": 12,
        "before": hasta,
        "after": desde,
      },
    );
    if (response.statusCode != 200) {
      return [];
    }

    return Noticia.fromJsonList(response.data as List<dynamic>);
  }

}