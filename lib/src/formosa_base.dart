import 'package:crypto/crypto.dart';

import 'formosa_theme.dart';

/// A wrap implementation upon bip39 for supporting semantically connected
/// words implementation upon multiple supported themes.
class Formosa {
  final FormosaTheme _formosaTheme;
  late List<int> _entropy;
  late String _mnemonic;

  /// Creates an instance of Formosa using the given FormosaTheme and initial entropy.
  ///
  /// The [mnemonic] is automatically derived based on the initial [entropy] provided
  /// and the words defined by the specified FormosaTheme.
  Formosa({
    required FormosaTheme formosaTheme,
    required List<int> entropy,
  })  : _formosaTheme = formosaTheme {
    _entropy = entropy;
    _mnemonic = _toMnemonic(entropy);
  }

  /// Creates an instance of Formosa using the given [formosaTheme] and initial [mnemonic].
  ///
  /// The [entropy] is automatically derived based on the initial mnemonic provided
  /// and the words defined by the specified FormosaTheme.
  Formosa.fromMnemonic({
    required FormosaTheme formosaTheme,
    required String mnemonic,
  }) : _formosaTheme = formosaTheme {
    _mnemonic = mnemonic;
    _entropy = _toEntropy(mnemonic);
  }

  /// Returns [formosaTheme] associated with this instance.
  ///
  /// The theme defines the logic for converting entropy bits into
  /// mnemonic phrases and ensures compatibility with the desired word set.
  FormosaTheme get formosaTheme => _formosaTheme;

  /// Returns the current [entropy] of this Formosa instance.
  ///
  /// The entropy serves as the binary source for generating the mnemonic phrase.
  List<int> get entropy => _entropy;

  /// Updates the [entropy] of this Formosa instance and recalculates the mnemonic.
  ///
  /// Whenever the entropy changes, the mnemonic is automatically re-generated
  /// to reflect the new entropy state.
  set entropy(List<int> newEntropy) {
    _entropy = newEntropy;
    _mnemonic = _toMnemonic(newEntropy);
  }

  /// Returns the mnemonic [mnemonic] phrase derived from the current entropy.
  ///
  /// The mnemonic is expressed as a human-readable sequence of words, ensuring
  /// compatibility with BIP39 or similar mnemonic standards.
  String get mnemonic => _mnemonic;

  /// Generates the [mnemonic] phrase based on the given [entropy].
  ///
  /// This process involves converting entropy bits into mnemonic phrases
  /// using the logic defined in the associated FormosaTheme. The mnemonic
  /// reflects the checksum-integrated mnemonic representation of the entropy.
  String _toMnemonic(List<int> entropy) {
    int leastMultiple = 4;
    if (entropy.isEmpty || entropy.length % leastMultiple != 0) {
      throw ArgumentError(
          'Entropy length must be a non-zero multiple of $leastMultiple');
    }

    var hashObject = sha256.convert(entropy);

    String entropyBits = entropy
        .map((e) => e.toRadixString(2).padLeft(8, '0'))
        .join();

    String checksumBits = hashObject.bytes
        .map((e) => e.toRadixString(2).padLeft(8, '0'))
        .join()
        .substring(0, entropy.length * 8 ~/ 32);

    String dataBits = entropyBits + checksumBits;

    List sentences = formosaTheme.data.getSentencesFromBits(dataBits);
    return sentences.join(' ');
  }

  /// Returns the [entropy] from the current [mnemonic].
  List<int> _toEntropy(String mnemonic) {
    List<String> words = mnemonic.split(' ');

    int wordsSize = words.length;
    var wordsDict = formosaTheme.data;
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
      bitsFillSequence += formosaTheme.data.bitsFillSequence();
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
}
