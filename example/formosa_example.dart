import 'dart:math';
import 'dart:typed_data';
import 'package:t3_formosa/formosa.dart';

void main() {
  Uint8List randomEntropy = generateRandomEntropy();

  Formosa formosa = Formosa(formosaTheme: FormosaTheme.bip39, entropy: randomEntropy);

  String formosaSeed = formosa.seed;

  print(formosaSeed);
}

Uint8List generateRandomEntropy() {
  Uint8List randomEntropy = Uint8List(16);
  Random random = Random();
  for (int i = 0; i < randomEntropy.length; i++) {
    randomEntropy[i] = random.nextInt(256); // Generates a number between 0 and 255
  }
  return randomEntropy;
}
