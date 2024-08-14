import 'dart:convert';
import 'dart:math';

import 'package:binary/binary.dart';
import 'package:crypto/crypto.dart';
import "package:unorm_dart/unorm_dart.dart" as unorm;

import 'themedict_base.dart';

List<String> supportedThemes = [
  "BIP39",
  "BIP39_french",
  "copy_left",
  "cute_pets",
  "farm_animals",
  "finances",
  "medieval_fantasy",
  "sci-fi",
  "tourism"
];

/// Class provides abstraction for mnemonic which is created based on theme dictionary.
class Mnemonic {
  ThemeDict wordsDictionary = ThemeDict.EmptyDict("");
  String baseTheme = "";

  ///Constructor for the [Mnemonic] class returns instance of [Mnemonic] object with inner
  ///dictionary populated with specific [theme].
  Mnemonic(String theme) {
    baseTheme = theme;
    wordsDictionary = ThemeDict(theme);
  }

  /// The [detectTheme] method returns in which themes list of words defined with
  /// [code] can be found. If theme is ambigous or there is multiple themes found
  ///  info message is returned.
  String detectTheme(List code) {
    var possibleThemes = findThemes();
    List foundThemes = [];
    ThemeDict temp;
    for (String word in code) {
      for (String theme in possibleThemes) {
        temp = ThemeDict(theme);
        if (temp.wordList().contains(word)) {
          foundThemes.add(theme);
        }
      }
    }
    if (foundThemes.length > 1) {
      return "Theme is ambiguous.";
    }
    if (foundThemes.isEmpty) {
      return "Didn't found appropriate theme.";
    }
    return foundThemes[0];
  }

  /// The [expandPassword] method returns mnemonic words from [password].
  String expandPassword(String password) {
    return "";
  }

  /// The [findThemes] method returns list of all supported themes.
  List<String> findThemes() {
    return supportedThemes;
  }

  /// The [formatMnemonic] method returns formated [mnemonic] in unique way.
  String formatMnemonic(dynamic mnemonic) {
    if (mnemonic is String) {
      mnemonic = mnemonic.split(" ");
    }

    int n;
    if (isBip39Theme()) {
      n = 4;
    } else {
      n = 2;
    }

    String password = "";
    String word;
    //Concatenate the first n letters of each word in a single string
    //If the word in BIP39 has 3 letters finish with "-"
    for (String word_ in mnemonic) {
      word = word_;
      if (n > word.length) {
        word += "-";
      }
      for (int i = 0; n > i; i++) {
        password += word[i];
      }
    }
    return password;
  }

  /// The [generate] method returns pattern which
  /// complication is measured by [strength] parameter.
  String generate(int strength) {
    if ((strength % 32 != 0) && (strength > 256)) {
      return ("Strength should be below 256 and a multiple of 32, but it is$strength");
    }
    var rand = Random();
    double strength_ = strength / 8;
    return toMnemonic(rand.nextInt(strength_.toInt()));
  }

  /// The [isBip39Theme] checks is selected theme equal to BIP39.
  /// Returns 'true' if default theme is BIP39, else returns 'false'.
  bool isBip39Theme() {
    return baseTheme == "BIP39";
  }

  /// A [normalizeString] method normalizes any given [txt] to normal from NFKD of Unicode.
  String normalizeString(String txt) {
    return unorm.nfkd(txt);
  }

  /// The [toEntropy] method returns a entropy using provided one or set of [words].
  List<int> toEntropy(dynamic words) {
    if (words is String) {
      words = words.split(" ");
    }

    int wordsSize = words.length;
    var wordsDict = wordsDictionary;
    int phraseAmount = wordsDict.getPhraseAmount(words);
    int phraseSize = wordsDict.wordsPerPhrase();
    int bitsPerChecksumBit = 33;
    if ((wordsSize % phraseSize) != 0) {
      // The number of [words] doesn't have good multiple.
      return [0];
    }
    //Look up all the words in the list and construct the
    //concatenation of the original entropy and the checksum.

    //Determining strength of the password
    int numberPhrases = wordsSize ~/ wordsDict.wordsPerPhrase();
    int concatLenBits = numberPhrases * wordsDict.bitsPerPhrase();
    int checksumLengthBits = concatLenBits ~/ bitsPerChecksumBit.round();
    int entropyLengthBits = concatLenBits - checksumLengthBits;
    var phraseIndexes = wordsDict.getPhraseIndexes(words);

    List bitsFillSequence = [];
    for (int i = 0; phraseAmount > i; i++) {
      bitsFillSequence += wordsDictionary.bitsFillSequence();
    }

    String concatBits = "";
    for (int i = 0; phraseIndexes.length > i; i++) {
      concatBits +=
          (phraseIndexes[i].toRadixString(2).padLeft(bitsFillSequence[i], '0'));
    }
    List<int> entropy_ = List.filled(entropyLengthBits ~/ 8, 0);
    int bitInt;

    for (int entropyId = 0;
        (entropyLengthBits / 8) > entropyId;
        entropyId += 1) {
      entropy_[entropyId] = 0;
      for (int i = 0; 8 > i; i++) {
        if (concatBits[(entropyId * 8) + i] == '1') {
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

  /// The [toMnemonic] method returns mnemonic in Formosa standard from given entropy [data].
  /// If input data is not approriate or number of bytes is not adequate info message is returned.
  String toMnemonic(dynamic data) {
    int leastMmultiple = 4;

    if (data is! String && data is! List<int>) {
      return "Input data is not byte or string.";
    }

    if ((data.length) % leastMmultiple != 0) {
      return "Number of bytes should be multiple of$leastMmultiple but it is ${data.length}";
    }

    if (data is String) {
      data = utf8.encode(data);
      int paddingLength =
          ((leastMmultiple - (data.length % leastMmultiple))) % leastMmultiple;
      List<int> padding = [];
      for (int i = 0; paddingLength > i; i++) {
        padding.add(32);
      }
      data = data + padding;
    }

    var hashObject = sha256.convert(data);

    String entropyBits = "";
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

    String checksumBits_ = "";
    String checksumBits = "";
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

    double checksumLenght_ = data.length * 8 / 32;
    int checksumLenght = checksumLenght_.toInt();
    for (int i = 0; checksumLenght > i; i++) {
      checksumBits += checksumBits_.toBitList()[i].toString();
    }

    String dataBits = entropyBits + checksumBits;

    List sentences = wordsDictionary.getSentencesFromBits(dataBits);

    String mnemonic = sentences.join(" ");
    return mnemonic;
  }
}
