# passphrase

A Dart package for generating cryptographically secure passphrases from an in-memory word list. Designed for various security applications.

## Features

- Generate passphrases with a specified number of words
- Generate passphrases with a target entropy level
- Use custom word lists for passphrase generation
- Secure random number generation for word selection

## Getting started

Use `pub get passphrase` or add the following to your `pubspec.yaml`:

```yaml
dependencies:
  passphrase: ^1.0.0
```

Then run:
```bash
flutter pub get
```

## Usage

Here's a basic example of how to use the package:

```dart
import 'package:passphrase/passphrase.dart';

void main() async {
  // Create a passphrase generator with your word list
  // The file is not bundled with the package but you can download it from the EFF website
  // or from the package repository.
  final wordList = File('./eff-wordlist.json').readAsStringSync();
  final passphrase = Passphrase(wordList);

  // Generate a passphrase with 3 words
  final words = await passphrase.generate(3);
  print(words.join(' ')); // e.g., "banana date apple"

  // Generate a passphrase with minimum entropy
  final entropyWords = await passphrase.generateWithEntropy(10.0);
  print(entropyWords.join(' '));

  // Access the word list
  final allWords = passphrase.words;
  print('Available words: ${allWords.length}');
}
```

## Acknowledgements

This package is heavily inspired by the JavaScript [eff-diceware-passphrase](https://github.com/emilbayes/eff-diceware-passphrase) package.

## Additional information

For more information about passphrase security and best practices, refer to:
- [EFF's Word Lists](https://www.eff.org/dice)
- [Diceware Passphrase](https://en.wikipedia.org/wiki/Diceware)

## Contributing

Contributions are welcome! Please feel free to open an issue or submit a Pull Request.

## Disclaimer

This package is provided as-is, without any warranty. Use at your own risk.

## License

This project is licensed under the Apache License 2.0 - see the LICENSE file for details.