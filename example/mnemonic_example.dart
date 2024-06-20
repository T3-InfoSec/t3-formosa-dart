import 'package:mnemonic/mnemonic.dart';
import 'package:collection/collection.dart';

void main() {

  Mnemonic m = Mnemonic("finances");

  
  Function eq = const ListEquality().equals;

  List<int> randomEntropy = [33,254,255,33,255,56,18,51];  
  var resultingMnemonic =  m.toMnemonic(randomEntropy);
  print(resultingMnemonic);
  var entropyFromMnemonic = m.toEntropy(resultingMnemonic);
  print(entropyFromMnemonic);
  if (eq(randomEntropy,entropyFromMnemonic)){
    print("OK");
  }
  else {
    print("NOK");
  } 
}
