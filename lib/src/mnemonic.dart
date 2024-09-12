import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:t3_formosa/formosa.dart';

class Mnemonic {
  FormosaTheme? _theme;
  final int _pbkdf2Rounds = 2048;
  String? _delimiter;

  Mnemonic._internal({FormosaTheme? theme, required String delimiter})
      : _theme = theme,
        _delimiter = delimiter;

  factory Mnemonic({FormosaTheme? theme = FormosaTheme.bip39}) {
    String delimiter = theme?.name == "BIP39_japanese" ? "\u3000" : " ";
    return Mnemonic._internal(theme: theme, delimiter: delimiter);
  }
  // getters
  int get pbkdf2Rounds => _pbkdf2Rounds;
  String? get delimiter => _delimiter;
  //
  String formatMnemonic(dynamic mnemonic) {
    mnemonic = _theme?.data.wordList();
    int n = isBip39Theme ? 4 : 2;
    List<String> password = [
      mnemonic.map((w) {
            return w.length >= n ? w.substring(0, n) : w + "-";
          }).join() +
          "\n"
    ];
    int phraseSize = _theme?.data.wordsPerPhrase() ?? 0;

    for (int phraseIndex = 0; phraseIndex < (mnemonic.length ~/ phraseSize); phraseIndex++) {
      password.add(mnemonic.sublist(phraseSize * phraseIndex, phraseSize * (phraseIndex + 1)).join(" ") + "\n");
    }
    String formattedPassword = password.join();
    return formattedPassword.substring(0, formattedPassword.length - 1);
  }

  /// Convert mnemonic and passphrase into a seed

  Future<Uint8List> toSeed(String mnemonic, {String passphrase = ""}) async {
    FormosaTheme? theme;
    try {
      theme = detectTheme(mnemonic);
      if (!isBip39Theme) {
        mnemonic = convertTheme(mnemonic, FormosaTheme.bip39, currentTheme: theme);
      }
    } catch (e) {
      throw Exception("Theme unrecognized for '$mnemonic'");
    }

    // Normalize strings
    mnemonic = normalizeString(mnemonic);
    passphrase = normalizeString(passphrase);

    // Prepend "mnemonic" to passphrase as per BIP39 standard
    passphrase = "mnemonic$passphrase";

    // Convert to bytes
    List<int> mnemonicBytes = utf8.encode(mnemonic);
    List<int> passphraseBytes = utf8.encode(passphrase);

    final pbkdf2 = cryptography.Pbkdf2(
      macAlgorithm: cryptography.Hmac.sha512(),
      iterations: _pbkdf2Rounds,
      bits: 512,
    );

    final key = await pbkdf2.deriveKey(
      secretKey: cryptography.SecretKey(mnemonicBytes),
      nonce: passphraseBytes,
    );
    final derivedKeyBytes = await key.extractBytes();
    final stretched = derivedKeyBytes.sublist(0, 64);
    return Uint8List.fromList(stretched);
  }

  /// Evaluates whether the theme chosen is from BIP39 or not
  bool get isBip39Theme {
    return _theme?.name.startsWith("bip39") ?? false;
  }

  List<String> normalizeMnemonic(dynamic mnemonic) {
    if (mnemonic is String) {
      mnemonic = mnemonic.split(" ");
    }
    return List<String>.from(mnemonic);
  }

  ///
  String normalizeString(dynamic txt) {
    String utxt;
    if (txt is List<int>) {
      utxt = utf8.decode(txt);
    } else if (txt is String) {
      utxt = txt;
    } else {
      throw ArgumentError('String or List<int> (bytes) value expected');
    }
    // Normalize to NFKD form (Note: Dart doesn't have direct support for NFKD normalization)
    utxt = utxt; // You may need to use a custom NFKD normalization library for Dart

    return utxt;
  }

