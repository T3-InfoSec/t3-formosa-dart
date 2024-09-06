import 'package:t3_formosa/formosa.dart';

class FormosaAutocomplete {
  final FormosaTheme _theme;

  FormosaAutocomplete({FormosaTheme theme = FormosaTheme.bip39}) : _theme = theme;

  List<String> start(String query, {String previousSelection = ''}) {
    query = query.toLowerCase();
    if (query.isEmpty) {
      return [];
    }
    if (_theme == FormosaTheme.bip39 || _theme == FormosaTheme.bip39French) {
      return _bip39(query);
    } else {
      return _formosa(query, previousSelection);
    }
  }

  List<String> _bip39(String query) {
    // Get the word list based on BIP-39
    final wordList = _theme.themeData.wordList();
    // Filter the word list based on the query
    return wordList.where((word) => word.startsWith(query)).toList();
  }

  List<String> _formosa(String query, String previousSelection) {
    final List<String> suggestions = [];

    String currentCategory = _getCurrentCategory(previousSelection);

    List<String> wordList = _getWordsFromCategory(currentCategory, query);

    suggestions.addAll(wordList);
    if (previousSelection.isNotEmpty) {
      suggestions.addAll(_getMappedWords(previousSelection, currentCategory));
    }

    return suggestions;
  }

  String _getCurrentCategory(String previousSelection) {
    // If no previous selection, start with the first category in NATURAL_ORDER
    if (previousSelection.isEmpty) {
      return _theme.themeData['NATURAL_ORDER'].first;
    }

    // Otherwise, find the next category to suggest from
    String previousCategory = _getCategoryFromSelection(previousSelection);
    int currentIndex = _theme.themeData['NATURAL_ORDER'].indexOf(previousCategory);
    return _theme.themeData['NATURAL_ORDER'][currentIndex + 1];
  }

// Helper function to get words from the current category
  List<String> _getWordsFromCategory(String category, String query) {
    List<String> wordList = _theme.themeData[category]['TOTAL_LIST'];
    return wordList.where((word) => word.startsWith(query)).toList();
  }

// Helper function to get the category of the previous selection
  String _getCategoryFromSelection(String selection) {
    for (String category in _theme.themeData['NATURAL_ORDER']) {
      if (_theme.themeData[category]['TOTAL_LIST'].contains(selection)) {
        return category;
      }
    }
    return '';
  }

  List<String> _getMappedWords(String previousSelection, String currentCategory) {
    List<String> mappedWords = [];
    if (_theme.themeData[currentCategory]?.containsKey('MAPPING') ?? false) {
      mappedWords.addAll(_theme.themeData[currentCategory]['MAPPING'][previousSelection] ?? []);
    }
    return mappedWords;
  }
}
