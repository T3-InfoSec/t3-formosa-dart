import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:t3_formosa/formosa.dart';
import 'package:t3_formosa/src/theme_base.dart';

class Mnemonic {
  FormosaTheme? _theme;
  final int _pbkdf2Rounds = 2048;
  String? _delimiter;

  Mnemonic._internal({FormosaTheme? theme, required String delimiter})
      : _theme = theme,
        _delimiter = delimiter;

  factory Mnemonic({FormosaTheme? theme = FormosaTheme.bip39}) {
    String delimiter = theme?.label == "BIP39_japanese" ? "\u3000" : " ";
    return Mnemonic._internal(theme: theme, delimiter: delimiter);
  }
  // getters
  int get pbkdf2Rounds => _pbkdf2Rounds;
  String? get delimiter => _delimiter;
  //
  String formatMnemonic(dynamic mnemonic) {
    mnemonic = _theme?.themeData.wordList();
    int n = isBip39Theme ? 4 : 2;
    List<String> password = [
      mnemonic.map((w) {
            return w.length >= n ? w.substring(0, n) : w + "-";
          }).join() +
          "\n"
    ];
    int phraseSize = _theme?.themeData.wordsPerPhrase() ?? 0;

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
    return _theme?.label.startsWith("bip39") ?? false;
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
      possibleThemes = possibleThemes.where((theme) => theme.themeData.wordList().contains(word)).toSet();

      if (possibleThemes.isEmpty) {
        throw "Theme unrecognized for '$word'";
      }
    }

    if (possibleThemes.length == 1) {
      return possibleThemes.first;
    } else {
      throw "Theme ambiguous between ${possibleThemes.map((theme) => theme.label).join(', ')}";
    }
  }

  ///
  String convertTheme(dynamic mnemonic, FormosaTheme newTheme, {FormosaTheme? currentTheme}) {
    if (!findThemes().contains(newTheme.label)) {
      throw "Theme ${newTheme.label} not found";
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
    return FormosaTheme.values.map((theme) => theme.label).toList();
  }

  ///
  Uint8List toEntropy(dynamic words) {
    // Normalize words to a list of strings
    if (words is String) {
      words = words.split(" ");
    }

    int wordsSize = words.length;
    _theme ??= detectTheme(words);
    var wordsDict = _theme?.themeData as ThemeBase;

    int phraseAmount = wordsDict.getPhraseAmount(words);
    int phraseSize = wordsDict.wordsPerPhrase();
    int bitsPerChecksumBit = 33;

    if (wordsSize % phraseSize != 0) {
      throw ArgumentError("The number of words must be a multiple of $phraseSize, but it is $wordsSize");
    }

    // Construct the concatenation of the original entropy and the checksum
    int numberPhrases = wordsSize ~/ wordsDict.wordsPerPhrase();
    int concatLenBits = (numberPhrases * wordsDict.bitsPerPhrase());
    int checksumLengthBits = (concatLenBits ~/ bitsPerChecksumBit);
    int entropyLengthBits = concatLenBits - checksumLengthBits;

    final List<int> bitsFillSequence = wordsDict.bitsFillSequence();

    // Map words to binary values
    List<String> idx = List.generate(wordsDict.getPhraseIndexes(words).length, (i) {
      int phraseIndex = wordsDict.getPhraseIndexes(words)[i];
      int bitFill = bitsFillSequence[i % bitsFillSequence.length] * phraseAmount;
      return phraseIndex.toRadixString(2).padLeft(bitFill, '0');
    });

    List<bool> concatBits = idx.join().split('').map((bit) => bit == "1").toList();

    // Extract original entropy as bytes
    Uint8List entropy = Uint8List(entropyLengthBits ~/ 8);
    print("ENT $entropy ENTBT $entropyLengthBits");

    // For every entropy byte
    for (int entropyIdx = 0; entropyIdx < entropy.length; entropyIdx++) {
      // For every entropy bit
      for (int bitIdx = 0; bitIdx < 8; bitIdx++) {
        // Avoid side-channel attack by avoiding predictable branching
        int bitInt = concatBits[(entropyIdx * 8) + bitIdx] ? 1 : 0;
        entropy[entropyIdx] |= bitInt << (7 - bitIdx);
      }
    }

    // Calculate checksum and test it
    List<int> hashBytes = sha256.convert(entropy).bytes;
    List<bool> hashBits =
        hashBytes.expand((byte) => List.generate(8, (bitIdx) => (byte & (1 << (7 - bitIdx))) != 0)).toList();

    bool valid = true;
    for (int bitIdx = 0; bitIdx < checksumLengthBits; bitIdx++) {
      valid &= concatBits[entropyLengthBits + bitIdx] == hashBits[bitIdx];
    }

    if (!valid) {
      throw ArgumentError("Failed checksum.");
    }

    return entropy;
  }

  //
  String toMnemonic(Uint8List data) {
    final wordsDictionary = _theme?.themeData;
    const int leastMultiple = 4;
    if (data.lengthInBytes % leastMultiple != 0) {
      throw ArgumentError("Number of bytes should be a multiple of $leastMultiple, but it is ${data.lengthInBytes}.");
    }

    // Hash digest using SHA-256
    List<int> hashDigest = sha256.convert(data).bytes;

    // Convert entropy to binary string
    String entropyBits =
        data.fold<String>('', (previousValue, byte) => previousValue + byte.toRadixString(2).padLeft(8, '0'));

    // Convert checksum to binary string
    String checksumBits = hashDigest
        .fold<String>('', (previousValue, byte) => previousValue + byte.toRadixString(2).padLeft(8, '0'))
        .substring(0, data.lengthInBytes * 8 ~/ 32);

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
