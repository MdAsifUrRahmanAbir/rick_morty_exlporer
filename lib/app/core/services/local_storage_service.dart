import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ── Key constants ────────────────────────────────────────────────────────────
const String _tokenKey = 'tokenKey';
const String _nameKey = 'nameKey';
const String _emailKey = 'emailKey';
const String _imageKey = 'imageKey';
const String _isLoggedInKey = 'isLoggedInKey';
const String _isOnBoardKey = 'isOnBoardDoneKey';
const String _isDarkModeKey = 'isDarkModeKey';
const String _languageKey = 'languageKey';
const String _langSmallKey = 'langSmallKey';
const String _langCapKey = 'langCapKey';
const String _favoritesKey = 'favoritesKey';
const String _overridesKey = 'overridesKey';
const String _characterCacheKey = 'characterCacheKey';

/// Static local storage utility backed by SharedPreferences.
///
/// Initialise once in `main()` before `runApp`:
///   await LocalStorage.init();
///
/// Then use anywhere:
///   LocalStorage.saveToken(token: 'abc');
///   String? token = LocalStorage.getToken();
///   LocalStorage.signOut();
class LocalStorage {
  LocalStorage._();

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Token ────────────────────────────────────────────────────────────────
  static Future<void> saveToken({required String token}) =>
      _prefs.setString(_tokenKey, token);

  static String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  static bool hasToken() => getToken() != null;

  // ── User ─────────────────────────────────────────────────────────────────
  static Future<void> saveName({required String name}) =>
      _prefs.setString(_nameKey, name);
  static String getName() => _prefs.getString(_nameKey) ?? '';

  static Future<void> saveEmail({required String email}) =>
      _prefs.setString(_emailKey, email);
  static String getEmail() => _prefs.getString(_emailKey) ?? '';

  static Future<void> saveImage({required String url}) =>
      _prefs.setString(_imageKey, url);
  static String? getImage() => _prefs.getString(_imageKey);

  // ── Auth State ────────────────────────────────────────────────────────────
  static Future<void> setLoggedIn({required bool value}) =>
      _prefs.setBool(_isLoggedInKey, value);
  static bool isLoggedIn() => _prefs.getBool(_isLoggedInKey) ?? false;

  // ── Onboard ───────────────────────────────────────────────────────────────
  static Future<void> setOnboardDone({required bool value}) =>
      _prefs.setBool(_isOnBoardKey, value);
  static bool isOnboardDone() => _prefs.getBool(_isOnBoardKey) ?? false;

  // ── Theme ─────────────────────────────────────────────────────────────────
  static Future<void> saveDarkMode({required bool isDark}) =>
      _prefs.setBool(_isDarkModeKey, isDark);
  static bool isDarkMode() => _prefs.getBool(_isDarkModeKey) ?? false;

  static void switchTheme() {
    final current = isDarkMode();
    _prefs.setBool(_isDarkModeKey, !current);
  }

  // ── Language ──────────────────────────────────────────────────────────────
  static Future<void> saveLanguage({
    required String name,
    required String langSmall,
    required String langCap,
  }) async {
    await _prefs.setString(_languageKey, name);
    await _prefs.setString(_langSmallKey, langSmall);
    await _prefs.setString(_langCapKey, langCap);
  }

  static List<String> getLanguage() => [
    _prefs.getString(_langSmallKey) ?? 'en',
    _prefs.getString(_langCapKey) ?? 'EN',
    _prefs.getString(_languageKey) ?? 'English',
  ];

  // ── Sign Out ──────────────────────────────────────────────────────────────
  static Future<void> signOut() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_nameKey);
    await _prefs.remove(_emailKey);
    await _prefs.remove(_imageKey);
    await _prefs.remove(_isLoggedInKey);
  }

  // ── Rick & Morty Explorer ───────────────────────────────────────────────
  
  // Favorites
  static List<int> getFavoriteIds() {
    final data = _prefs.getString(_favoritesKey);
    if (data == null) return [];
    try {
      return List<int>.from(jsonDecode(data));
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveFavorite(int id, Map<String, dynamic> characterJson) async {
    final list = getFavoriteIds();
    if (!list.contains(id)) {
      list.add(id);
      await _prefs.setString(_favoritesKey, jsonEncode(list));
    }
    
    final data = _prefs.getString('favoriteData');
    final dataBox = data == null ? <String, dynamic>{} : Map<String, dynamic>.from(jsonDecode(data));
    dataBox[id.toString()] = characterJson;
    await _prefs.setString('favoriteData', jsonEncode(dataBox));
  }

  static Future<void> removeFavorite(int id) async {
    final list = getFavoriteIds();
    if (list.contains(id)) {
      list.remove(id);
      await _prefs.setString(_favoritesKey, jsonEncode(list));
    }
    
    final data = _prefs.getString('favoriteData');
    if (data != null) {
      try {
        final dataBox = Map<String, dynamic>.from(jsonDecode(data));
        dataBox.remove(id.toString());
        await _prefs.setString('favoriteData', jsonEncode(dataBox));
      } catch (_) {}
    }
  }

  static List<Map<String, dynamic>> getFavoriteObjects() {
    final data = _prefs.getString('favoriteData');
    if (data == null) return [];
    try {
      final dataBox = Map<String, dynamic>.from(jsonDecode(data));
      return dataBox.values.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static bool isFavoriteChar(int id) => getFavoriteIds().contains(id);

  // Overrides
  static Map<String, dynamic> getOverrides() {
    final data = _prefs.getString(_overridesKey);
    if (data == null) return {};
    try {
      return Map<String, dynamic>.from(jsonDecode(data));
    } catch (_) {
      return {};
    }
  }

  static Future<void> saveOverride(int id, Map<String, dynamic> data) async {
    final map = getOverrides();
    map[id.toString()] = data;
    await _prefs.setString(_overridesKey, jsonEncode(map));
  }

  static Map<String, dynamic>? getOverride(int id) {
    final map = getOverrides();
    return map[id.toString()];
  }

  static Future<void> removeOverride(int id) async {
    final map = getOverrides();
    map.remove(id.toString());
    await _prefs.setString(_overridesKey, jsonEncode(map));
  }

  // API Cache
  static Future<void> cacheCharacters(int page, Map<String, dynamic> data) async {
    final cacheJson = _prefs.getString(_characterCacheKey);
    final cache = cacheJson == null ? <String, dynamic>{} : Map<String, dynamic>.from(jsonDecode(cacheJson));
    cache[page.toString()] = data;
    await _prefs.setString(_characterCacheKey, jsonEncode(cache));
  }

  static Map<String, dynamic>? getCachedCharacters(int page) {
    final cacheJson = _prefs.getString(_characterCacheKey);
    if (cacheJson == null) return null;
    try {
      final cache = Map<String, dynamic>.from(jsonDecode(cacheJson));
      return cache[page.toString()];
    } catch (_) {
      return null;
    }
  }
}
