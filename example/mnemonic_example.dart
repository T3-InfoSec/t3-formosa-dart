import 'package:mnemonic/mnemonic.dart';

void main() {
  Mnemonic m = Mnemonic("finances");

  List<int> randomEntropy = [33, 254, 255, 33, 255, 56, 18, 51];
  String resultingMnemonic = m.toMnemonic(randomEntropy);
  List<int> entropyFromMnemonic = m.toEntropy(resultingMnemonic);

  print(resultingMnemonic);
  print(entropyFromMnemonic);

  if (randomEntropy.toString() == entropyFromMnemonic.toString()) {
    print("Equal!");
  } else {
    print("Not Equal!");
  }
}
