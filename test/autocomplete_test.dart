import 'package:t3_formosa/formosa.dart';
import 'package:test/test.dart';

// ignore: avoid_relative_lib_imports
import '../autocomplete_app/lib/autocomplete.dart';

void main() {
  group('FormosaAutocomplete', () {
    test('returns empty list when query is empty', () {
      final autocomplete = FormosaAutocomplete(theme: FormosaTheme.bip39);
      final result = autocomplete.start('');
      expect(result, isEmpty);
    });

    test('returns bip39 suggestions when theme is bip39', () {
      final autocomplete = FormosaAutocomplete(theme: FormosaTheme.bip39);
      final result = autocomplete.start('abo');
      expect(result, containsAll(['about', 'above']));
    });

    test('returns medieval fantasy suggestions when theme is medievalFantasy', () {
      final autocomplete = FormosaAutocomplete(theme: FormosaTheme.medievalFantasy);
      final result = autocomplete.start('ac');
      expect(result, contains('acolyte'));
    });

    test('follows NATURAL_ORDER and suggests SUBJECT words first', () {
      final autocomplete = FormosaAutocomplete(theme: FormosaTheme.medievalFantasy);
      final result = autocomplete.start('ac');
      expect(result, contains('acolyte'));
    });

    test('suggests VERB words when previous selection is from NATURAL_ORDER', () {
      final autocomplete = FormosaAutocomplete(theme: FormosaTheme.medievalFantasy);
      final result = autocomplete.start('ad', previousSelection: 'acolyte');
      expect(result, contains('advise_about'));
    });

    test('suggests mapped words based on previous selection', () {
      final autocomplete = FormosaAutocomplete(theme: FormosaTheme.medievalFantasy);
      final result = autocomplete.start('ac', previousSelection: 'advise_about');
      expect(result, contains('acidic'));
    });

    test('suggests next category based on previous selection', () {
      final autocomplete = FormosaAutocomplete(theme: FormosaTheme.medievalFantasy);
      final result = autocomplete.start('ham', previousSelection: 'acidic');
      expect(result, contains('hammer'));
    });

    test('suggests correct words from OBJECT category', () {
      final autocomplete = FormosaAutocomplete(theme: FormosaTheme.medievalFantasy);
      final result = autocomplete.start('am', previousSelection: 'hammer');
      expect(result, contains('amazon'));
    });

    test('returns no suggestions when no matches found', () {
      final autocomplete = FormosaAutocomplete(theme: FormosaTheme.medievalFantasy);
      final result = autocomplete.start('zz');
      expect(result, isEmpty);
    });

    test('correctly handles multiple previous selections', () {
      final autocomplete = FormosaAutocomplete(theme: FormosaTheme.medievalFantasy);
      final result1 = autocomplete.start('ac');
      final result2 = autocomplete.start('ab', previousSelection: result1.first);
      expect(result2, isEmpty);
    });

    // New tests

    test('is case-insensitive', () {
      final autocomplete = FormosaAutocomplete(theme: FormosaTheme.bip39);
      final result = autocomplete.start('ABO');
      expect(result, containsAll(['about', 'above']));
    });

    test('handles partial matches', () {
      final autocomplete = FormosaAutocomplete(theme: FormosaTheme.medievalFantasy);
      final result = autocomplete.start('ac');
      expect(result, contains('acolyte'));
    });

    test('suggests correct words from complex mapping', () {
      final autocomplete = FormosaAutocomplete(theme: FormosaTheme.medievalFantasy);
      final result = autocomplete.start('am', previousSelection: 'advise_about');
      expect(result, contains('amethyst'));
    });

    test('handles single character queries correctly', () {
      final autocomplete = FormosaAutocomplete(theme: FormosaTheme.bip39);
      final result = autocomplete.start('a');
      expect(result, contains('about'));
    });
  });

  test('returns empty list when no matches for bip39 with single character', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.bip39);
    final result = autocomplete.start('x');
    expect(result, isEmpty);
  });

  test('returns multiple suggestions for common prefix in medievalFantasy', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.medievalFantasy);
    final result = autocomplete.start('a');
    expect(result, containsAll(['acolyte', 'archer']));
  });

  test('handles NATURAL_ORDER when there are no matches in the current category', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.medievalFantasy);
    final result = autocomplete.start('be', previousSelection: 'acolyte');
    expect(result, contains('bet'));
  });

  test('suggests words from WILDCARD category correctly', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.medievalFantasy);
    final result = autocomplete.start('dr', previousSelection: 'dragon');
    expect(result, contains('druid'));
  });

  test('handles multiple matches with different cases', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.bip39);
    final result = autocomplete.start('ab');
    expect(result, containsAll(['about', 'ability']));
  });

  test('returns results based on MAPPING with multiple selections', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.medievalFantasy);
    final result = autocomplete.start('ca', previousSelection: 'hammer');
    expect(result, containsAll(['cannibal', 'captain', 'carpenter']));
  });

  test('handles queries with numbers correctly', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.bip39);
    final result = autocomplete.start('42');
    expect(result, isEmpty);
  });

  test('returns no suggestions for special characters', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.bip39);
    final result = autocomplete.start('@');
    expect(result, isEmpty);
  });

  test('suggests correctly when previous selection changes category dynamically', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.medievalFantasy);
    final result = autocomplete.start('el', previousSelection: 'master');
    expect(result, contains('elf'));
  });
  test('returns copyLeft suggestions for a given query', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.copyLeft);
    final result = autocomplete.start('med');
    expect(result, contains('medusa'));
  });

  test('suggests next category based on previous selection in copyLeft theme', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.copyLeft);
    final result = autocomplete.start('de', previousSelection: 'medusa');
    expect(result, contains('describe'));
  });

  test('handles case-insensitive queries in copyLeft theme', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.copyLeft);
    final result = autocomplete.start('LI');
    expect(result, contains('little_red_riding_hood'));
  });
  test('returns sciFi suggestions for a given query', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.sciFi);
    final result = autocomplete.start('spa');
    expect(result, containsAll(['space_traveler', 'space_merchant']));
  });

  test('suggests next category based on previous selection in sciFi theme', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.sciFi);
    final result = autocomplete.start('a', previousSelection: 'space_traveler');
    expect(result, containsAll(['activate', 'analyze']));
  });

  test('handles case-insensitive queries in sciFi theme', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.sciFi);
    final result = autocomplete.start('ALI');
    expect(result, contains('alien'));
  });
  test('returns farmAnimals suggestions for a given query', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.farmAnimals);
    final result = autocomplete.start('co');
    expect(result, containsAll(['confused', 'coward', 'colorful']));
  });

  test('suggests next category based on previous selection in farmAnimals theme', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.farmAnimals);
    final result = autocomplete.start('co', previousSelection: 'confused');
    expect(result, containsAll(['cow', 'corgi_dog']));
  });

  test('handles case-insensitive queries in farmAnimals theme', () {
    final autocomplete = FormosaAutocomplete(theme: FormosaTheme.farmAnimals);
    final result = autocomplete.start('COW');
    expect(result, contains('coward'));
  });
}
