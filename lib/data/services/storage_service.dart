import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _langKey       = 'app_language';
  static const String _tokenKey      = 'auth_token';
  static const String _userIdKey     = 'user_id';
  static const String _onboardedKey  = 'onboarded';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // ─── Language ──────────────────────────────────────────────────────────────
  String getLanguage() => _prefs.getString(_langKey) ?? 'fa';
  Future<void> setLanguage(String lang) => _prefs.setString(_langKey, lang);

  // ─── Auth ──────────────────────────────────────────────────────────────────
  String? getToken() => _prefs.getString(_tokenKey);
  Future<void> setToken(String token) => _prefs.setString(_tokenKey, token);
  Future<void> clearToken() => _prefs.remove(_tokenKey);

  String? getUserId() => _prefs.getString(_userIdKey);
  Future<void> setUserId(String id) => _prefs.setString(_userIdKey, id);

  bool get isLoggedIn => getToken() != null;

  // ─── Onboarding ───────────────────────────────────────────────────────────
  bool get hasSelectedLanguage => _prefs.containsKey(_langKey);
  bool get isOnboarded => _prefs.getBool(_onboardedKey) ?? false;
  Future<void> setOnboarded() => _prefs.setBool(_onboardedKey, true);

  // ─── Clear All ────────────────────────────────────────────────────────────
  Future<void> clearAll() => _prefs.clear();
}

// Singleton initializer (called in main.dart)
StorageService? _storageInstance;
StorageService get storageService {
  assert(_storageInstance != null, 'StorageService not initialized');
  return _storageInstance!;
}

Future<StorageService> initStorageService() async {
  final prefs = await SharedPreferences.getInstance();
  _storageInstance = StorageService(prefs);
  return _storageInstance!;
}
