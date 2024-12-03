import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'formosa_theme.dart';

/// A wrap implementation upon bip39 for supporting semantically connected
/// words implementation upon multiple supported themes.
class Formosa {
  final FormosaTheme _formosaTheme;
  late Uint8List _entropy; // TODO: extends from Entropy
  late String _mnemonic;

  /// Creates an instance of Formosa using the given FormosaTheme and initial entropy.
  ///
  /// The [mnemonic] is automatically derived based on the initial [entropy] provided
  /// and the words defined by the specified FormosaTheme.
  Formosa({
    required FormosaTheme formosaTheme,
    required Uint8List entropy,
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
  Uint8List get entropy => _entropy;

  /// Updates the [entropy] of this Formosa instance and recalculates the mnemonic.
  ///
  /// Whenever the entropy changes, the mnemonic is automatically re-generated
  /// to reflect the new entropy state.
  set entropy(Uint8List newEntropy) {
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
  String _toMnemonic(Uint8List entropy) {
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
  Uint8List _toEntropy(String mnemonic) {
    List<String> words = mnemonic.split(' ');

    int wordsSize = words.length;
    var wordsDict = formosaTheme.data;
    
    // Check if the number of words is a multiple of phraseSize
    int phraseSize = wordsDict.wordsPerPhrase();
    if (wordsSize % phraseSize != 0) {
      // El número de palabras no es un múltiplo adecuado
      return Uint8List(0); // Retorna una lista vacía si no es múltiplo
    }

    // Calculation of the total length in bits
    int numberPhrases = wordsSize ~/ phraseSize;
    int concatenationLenBits = numberPhrases * wordsDict.bitsPerPhrase();
    int checksumLengthBits = concatenationLenBits ~/ 33;  // Ajustado para checksum
    int entropyLengthBits = concatenationLenBits - checksumLengthBits;

    // Get the word indexes
    List<int> phraseIndexes = wordsDict.getPhraseIndexes(words);

    // Construct the concatenation bit sequence
    String concatenationBits = phraseIndexes.map((index) {
      return index.toRadixString(2).padLeft(11, '0'); // 11 bits por palabra
    }).join();

    // Create Uint8List to store the result
    int byteLength = entropyLengthBits ~/ 8;
    Uint8List entropy = Uint8List(byteLength);

    // Fill the Uint8List with the corresponding bits
    for (int i = 0; i < byteLength; i++) {
      int byteStartIndex = i * 8;
      int byteValue = 0;

      // Extract the 8 bits corresponding to this byte
      for (int j = 0; j < 8; j++) {
        if (concatenationBits[byteStartIndex + j] == '1') {
          byteValue |= (1 << (7 - j));
        }
      }

      entropy[i] = byteValue;
    }

    return entropy;
  }


  static Uint8List generateRandomEntropy({int wordsNumber = 12}) { // TODO: move to Entropy
    const int byteMaxValue = 256;
    const double bytesPerWord = 1.33;    
    final int entropyBytesForSeed = (wordsNumber * bytesPerWord).ceil();

    Uint8List randomEntropy = Uint8List(entropyBytesForSeed);
    Random random = Random.secure();
    for (int i = 0; i < randomEntropy.length; i++) {
      randomEntropy[i] = random.nextInt(byteMaxValue);
    }
    return randomEntropy;
  }
}
