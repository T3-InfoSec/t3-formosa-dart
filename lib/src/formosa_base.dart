import 'dart:convert';
import 'dart:math';

import 'package:binary/binary.dart';
import 'package:crypto/crypto.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;

import 'formosa_theme.dart';
import 'theme_base.dart';

/// A wrap implementation upon bip39 for supporting semantically connected
/// words implementation upon multiple supported themes.
class Formosa {
  static FormosaTheme defaultTheme = FormosaTheme.bip39;

  final String _formosaThemeName;
  final ThemeBase _formosaThemeData;

  /// Creates a [Formosa] instance with data of a specific [formosaTheme].
  Formosa({required FormosaTheme formosaTheme})
      : _formosaThemeName = formosaTheme.label,
        _formosaThemeData = formosaTheme.themeData;

  ThemeBase get formosaThemeData => _formosaThemeData;

  String get formosaThemeName => _formosaThemeName;

  /// Returns in which themes list of words defined with [code] can be found.
  ///
  /// If theme is ambiguous or there is multiple themes found info message
  /// is returned.
  String detectTheme(List code) {
    var possibleThemes = findThemes();
    List foundThemes = [];
    for (String word in code) {
      for (FormosaTheme theme in possibleThemes) {
        if (theme.themeData.wordList().contains(word)) {
          foundThemes.add(theme);
        }
      }
    }
    if (foundThemes.length > 1) {
      return 'Theme is ambiguous.';
    }
    if (foundThemes.isEmpty) {
      return "Didn't found appropriate theme.";
    }
    return foundThemes[0].label;
  }

  // TODO: Complete the implementation.
  String expand(dynamic formosa) {
    return '';
  }

  /// Returns formosa words from [password].
  ///
  /// Recover the formosa words from the [password]. The [password]
  /// contains the first letters of each word from the formosa.
  // TODO: Complete the implementation.
  String expandPassword(String password) {
    int n = (isBip39Theme()) ? 4 : 2;

    if (password.length % n != 0) {
      return password;
    }

    return '';
  }

  // TODO: Complete the implementation.
  String expandWord(dynamic formosa) {
    return '';
  }

  /// Returns a formatted [formosa] in unique way.
  String formatFormosa(dynamic formosa) {
    if (formosa is String) {
      formosa = formosa.split(' ');
    }

    int n = (isBip39Theme()) ? 4 : 2;

    String password = '';
    String word;
    // Concatenate the first n letters of each word in a single string
    // If the word in BIP39 has 3 letters finish with "-"
    for (String word_ in formosa) {
      word = word_;
      if (n > word.length) {
        word += '-';
      }
      for (int i = 0; n > i; i++) {
        password += word[i];
      }
    }
    return password;
  }

  /// Returns pattern which complication is measured by [strength] parameter.
  String generate(int strength) {
    if ((strength % 32 != 0) && (strength > 256)) {
      return ('Strength should be below 256 and a multiple of 32, but it is$strength');
    }
    var rand = Random();
    double strength_ = strength / 8;
    return toFormosa(rand.nextInt(strength_.toInt()));
  }

  /// The [isBip39Theme] checks is selected theme equal to BIP39.
  /// Returns 'true' if default theme is BIP39, else returns 'false'.
  bool isBip39Theme() {
    return formosaThemeName == 'bip39';
  }

