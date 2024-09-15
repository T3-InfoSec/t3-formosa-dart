# t3-formosa-dart

Dart implementation of Formosa, for use in T3 Vault.

[Formosa](https://github.com/Yuri-SVB/formosa) is a password format that maximizes the ratio of password strength to user effort.

The password generation process consists of mapping input into meaningful formosa sentences, that are, then, condensed into the password.

This is an improvement on the BIP-0039 method -- which provides sequences of semantically and syntactically disconnected words as passphrases -- because it uses meaningful phrases with a certain theme.

## Features

-   Generate formosa based on specific entropy.
-   Reverse entropy from formosa.
-   Choose specific theme to create formosa.

## Getting started

To start using Formosa, add it to your `pubspec.yaml`:

```yaml
dependencies:
    t3_formosa: ^0.1.0-dev
```

Then, run the following command to install the package.

```bash
dart pub get
```

### Running tests

To run the tests for Formosa, use the following command in the root directory:

```bash
dart test test/formosa_test.dart
```

or simply:

```bash
dart test
```

## Usage

Example code on how to use Formosa to generate formosa hash sentences.

```dart
import 'package:collection/collection.dart';
import 'package:t3_formosa/formosa.dart';

void main() {
  // Create a Formosa instance
  Formosa formosa = Formosa(formosaTheme: FormosaTheme.finances);

  List<int> randomEntropy = [33, 254, 255, 33, 255, 56, 18, 51];

  // Generate an unique formosa based on input.
  String resultingFormosa = formosa.toFormosa(randomEntropy);

  // Reverse the process.
  List<int> entropyFromFormosa = formosa.toEntropy(resultingFormosa);

  print(resultingFormosa);
  print(entropyFromFormosa);

  // Check did process went fine.
  if (randomEntropy.toString() == entropyFromFormosa.toString()) {
    print('Equal!');
  } else {
    print('Not Equal!');
  }
}
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
sign with gpg
