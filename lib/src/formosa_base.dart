import 'package:crypto/crypto.dart';

import 'formosa_theme.dart';

/// A wrap implementation upon bip39 for supporting semantically connected
/// words implementation upon multiple supported themes.
class Formosa {
  final FormosaTheme _formosaTheme;
  late List<int> _entropy;
  late String _seed;

  /// Creates an instance of Formosa using the given FormosaTheme and initial entropy.
  ///
  /// The seed is automatically derived based on the initial entropy provided
  /// and the words defined by the specified FormosaTheme.
  Formosa({
    required FormosaTheme formosaTheme,
    required List<int> entropy,
  })  : _formosaTheme = formosaTheme {
    _entropy = entropy;
    _seed = _generateSeed(entropy);
  }

  /// Returns [formosaTheme] associated with this instance.
  ///
  /// The theme defines the logic for converting entropy bits into
  /// mnemonic phrases and ensures compatibility with the desired word set.
  FormosaTheme get formosaTheme => _formosaTheme;

  /// Returns the current [entropy] of this Formosa instance.
  ///
  /// The entropy serves as the binary source for generating the mnemonic
  /// seed phrase.
  List<int> get entropy => _entropy;

  /// Updates the [entropy] of this Formosa instance and recalculates the seed.
  ///
  /// Whenever the entropy changes, the seed is automatically re-generated
  /// to reflect the new entropy state.
  set entropy(List<int> newEntropy) {
    _entropy = newEntropy;
    _seed = _generateSeed(newEntropy);
  }

  /// Returns the mnemonic [seed] phrase derived from the current entropy.
  ///
  /// The seed is expressed as a human-readable sequence of words, ensuring
  /// compatibility with BIP39 or similar mnemonic standards.
  String get seed => _seed;

  /// Generates the mnemonic [seed] phrase based on the given [entropy].
  ///
  /// This process involves converting entropy bits into mnemonic phrases
  /// using the logic defined in the associated FormosaTheme. The seed
  /// reflects the checksum-integrated mnemonic representation of the entropy.
  String _generateSeed(List<int> entropy) {
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
}
