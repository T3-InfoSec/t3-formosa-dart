import 'dart:typed_data';
import 'package:t3_formosa/formosa.dart';

void main() {
  Uint8List randomEntropy = Formosa.generateRandomEntropy(wordsNumber: 12);

  Formosa formosa = Formosa(formosaTheme: FormosaTheme.bip39, entropy: randomEntropy);

  String formosaMnemonic = formosa.mnemonic;

  print(formosaMnemonic);
}
