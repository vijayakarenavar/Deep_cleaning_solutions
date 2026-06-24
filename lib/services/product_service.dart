// lib/services/product_service.dart

import 'api_client.dart';

class ProductService {
  final ApiClient _api = ApiClient();

  // ── Get All Products ──────────────────────────────────────────────
  Future<Map<String, dynamic>> getProducts({
    String? category,
    String? search,
    int page = 1,
  }) async {
    final response = await _api.get(
      '/products',
      queryParams: {
        if (category != null) 'category': category,
        if (search != null)   'search':   search,
        'page': page,
      },
    );
    return response.data;
  }

  // ── Get Product Detail ────────────────────────────────────────────
  Future<Map<String, dynamic>> getProductDetail(int id) async {
    final response = await _api.get('/products/$id');
    return response.data;
  }

  // ── Get Furnished Flats ───────────────────────────────────────────
  Future<Map<String, dynamic>> getFurnishedFlats() async {
    final response = await _api.get('/products/furnished-flats');
    return response.data;
  }

  // ── Get Unfurnished Flats ─────────────────────────────────────────
  Future<Map<String, dynamic>> getUnfurnishedFlats() async {
    final response = await _api.get('/products/unfurnished-flats');
    return response.data;
  }

  // ── Get Flat Category ─────────────────────────────────────────────
  Future<Map<String, dynamic>> getFlatCategory(String type) async {
    final response = await _api.get(
      '/products/flat-category',
      queryParams: {'type': type},
    );
    return response.data;
  }

  // ── Get BHK List ──────────────────────────────────────────────────
  Future<Map<String, dynamic>> getBHKList({
    required String type,
    required String bhk,
  }) async {
    final response = await _api.get(
      '/products/bhk-list',
      queryParams: {
        'type': type,
        'bhk':  bhk,
      },
    );
    return response.data;
  }

  // ── Search Products ───────────────────────────────────────────────
  Future<Map<String, dynamic>> searchProducts(String query) async {
    final response = await _api.get(
      '/products/search',
      queryParams: {'q': query},
    );
    return response.data;
  }

  // ── Get Product Reviews ───────────────────────────────────────────
  Future<Map<String, dynamic>> getProductReviews(int productId) async {
    final response = await _api.get('/products/$productId/reviews');
    return response.data;
  }

  // ── Add Product Review ────────────────────────────────────────────
  Future<Map<String, dynamic>> addProductReview({
    required int productId,
    required int rating,
    required String review,
  }) async {
    final response = await _api.post(
      '/products/$productId/reviews',
      data: {
        'rating': rating,
        'review': review,
      },
    );
    return response.data;
  }
}