// lib/providers/blog_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/blog_service.dart';

// ── Blog State ────────────────────────────────────────────────────────
class BlogState {
  final bool isLoading;
  final List<dynamic> blogs;
  final List<dynamic> categories;
  final List<dynamic> recentBlogs;
  final List<dynamic> relatedBlogs;
  final Map<String, dynamic>? selectedBlog;
  final int selectedCategory;
  final String? error;

  const BlogState({
    this.isLoading        = false,
    this.blogs            = const [],
    this.categories       = const [],
    this.recentBlogs      = const [],
    this.relatedBlogs     = const [],
    this.selectedBlog,
    this.selectedCategory = 0,
    this.error,
  });

  BlogState copyWith({
    bool? isLoading,
    List<dynamic>? blogs,
    List<dynamic>? categories,
    List<dynamic>? recentBlogs,
    List<dynamic>? relatedBlogs,
    Map<String, dynamic>? selectedBlog,
    int? selectedCategory,
    String? error,
  }) {
    return BlogState(
      isLoading:        isLoading        ?? this.isLoading,
      blogs:            blogs            ?? this.blogs,
      categories:       categories       ?? this.categories,
      recentBlogs:      recentBlogs      ?? this.recentBlogs,
      relatedBlogs:     relatedBlogs     ?? this.relatedBlogs,
      selectedBlog:     selectedBlog     ?? this.selectedBlog,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      error:            error            ?? this.error,
    );
  }
}

// ── Blog Notifier ─────────────────────────────────────────────────────
class BlogNotifier extends StateNotifier<BlogState> {
  final BlogService _blogService = BlogService();

  BlogNotifier() : super(const BlogState()) {
    getBlogs();
    getBlogCategories();
  }

  // ── Get All Blogs ──────────────────────────────────────────────────
  Future<void> getBlogs({
    String? category,
    String? search,
    int page = 1,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _blogService.getBlogs(
        category: category,
        search:   search,
        page:     page,
      );
      state = state.copyWith(
        isLoading: false,
        blogs:     response['blogs'] ?? [],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Get Blog Detail ────────────────────────────────────────────────
  Future<void> getBlogDetail(String slug) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _blogService.getBlogDetail(slug);
      state = state.copyWith(
        isLoading:    false,
        selectedBlog: response['blog'],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Get Blog Categories ────────────────────────────────────────────
  Future<void> getBlogCategories() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _blogService.getBlogCategories();
      state = state.copyWith(
        isLoading:  false,
        categories: response['categories'] ?? [],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Get Recent Blogs ───────────────────────────────────────────────
  Future<void> getRecentBlogs() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _blogService.getRecentBlogs();
      state = state.copyWith(
        isLoading:   false,
        recentBlogs: response['blogs'] ?? [],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Get Related Blogs ──────────────────────────────────────────────
  Future<void> getRelatedBlogs(String slug) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _blogService.getRelatedBlogs(slug);
      state = state.copyWith(
        isLoading:    false,
        relatedBlogs: response['blogs'] ?? [],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Set Selected Category ──────────────────────────────────────────
  void setSelectedCategory(int index) {
    state = state.copyWith(selectedCategory: index);
    if (index == 0) {
      getBlogs();
    } else {
      final category = state.categories[index - 1]['name'];
      getBlogs(category: category);
    }
  }

  // ── Refresh ────────────────────────────────────────────────────────
  Future<void> refresh() async {
    await getBlogs();
    await getBlogCategories();
  }

  // ── Clear Error ────────────────────────────────────────────────────
  void clearError() {
    state = state.copyWith(error: null);
  }

  // ── Clear Selected Blog ────────────────────────────────────────────
  void clearSelectedBlog() {
    state = state.copyWith(selectedBlog: null);
  }
}

// ── Provider ──────────────────────────────────────────────────────────
final blogProvider = StateNotifierProvider<BlogNotifier, BlogState>(
      (ref) => BlogNotifier(),
);// lib/providers/blog_provider.dart