  ///
  FormosaTheme detectTheme(dynamic code) {
    if (code is List<String>) {
      code = code.join(" ");
    }
    code = normalizeString(code);

    Set<FormosaTheme> possibleThemes = FormosaTheme.values.toSet();

    for (String word in code.split(" ")) {
      possibleThemes = possibleThemes.where((theme) => theme.data.wordList().contains(word)).toSet();

      if (possibleThemes.isEmpty) {
        throw "Theme unrecognized for '$word'";
      }
    }

    if (possibleThemes.length == 1) {
      return possibleThemes.first;
    } else {
      throw "Theme ambiguous between ${possibleThemes.map((theme) => theme.name).join(', ')}";
    }
  }

  ///
  String convertTheme(dynamic mnemonic, FormosaTheme newTheme, {FormosaTheme? currentTheme}) {
    if (!findThemes().contains(newTheme.name)) {
      throw "Theme ${newTheme.name} not found";
    }

    if (mnemonic is String) {
      mnemonic = mnemonic.split(" ");
    }

    if (currentTheme == null) {
      currentTheme = detectTheme(mnemonic);
      if (currentTheme is List) {
        throw "Theme detected is ambiguous, you must provide the mnemonic theme";
      }
    }

    final entropy = Mnemonic(theme: currentTheme).toEntropy(mnemonic);

    final newMnemonic = Mnemonic(theme: newTheme).toMnemonic(entropy);

    return newMnemonic;
  }

  ///
  List<String> findThemes() {
    return FormosaTheme.values.map((theme) => theme.name).toList();
  }

  /// The [toEntropy] method returns a entropy using provided one
  /// or set of [words].
  List<int> toEntropy(dynamic words) {
    final themeData = _theme?.data ?? FormosaTheme.bip39.data;
    if (words is String) {
      words = words.split(' ');
    }

    int wordsSize = words.length;
    var wordsDict = themeData;

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
      bitsFillSequence += themeData.bitsFillSequence();
    }

    String concatenationBits = '';
    for (int i = 0; phraseIndexes.length > i; i++) {
      concatenationBits += (phraseIndexes[i].toRadixString(2).padLeft(bitsFillSequence[i], '0'));
    }
    List<int> entropy_ = List.filled(entropyLengthBits ~/ 8, 0);
    int bitInt;

    for (int entropyId = 0; (entropyLengthBits / 8) > entropyId; entropyId += 1) {
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
    for (int entropyId = 0; (entropyLengthBits / 8) > entropyId; entropyId += 1) {
      entropy[entropyId] = int.parse(entropy_[entropyId].toString());
    }
    return entropy;
  }

  //
  String toMnemonic(List<int> data) {
    final uintData = Uint8List.fromList(data);
    final wordsDictionary = _theme?.data;
    const int leastMultiple = 4;
    if (uintData.lengthInBytes % leastMultiple != 0) {
      throw ArgumentError(
          "Number of bytes should be a multiple of $leastMultiple, but it is ${uintData.lengthInBytes}.");
    }

    // Hash digest using SHA-256
    List<int> hashDigest = sha256.convert(data).bytes;

    // Convert entropy to binary string
    String entropyBits =
        data.fold<String>('', (previousValue, byte) => previousValue + byte.toRadixString(2).padLeft(8, '0'));

    // Convert checksum to binary string
    String checksumBits = hashDigest
        .fold<String>('', (previousValue, byte) => previousValue + byte.toRadixString(2).padLeft(8, '0'))
        .substring(0, uintData.lengthInBytes * 8 ~/ 32);

    // Combine entropy and checksum bits
    String dataBits = entropyBits + checksumBits;

    // Generate mnemonic sentences from bits
    List<dynamic>? sentences = wordsDictionary?.getSentencesFromBits(dataBits);
    if (sentences == null) {
      throw "Failed to generate mnemonic sentences.";
    }

    // Join sentences with the delimiter to form the final mnemonic
    String mnemonic = _delimiter != null ? sentences.join(_delimiter ?? '') : sentences.join(' ');

    return mnemonic;
  }
}
