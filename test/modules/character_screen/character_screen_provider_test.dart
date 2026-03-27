import 'package:flutter_test/flutter_test.dart';
import 'package:my_structure/app/modules/character_screen/provider/character_screen_provider.dart';

void main() {
  late CharacterScreenProvider provider;

  setUp(() {
    provider = CharacterScreenProvider();
  });

  group('CharacterScreenProvider Tests', () {
    test('initial values are correct', () {
      expect(provider.searchQuery, '');
      expect(provider.statusFilter, '');
      expect(provider.speciesFilter, '');
    });

    test('setting search query updates state', () {
      provider.setSearch('Rick');
      expect(provider.searchQuery, 'Rick');
    });

    test('setting status filter updates state', () {
      provider.setFilters(status: 'Alive');
      expect(provider.statusFilter, 'Alive');
    });

    test('clearFilters resets all states', () {
      provider.setSearch('Morty');
      provider.setFilters(status: 'Dead', species: 'Alien');
      
      provider.clearFilters();
      
      expect(provider.searchQuery, '');
      expect(provider.statusFilter, '');
      expect(provider.speciesFilter, '');
    });
  });
}
