import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/connectivity_service.dart';
import '../model/character_model.dart';

class CharacterScreenProvider extends ChangeNotifier {
  final PagingController<int, CharacterModel> pagingController =
      PagingController(firstPageKey: 1);

  // State
  List<CharacterModel> _masterList = [];
  String _searchQuery = '';
  String _statusFilter = '';
  String _speciesFilter = '';
  bool _isLoading = false;

  static const String _baseUrl = 'https://rickandmortyapi.com/api/character';

  CharacterScreenProvider() {
    pagingController.addPageRequestListener((pageKey) {
      if (!_isFetching) { 
        _fetchPage(pageKey);
      }
    });
  }

  bool _isFetching = false;

  Future<void> _fetchPage(int pageKey) async {
    if (_isFetching) return;
    _isFetching = true;
    // Only return early if searching, as search is done locally on fetched data.
    // Filtering (status/species) is now handled by the API.
    if (_searchQuery.isNotEmpty) return;

    if (pageKey == 1) {
      _isLoading = true;
      Future.microtask(() => notifyListeners());
    }

    try {
      final queryParams = {
        'page': pageKey.toString(),
        if (_statusFilter.isNotEmpty) 'status': _statusFilter.toLowerCase(),
        if (_speciesFilter.isNotEmpty) 'species': _speciesFilter.toLowerCase(),
      };
      
      final url = Uri.parse(_baseUrl).replace(queryParameters: queryParams).toString();
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

      var resultsToAppend = response.results.map((char) => applyOverrides(char)).toList();
      
      final isOnline = await ConnectivityService.isConnected();
      if (!isOnline && (_statusFilter.isNotEmpty || _speciesFilter.isNotEmpty)) {
        resultsToAppend = resultsToAppend.where((char) {
          final matchesStatus = _statusFilter.isEmpty || char.status == _statusFilter;
          final matchesSpecies = _speciesFilter.isEmpty || char.species == _speciesFilter;
          return matchesStatus && matchesSpecies;
        }).toList();
      }

      final isLastPage = response.nextUrl == null;
      if (isLastPage) {
        pagingController.appendLastPage(resultsToAppend);
      } else {
        pagingController.appendPage(resultsToAppend, pageKey + 1);
      }
    } finally {
      if (pageKey == 1) {
        _isLoading = false;
        Future.microtask(() => notifyListeners());
      }
      _isFetching = false;
    }
  }

  bool get isLoading => _isLoading;

  // Local Search & Filtering Implementation
  void setSearch(String query) {
    _searchQuery = query;
    _syncFilteredList();
  }

  Future<void> setFilters({String? status, String? species}) async {
    if (status != null) _statusFilter = status;
    if (species != null) _speciesFilter = species;
    
    final isOnline = await ConnectivityService.isConnected();
    if (isOnline) {
      _masterList.clear();
      pagingController.refresh();
    } else {
      // Offline mode: Filter locally what we have and show a toast
      _syncFilteredList();
      ConnectivityService.showModernToast('No internet, filtering locally', isError: true);
    }
    notifyListeners();
  }

  void _syncFilteredList() {
    if (_searchQuery.isEmpty && _statusFilter.isEmpty && _speciesFilter.isEmpty) {
      // If nothing active, show all accumulated items
      pagingController.itemList = _masterList.map((e) => applyOverrides(e)).toList();
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

  void notifyFavoriteStateChanged() {
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
