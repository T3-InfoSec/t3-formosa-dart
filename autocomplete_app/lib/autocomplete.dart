import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:t3_formosa/formosa.dart';

class FormosaAutocomplete {
  final FormosaTheme _theme;

  FormosaAutocomplete({FormosaTheme theme = FormosaTheme.bip39}) : _theme = theme;

  List<String> start(String query, {String previousSelection = ''}) {
    query = query.toLowerCase();
    if (query.isEmpty) {
      return [];
    }
    switch (_theme) {
      case FormosaTheme.bip39:
      case FormosaTheme.bip39French:
        return _bip39(query);
      default:
        return [];
    }
  }

  List<String> _bip39(String query) {
    // Get the word list based on BIP-39
    final wordList = _theme.themeData.wordList();
    // Filter the word list based on the query
    return wordList.where((word) => word.startsWith(query)).toList();
  }

  List<int> toEntropyValidateChecksum(dynamic words) {
    final themeData = _theme.themeData;
    if (words is String) {
      words = words.split(' ');
    }

    int wordsSize = words.length;
    var wordsDict = themeData;

    int phraseAmount = wordsDict.getPhraseAmount(words);
    int phraseSize = wordsDict.wordsPerPhrase();
    int bitsPerChecksumBit = 33;
    if ((wordsSize % phraseSize) != 0) {
      // The number of [words] doesn't have a good multiple.
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
      bitsFillSequence += themeData.bitsFillSequence();
    }

    String concatenationBits = '';
    for (int i = 0; phraseIndexes.length > i; i++) {
      concatenationBits += (phraseIndexes[i].toRadixString(2).padLeft(bitsFillSequence[i], '0'));
    }

    // Extract entropy
    List<int> entropyBytes = List.filled(entropyLengthBits ~/ 8, 0);
    for (int entropyIdx = 0; entropyIdx < entropyBytes.length; entropyIdx++) {
      for (int bitIdx = 0; bitIdx < 8; bitIdx++) {
        int bitInt = concatenationBits[(entropyIdx * 8) + bitIdx] == '1' ? 1 : 0;
        entropyBytes[entropyIdx] |= (bitInt << (8 - 1 - bitIdx));
      }
    }

    // Hash the entropy using SHA-256
    var entropyUint8List = Uint8List.fromList(entropyBytes);
    var hashBytes = sha256.convert(entropyUint8List).bytes;

    // Convert the hash into bits
    String hashBits = '';
    for (int checksumByte in hashBytes) {
      hashBits += checksumByte.toRadixString(2).padLeft(8, '0');
    }

    // Validate the checksum
    bool valid = true;
    for (int bitIdx = 0; bitIdx < checksumLengthBits; bitIdx++) {
      if (concatenationBits[entropyLengthBits + bitIdx] != hashBits[bitIdx]) {
        valid = false;
        break;
      }
    }

    if (!valid) {
      throw Exception("Failed checksum.");
    }

    return entropyBytes;
  }
}
