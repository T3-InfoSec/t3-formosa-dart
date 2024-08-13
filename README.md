# t3-formosa-dart

Dart implementation of Formosa, for use in T3 Vault.

[Formosa](https://github.com/Yuri-SVB/formosa) is a password format that maximizes the ratio of password strength to user effort.

The password generation process consists of mapping input into meaningful mnemonic sentences, that are, then, condensed into the password.

This is an improvement on the BIP-0039 method — which provides sequences of semantically and syntactically disconnected words as passphrases — because it uses meaningful phrases with a certain theme.

## Features

-   Generate mnemonic based on specific entropy.
-   Reverse entropy from mnemonic.
-   Choose specific theme to create mnemonic.

## Getting started

To start using Mnemonic, add it to your `pubspec.yaml`:

```yaml
dependencies:
    mnemonic: ^0.1.0-dev
```

Then, run the following command to install the package.

```bash
dart pub get
```

### Running tests

To run the tests for Mnemonic, use the following command in the root directory:

```bash
dart test test/mnemonic_test.dart
```

or simply:

```bash
dart test
```

## Usage

Example code on how to use Formosa to generate mnemonic hash sentences.

```dart
import 'package:knowledge/mnemonics.dart';

void main() {
  // Create a Hashviz instance
  Mnemonic mnemonic = Mnemonic("BIP39");
  Function eq = const ListEquality().equals;

  List<int> random_entropy = [33,254,255,33,255,56,18,51];

  // Generate an unique mnemonic based on input.
  var resulting_mnemonic =  m.to_mnemonic(random_entropy);

  // Reverse the process.
  var entropy_from_mnemonic = m.to_entropy(resulting_mnemonic);

  //Check did process went fine.
  if (eq(random_entropy, entropy_from_mnemonic)){
    print("OK");
  } else {
    print("NOK");
  }
}
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