  /// The [toEntropy] method returns a entropy using provided one
  /// or set of [words].
  List<int> toEntropy(dynamic words) {
    if (words is String) {
      words = words.split(' ');
    }

    int wordsSize = words.length;
    var wordsDict = _formosaThemeData;
    int phraseAmount = wordsDict.getPhraseAmount(words);
    int phraseSize = wordsDict.wordsPerPhrase();
    int bitsPerChecksumBit = 33;
    if ((wordsSize % phraseSize) != 0) {
      // The number of [words] doesn't have good multiple.
      return [0];
    }
    // Look up all the words in the list and construct the
    // concatenation of the original entropy and the checksum.

    // Determining strength of the password
    int numberPhrases = wordsSize ~/ wordsDict.wordsPerPhrase();
    int concatenationLenBits = numberPhrases * wordsDict.bitsPerPhrase();
    int checksumLengthBits = concatenationLenBits ~/ bitsPerChecksumBit.round();
    int entropyLengthBits = concatenationLenBits - checksumLengthBits;
    var phraseIndexes = wordsDict.getPhraseIndexes(words);

    List bitsFillSequence = [];
    for (int i = 0; phraseAmount > i; i++) {
      bitsFillSequence += _formosaThemeData.bitsFillSequence();
    }

    String concatenationBits = '';
    for (int i = 0; phraseIndexes.length > i; i++) {
      concatenationBits +=
          (phraseIndexes[i].toRadixString(2).padLeft(bitsFillSequence[i], '0'));
    }
    List<int> entropy_ = List.filled(entropyLengthBits ~/ 8, 0);
    int bitInt;

    for (int entropyId = 0;
        (entropyLengthBits / 8) > entropyId;
        entropyId += 1) {
      entropy_[entropyId] = 0;
      for (int i = 0; 8 > i; i++) {
        if (concatenationBits[(entropyId * 8) + i] == '1') {
          bitInt = 1;
        } else {
          bitInt = 0;
        }
        entropy_[entropyId] |= (bitInt << (8 - 1 - i));
      }
    }
    List<int> entropy = List.filled(entropyLengthBits ~/ 8, 0);
    for (int entropyId = 0;
        (entropyLengthBits / 8) > entropyId;
        entropyId += 1) {
      entropy[entropyId] = int.parse(entropy_[entropyId].toString());
    }
    return entropy;
  }

  /// Returns formosa in Formosa standard from given entropy [data]. If
  /// input data is not appropriate or number of bytes is not adequate
  /// info message is returned.
  String toFormosa(dynamic data) {
    int leastMultiple = 4;

    if (data is! String && data is! List<int>) {
      return 'Input data is not byte or string.';
    }

    if ((data.length) % leastMultiple != 0) {
      return 'Number of bytes should be multiple of $leastMultiple'
          ' but it is ${data.length}';
    }

    if (data is String) {
      data = utf8.encode(data);
      int paddingLength =
          ((leastMultiple - (data.length % leastMultiple))) % leastMultiple;
      List<int> padding = [];
      for (int i = 0; paddingLength > i; i++) {
        padding.add(32);
      }
      data = data + padding;
    }

    var hashObject = sha256.convert(data);

    String entropyBits = '';
    String binaryRepresentation;
    for (int data_ in data) {
      binaryRepresentation = data_.toRadixString(2);
      if (binaryRepresentation.length < 8) {
        while (binaryRepresentation.length != 8) {
          binaryRepresentation = '0$binaryRepresentation';
        }
      }
      entropyBits += binaryRepresentation;
    }

    String checksumBits_ = '';
    String checksumBits = '';
    for (int data_ in hashObject.bytes) {
      binaryRepresentation = data_.toRadixString(2);
      //add leading zeros
      if (binaryRepresentation.length < 8) {
        while (binaryRepresentation.length != 8) {
          binaryRepresentation = '0$binaryRepresentation';
        }
      }
      checksumBits_ += (binaryRepresentation);
    }

    double checksumLength_ = data.length * 8 / 32;
    int checksumLength = checksumLength_.toInt();
    for (int i = 0; checksumLength > i; i++) {
      checksumBits += checksumBits_.toBitList()[i].toString();
    }

    String dataBits = entropyBits + checksumBits;

    List sentences = _formosaThemeData.getSentencesFromBits(dataBits);

    String formosa = sentences.join(' ');
    return formosa;
  }

  /// Returns a list of all supported themes.
  static List<FormosaTheme> findThemes() {
    return FormosaTheme.values;
  }

  /// Returns a normalized [bytesText] to normal from [unorm.NFKD] of Unicode.
  static String normalizeBytes(List<int> bytesText) {
    String unicodeText = utf8.decode(bytesText);
    return unorm.nfkd(unicodeText);
  }

  /// Returns a normalized given [text] to normal from [unorm.NFKD] of Unicode.
  static String normalizeString(String text) {
    return unorm.nfkd(text);
  }
}
