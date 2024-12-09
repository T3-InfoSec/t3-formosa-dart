import 'package:t3_crypto_objects/crypto_objects.dart';
import 'package:t3_formosa/formosa.dart';

void main() {
  Entropy randomEntropy = Entropy.fromRandom(wordsNumber: 12);

  Formosa formosa = Formosa(randomEntropy.value, FormosaTheme.bip39);

  String formosaMnemonic = formosa.getMnemonic();

  print(formosaMnemonic);
}
