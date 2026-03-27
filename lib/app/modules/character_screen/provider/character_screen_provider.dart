import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../data/models/character_model.dart';

class CharacterScreenProvider extends ChangeNotifier {
  final PagingController<int, CharacterModel> pagingController =
      PagingController(firstPageKey: 1);

  // State
  List<CharacterModel> _masterList = [];
  String _searchQuery = '';
  String _statusFilter = '';
  String _speciesFilter = '';

  static const String _baseUrl = 'https://rickandmortyapi.com/api/character';

  CharacterScreenProvider() {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    // If we are searching/filtering, we don't fetch new pages from the API 
    // because pagination for search is complex to mix with home pagination. 
    // Instead, we just show what we have in _masterList if searches are on.
    if (_searchQuery.isNotEmpty || _statusFilter.isNotEmpty || _speciesFilter.isNotEmpty) return;

    try {
      final url = '$_baseUrl?page=$pageKey';
      CharacterResponse? response;

      final result = await ApiServices.get<CharacterResponse>(
        CharacterResponse.fromJson,
        url,
        showErrorMessage: false,
      );

      if (result != null) {
        response = result;
        // Only cache first page of unfiltered results
        if (pageKey == 1) {
          final cacheData = {
            'results': response.results.map((e) => e.toJson()).toList(),
            'info': {
              'pages': response.totalPages,
              'count': response.totalCount,
              'next': response.nextUrl
            }
          };
          await LocalStorage.cacheCharacters(pageKey, cacheData);
        }
      } else {
        if (pageKey == 1) {
          final cachedData = LocalStorage.getCachedCharacters(pageKey);
          if (cachedData != null) response = CharacterResponse.fromJson(cachedData);
        }
      }

      if (response == null) {
        pagingController.error = 'Failed to load characters. Are you offline?';
        return;
      }

      // Add newly loaded characters to Master list
      for (var char in response.results) {
        if (!_masterList.any((e) => e.id == char.id)) {
          _masterList.add(char);
        }
      }

      final effectiveResults = response.results.map((char) => applyOverrides(char)).toList();
      final isLastPage = response.nextUrl == null;
      
      if (isLastPage) {
        pagingController.appendLastPage(effectiveResults);
      } else {
        pagingController.appendPage(effectiveResults, pageKey + 1);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  // Local Search & Filtering Implementation
  void setSearch(String query) {
    _searchQuery = query;
    _syncFilteredList();
  }

  void setFilters({String? status, String? species}) {
    if (status != null) _statusFilter = status;
    if (species != null) _speciesFilter = species;
    _syncFilteredList();
  }

  void _syncFilteredList() {
    if (_searchQuery.isEmpty && _statusFilter.isEmpty && _speciesFilter.isEmpty) {
      // Restore original list from master list
      pagingController.itemList = _masterList.map((e) => applyOverrides(e)).toList();
      // Since we manually set the item list, we might need to tell PagingController it's on a certain page
      // but simpler is to just refresh if filters are completely cleared
      pagingController.refresh();
      _masterList.clear(); // Will refetch and repopulate
      notifyListeners();
      return;
    }

    // Filter locally from master list
    final filtered = _masterList.where((char) {
      final matchesSearch = char.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _statusFilter.isEmpty || char.status == _statusFilter;
      final matchesSpecies = _speciesFilter.isEmpty || char.species == _speciesFilter;
      return matchesSearch && matchesStatus && matchesSpecies;
    }).map((e) => applyOverrides(e)).toList();

    pagingController.itemList = filtered;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _statusFilter = '';
    _speciesFilter = '';
    pagingController.refresh();
    _masterList.clear();
    notifyListeners();
  }

  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;
  String get speciesFilter => _speciesFilter;

  // Reset Override
  Future<void> resetToApi(int id) async {
    await LocalStorage.removeOverride(id);
    _syncFilteredList(); // Re-apply overrides (which will now be gone)
    notifyListeners();
  }

  CharacterModel applyOverrides(CharacterModel char) {
    final override = LocalStorage.getOverride(char.id);
    if (override == null) return char;

    return char.copyWith(
      name: override['name'],
      status: override['status'],
      species: override['species'],
      type: override['type'],
      gender: override['gender'],
      origin: override['origin_name'] != null 
          ? CharacterLocation(name: override['origin_name'], url: char.origin.url) 
          : null,
      location: override['location_name'] != null 
          ? CharacterLocation(name: override['location_name'], url: char.location.url) 
          : null,
    );
  }

  void refresh() {
    _masterList.clear();
    pagingController.refresh();
    notifyListeners();
  }

  void toggleFavorite(CharacterModel character) {
    if (LocalStorage.isFavoriteChar(character.id)) {
      LocalStorage.removeFavorite(character.id);
    } else {
      LocalStorage.saveFavorite(character.id, character.toJson());
    }
    // Update master list with override awareness (though toggleFavorite doesn't change core data)
    _syncFilteredList();
  }


  bool isFavorite(int id) => LocalStorage.isFavoriteChar(id);

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
