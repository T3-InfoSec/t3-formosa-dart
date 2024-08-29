import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:t3_formosa/formosa.dart';

class Mnemonic {
  final FormosaTheme? theme;
  // ignore: non_constant_identifier_names
  final PBKDF2_ROUNDS = 2048;

  const Mnemonic({
    this.theme = FormosaTheme.bip39,
  });

  String formatMnemonic(dynamic mnemonic) {
    mnemonic = theme?.themeData.wordList();
    int n = isBip39Theme ? 4 : 2;
    List<String> password = [
      mnemonic.map((w) {
            return w.length >= n ? w.substring(0, n) : w + "-";
          }).join() +
          "\n"
    ];
    int phraseSize = theme?.themeData.wordsPerPhrase() ?? 0;

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

    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha512(),
      iterations: PBKDF2_ROUNDS,
      bits: 512,
    );

    final key = await pbkdf2.deriveKey(
      secretKey: SecretKey(mnemonicBytes),
      nonce: passphraseBytes,
    );
    final derivedKeyBytes = await key.extractBytes();
    final stretched = derivedKeyBytes.sublist(0, 64);
    return Uint8List.fromList(stretched);
  }

  /// Evaluates whether the theme chosen is from BIP39 or not
  bool get isBip39Theme {
    return theme?.label.startsWith("bip39") ?? false;
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
  toEntropy(mnemonic) {
    //TODO: Convert mnemonic to entropy using the current theme
  }
  //
  toMnemonic(entropy) {
    //TODO: Convert entropy back to mnemonic using the new theme
  }
}
