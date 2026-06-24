// lib/services/blog_service.dart

import 'api_client.dart';

class BlogService {
  final ApiClient _api = ApiClient();

  // ── Get All Blogs ─────────────────────────────────────────────────
  Future<Map<String, dynamic>> getBlogs({
    String? category,
    String? search,
    int page = 1,
  }) async {
    final response = await _api.get(
      '/blogs',
      queryParams: {
        if (category != null) 'category': category,
        if (search != null)   'search':   search,
        'page': page,
      },
    );
    return response.data;
  }

  // ── Get Blog Detail ───────────────────────────────────────────────
  Future<Map<String, dynamic>> getBlogDetail(String slug) async {
    final response = await _api.get('/blogs/$slug');
    return response.data;
  }

  // ── Get Blog Categories ───────────────────────────────────────────
  Future<Map<String, dynamic>> getBlogCategories() async {
    final response = await _api.get('/blogs/categories');
    return response.data;
  }

  // ── Get Recent Blogs ──────────────────────────────────────────────
  Future<Map<String, dynamic>> getRecentBlogs() async {
    final response = await _api.get(
      '/blogs',
      queryParams: {
        'sort':  'latest',
        'limit': 5,
      },
    );
    return response.data;
  }

  // ── Get Related Blogs ─────────────────────────────────────────────
  Future<Map<String, dynamic>> getRelatedBlogs(String slug) async {
    final response = await _api.get('/blogs/$slug/related');
    return response.data;
  }
}