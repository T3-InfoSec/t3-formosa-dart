import 'package:t3_formosa/formosa.dart';
import 'package:test/test.dart';

void main() {
  group('Formosa Class Tests', () {
    late FormosaTheme theme = FormosaTheme.bip39;
    late List<int> entropy = [0, 0, 0, 0];

    test('should initialize with provided entropy and generate mnemonic', () {
      final formosa = Formosa(formosaTheme: theme, entropy: entropy);

      expect(formosa.entropy, equals(entropy));

      expect(formosa.mnemonic, isNotEmpty);
    });

    test('should throw ArgumentError when entropy length is not a multiple of 4', () {
      final invalidEntropy = [0, 1, 2];
      expect(
        () => Formosa(formosaTheme: theme, entropy: invalidEntropy),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should update mnemonic when entropy is updated', () {
      final formosa = Formosa(formosaTheme: theme, entropy: entropy);

      final originalMnemonic = formosa.mnemonic;

      final newEntropy = [1, 1, 1, 1];
      formosa.entropy = newEntropy;

      expect(formosa.mnemonic, isNot(originalMnemonic));
    });

    test('should generate valid mnemonic based on entropy', () {
      final formosa = Formosa(formosaTheme: theme, entropy: entropy);

      expect(formosa.mnemonic, isA<String>());
      expect(formosa.mnemonic.split(' ').length, greaterThan(1));
    });
  });
}
