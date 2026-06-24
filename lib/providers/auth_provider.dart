// lib/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

// ── Auth State ────────────────────────────────────────────────────────
class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final Map<String, dynamic>? user;
  final String? error;

  const AuthState({
    this.isLoading  = false,
    this.isLoggedIn = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    Map<String, dynamic>? user,
    String? error,
  }) {
    return AuthState(
      isLoading:  isLoading  ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user:       user       ?? this.user,
      error:      error      ?? this.error,
    );
  }
}

// ── Auth Notifier ─────────────────────────────────────────────────────
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService = AuthService();

  AuthNotifier() : super(const AuthState()) {
    _checkLoginStatus();
  }

  // ── Check Login Status ─────────────────────────────────────────────
  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      await getProfile();
    }
  }

  // ── Register ───────────────────────────────────────────────────────
  Future<bool> register({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.register(
        name:     name,
        email:    email,
        mobile:   mobile,
        password: password,
      );
      state = state.copyWith(
        isLoading:  false,
        isLoggedIn: true,
        user:       response['user'],
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Login ──────────────────────────────────────────────────────────
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.login(
        email:    email,
        password: password,
      );
      state = state.copyWith(
        isLoading:  false,
        isLoggedIn: true,
        user:       response['user'],
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.logout();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Get Profile ────────────────────────────────────────────────────
  Future<void> getProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.getProfile();
      state = state.copyWith(
        isLoading:  false,
        isLoggedIn: true,
        user:       response['user'],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Update Profile ─────────────────────────────────────────────────
  Future<bool> updateProfile({
    required String name,
    required String email,
    required String mobile,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.updateProfile(
        name:   name,
        email:  email,
        mobile: mobile,
      );
      state = state.copyWith(
        isLoading: false,
        user:      response['user'],
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Change Password ────────────────────────────────────────────────
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword:     newPassword,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Clear Error ────────────────────────────────────────────────────
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// ── Provider ──────────────────────────────────────────────────────────
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
      (ref) => AuthNotifier(),
);