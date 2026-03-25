import "package:dio/dio.dart";
import "package:dio_cache_interceptor/dio_cache_interceptor.dart";
import "package:miutem/core/models/noticia.dart";
import "package:miutem/core/utils/http/http_client.dart";

const String noticiasUrl = "https://noticias.utem.cl";

class NoticiasService {

  static List<Noticia>? _cachedNoticias;

  final _httpClient = Dio(HttpClient.httpClient.options.copyWith(
      baseUrl: noticiasUrl
  ))..interceptors.addAll([
    DioCacheInterceptor(options: cacheOptions),
  ]);

  Future<List<Noticia>> getNoticias({ bool forceRefresh = false }) async {
    if (!forceRefresh && _cachedNoticias != null) {
      return List.from(_cachedNoticias!);
    }

    final hasta = DateTime.now().toUtc().toIso8601String();
    final desde = DateTime.now().subtract(const Duration(days: 180)).toUtc().toIso8601String();
    final categoryIdResponse = await _httpClient.get("/wp-json/wp/v2/categories",
      options: cacheOptions.copyWith(policy: forceRefresh ? CachePolicy.refresh : CachePolicy.request).toOptions(),
      queryParameters: {
        "_fields": "id",
        "slug": "todas-las-noticias",
      },
    );
    final categoryId = ((categoryIdResponse.data as List<dynamic>).first as Map<String, dynamic>)["id"];
    final response = await _httpClient.get("/wp-json/wp/v2/posts",
      options: cacheOptions.copyWith(policy: forceRefresh ? CachePolicy.refresh : CachePolicy.request).toOptions(),
      queryParameters: {
        "_fields": ["id", "yoast_head_json.title", "yoast_head_json.og_description", "yoast_head_json.og_image"].join(","),
        "categories": categoryId,
        "per_page": 12,
        "before": hasta,
        "after": desde,
      },
    );
    if (response.statusCode != 200) {
      return [];
    }

    final noticias = Noticia.fromJsonList(response.data as List<dynamic>);
    _cachedNoticias = noticias;
    return noticias;
  }

}