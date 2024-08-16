// TODO: Complete the copyright.
// Copyright (c) 2024, ...

/// A password format that maximizes the ratio of password strength to user effort.
///
/// The password generation process consists of mapping input into meaningful
/// mnemonic sentences, that are, then, condensed into the password. This is
/// an improvement on the BIP-0039 method -- which provides sequences of
/// semantically and syntactically disconnected words as passphrases -- because
/// it uses meaningful phrases with a certain theme.
// TODO: Complete the library-level documentation comments.
library;

export 'src/mnemonic_base.dart';
export 'src/themes/themes.dart';
