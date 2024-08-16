import 'package:t3_formosa/formosa.dart';

void main() {
  Formosa formosa = Formosa(theme: Theme.finances);

  List<int> randomEntropy = [33, 254, 255, 33, 255, 56, 18, 51];
  String resultingFormosa = formosa.toFormosa(randomEntropy);
  List<int> entropyFromFormosa = formosa.toEntropy(resultingFormosa);

  print(resultingFormosa);
  print(entropyFromFormosa);

  if (randomEntropy.toString() == entropyFromFormosa.toString()) {
    print('Equal!');
  } else {
    print('Not Equal!');
  }
}
