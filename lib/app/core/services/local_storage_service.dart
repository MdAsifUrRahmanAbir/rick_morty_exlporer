import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

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

/// Static local storage utility backed by GetStorage.
///
/// Initialise once in `main()` before `runApp`:
///   await GetStorage.init();
///
/// Then use anywhere:
///   LocalStorage.saveToken(token: 'abc');
///   String? token = LocalStorage.getToken();
///   LocalStorage.signOut();
class LocalStorage {
  LocalStorage._();

  static GetStorage get _box => GetStorage();

  // ── Token ────────────────────────────────────────────────────────────────
  static Future<void> saveToken({required String token}) =>
      _box.write(_tokenKey, token);

  static String? getToken() {
    final t = _box.read<String>(_tokenKey);
    debugPrint(t == null ? '## Token is null ##' : '## Token found ##');
    return t;
  }

  static bool hasToken() => getToken() != null;

  // ── User ─────────────────────────────────────────────────────────────────
  static Future<void> saveName({required String name}) =>
      _box.write(_nameKey, name);
  static String getName() => _box.read(_nameKey) ?? '';

  static Future<void> saveEmail({required String email}) =>
      _box.write(_emailKey, email);
  static String getEmail() => _box.read(_emailKey) ?? '';

  static Future<void> saveImage({required String url}) =>
      _box.write(_imageKey, url);
  static String? getImage() => _box.read<String>(_imageKey);

  // ── Auth State ────────────────────────────────────────────────────────────
  static Future<void> setLoggedIn({required bool value}) =>
      _box.write(_isLoggedInKey, value);
  static bool isLoggedIn() => _box.read(_isLoggedInKey) ?? false;

  // ── Onboard ───────────────────────────────────────────────────────────────
  static Future<void> setOnboardDone({required bool value}) =>
      _box.write(_isOnBoardKey, value);
  static bool isOnboardDone() => _box.read(_isOnBoardKey) ?? false;

  // ── Theme ─────────────────────────────────────────────────────────────────
  static Future<void> saveDarkMode({required bool isDark}) =>
      _box.write(_isDarkModeKey, isDark);
  static bool isDarkMode() => _box.read(_isDarkModeKey) ?? false;

  static void switchTheme() {
    final current = isDarkMode();
    _box.write(_isDarkModeKey, !current);
    // Theme switching should be handled via Provider/ThemeController now
  }

  // ── Language ──────────────────────────────────────────────────────────────
  static Future<void> saveLanguage({
    required String name, // e.g. 'English'
    required String langSmall, // e.g. 'en'
    required String langCap, // e.g. 'EN'
  }) async {
    await _box.write(_languageKey, name);
    await _box.write(_langSmallKey, langSmall);
    await _box.write(_langCapKey, langCap);
    // Locale updates should be handled via Provider/LocaleController now
  }

  static List<String> getLanguage() => [
    _box.read(_langSmallKey) ?? 'en',
    _box.read(_langCapKey) ?? 'EN',
    _box.read(_languageKey) ?? 'English',
  ];

  // ── Sign Out ──────────────────────────────────────────────────────────────
  static Future<void> signOut() async {
    await _box.remove(_tokenKey);
    await _box.remove(_nameKey);
    await _box.remove(_emailKey);
    await _box.remove(_imageKey);
    await _box.remove(_isLoggedInKey);
    // Keep onboard status — user has already seen it
  }

  // ── Rick & Morty Explorer ───────────────────────────────────────────────
  
  // Favorites (storing ID and full object for offline access)
  static List<int> getFavoriteIds() =>
      List<int>.from(_box.read(_favoritesKey) ?? []);

  static Future<void> saveFavorite(int id, Map<String, dynamic> characterJson) async {
    final list = getFavoriteIds();
    if (!list.contains(id)) {
      list.add(id);
      await _box.write(_favoritesKey, list);
    }
    // Also save the object data
    final dataBox = Map<String, dynamic>.from(_box.read('favoriteData') ?? {});
    dataBox[id.toString()] = characterJson;
    await _box.write('favoriteData', dataBox);
  }

  static Future<void> removeFavorite(int id) async {
    final list = getFavoriteIds();
    if (list.contains(id)) {
      list.remove(id);
      await _box.write(_favoritesKey, list);
    }
    // Also remove the object data
    final dataBox = Map<String, dynamic>.from(_box.read('favoriteData') ?? {});
    dataBox.remove(id.toString());
    await _box.write('favoriteData', dataBox);
  }

  static List<Map<String, dynamic>> getFavoriteObjects() {
    final dataBox = Map<String, dynamic>.from(_box.read('favoriteData') ?? {});
    return dataBox.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static bool isFavoriteChar(int id) => getFavoriteIds().contains(id);

  // Overrides
  static Map<String, dynamic> getOverrides() =>
      Map<String, dynamic>.from(_box.read(_overridesKey) ?? {});

  static Future<void> saveOverride(int id, Map<String, dynamic> data) async {
    final map = getOverrides();
    map[id.toString()] = data;
    _box.write(_overridesKey, map);
  }

  static Map<String, dynamic>? getOverride(int id) {
    final map = getOverrides();
    return map[id.toString()];
  }

  static Future<void> removeOverride(int id) async {
    final map = getOverrides();
    map.remove(id.toString());
    await _box.write(_overridesKey, map);
  }

  // API Cache (for offline)
  static Future<void> cacheCharacters(int page, Map<String, dynamic> data) async {
    final cache = Map<String, dynamic>.from(_box.read(_characterCacheKey) ?? {});
    cache[page.toString()] = data;
    _box.write(_characterCacheKey, cache);
  }

  static Map<String, dynamic>? getCachedCharacters(int page) {
    final cache = Map<String, dynamic>.from(_box.read(_characterCacheKey) ?? {});
    return cache[page.toString()];
  }
}
