import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/services/storage_service.dart';

// Auth state
class AuthState {
  final bool isLoading;
  final UserModel? user;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  bool get isLoggedIn => user != null;

  AuthState copyWith({bool? isLoading, UserModel? user, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _init();
  }

  void _init() {
    if (storageService.isLoggedIn) {
      // restore mock user
      state = state.copyWith(
        user: UserModel(
          id: storageService.getUserId() ?? 'U001',
          fullName: 'کاربر نمونه',
          phone: '0791234567',
          role: UserRole.passenger,
          createdAt: DateTime(2024, 1, 1),
          totalBookings: 3,
        ),
      );
    }
  }

  Future<bool> login(String phone, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(seconds: 1)); // simulate network
    // Mock validation
    if (phone.length < 10) {
      state = state.copyWith(isLoading: false, error: 'phone_invalid');
      return false;
    }
    final user = UserModel(
      id: 'U001',
      fullName: 'کاربر نمونه',
      phone: phone,
      role: UserRole.passenger,
      createdAt: DateTime(2024, 1, 1),
      totalBookings: 3,
    );
    await storageService.setToken('mock_token_12345');
    await storageService.setUserId(user.id);
    state = AuthState(user: user);
    return true;
  }

  Future<bool> register(String name, String phone, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(seconds: 1));
    final user = UserModel(
      id: 'U_${DateTime.now().millisecondsSinceEpoch}',
      fullName: name,
      phone: phone,
      role: UserRole.passenger,
      createdAt: DateTime.now(),
      totalBookings: 0,
    );
    await storageService.setToken('mock_token_new');
    await storageService.setUserId(user.id);
    state = AuthState(user: user);
    return true;
  }

  Future<void> logout() async {
    await storageService.clearToken();
    state = const AuthState();
  }
}
