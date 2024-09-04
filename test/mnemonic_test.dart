import 'dart:typed_data';
import 'package:t3_formosa/formosa.dart';
import 'package:t3_formosa/src/mnemonic.dart';
import 'package:test/test.dart';

void main() {
  group('Mnemonic Tests - BIP39 Theme', () {
    late Mnemonic mnemonicBip39;
    late Uint8List entropy;
    // temp mnemonic
    String bip39Mnemonic =
        'abandon math mimic master filter design carbon crystal rookie group knife wrap absurd much snack melt grid rough chapter fever rubber humble room trophy';

    setUp(() {
      mnemonicBip39 = Mnemonic(theme: FormosaTheme.bip39);

      // Sample entropy for testing (256-bit entropy)
      entropy = Uint8List.fromList([
        0x00,
        0x11,
        0x22,
        0x33,
        0x44,
        0x55,
        0x66,
        0x77,
        0x88,
        0x99,
        0xaa,
        0xbb,
        0xcc,
        0xdd,
        0xee,
        0xff,
        0x00,
        0x11,
        0x22,
        0x33,
        0x44,
        0x55,
        0x66,
        0x77,
        0x88,
        0x99,
        0xaa,
        0xbb,
        0xcc,
        0xdd,
        0xee,
        0xff,
      ]);
    });

    test('Generate mnemonic from entropy using BIP39 theme', () {
      bip39Mnemonic = mnemonicBip39.toMnemonic(entropy);
      expect(bip39Mnemonic.isNotEmpty, true);
      print('Generated BIP39 Mnemonic: $bip39Mnemonic');
    });

    test('Convert BIP39 mnemonic to seed', () async {
      final seed = await mnemonicBip39.toSeed(bip39Mnemonic);
      expect(seed.length, 64); // BIP39 seed should be 64 bytes
      print('Generated Seed: $seed');
    });

    test('Normalize BIP39 mnemonic', () {
      final normalizedMnemonic = mnemonicBip39.normalizeMnemonic(bip39Mnemonic);
      expect(normalizedMnemonic.length, 24);
      // BIP39 usually has 24 words in a 256-bit entropy
    });

    test('Convert BIP39 mnemonic to medievalFantasy theme', () {
      // Convert to a different theme, for example, medievalFantasy
      final medievalFantasyMnemonic = mnemonicBip39.convertTheme(bip39Mnemonic, FormosaTheme.medievalFantasy);
      expect(medievalFantasyMnemonic.isNotEmpty, true);
      print('Converted to medievalFantasy Mnemonic: $medievalFantasyMnemonic');
    });

    test('Validate checksum for BIP39 mnemonic', () {
      final validatedEntropy = mnemonicBip39.toEntropy(bip39Mnemonic);
      expect(validatedEntropy, entropy); // Ensure the entropy matches the original
    });
  });

  group(
    'Mnemonic Test - Formosa Themes',
    () {},
  );
}
