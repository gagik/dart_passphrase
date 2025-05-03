import 'dart:math';
import 'package:collection/collection.dart';

/// A class for generating secure passphrases using a word list.
class Passphrase {
  final List<String> _wordList;

  Passphrase(
    this._wordList,
  );

  /// The number of tokens in the word list.
  int get numberOfTokens => _wordList.length;

  /// The entropy per token in the word list.
  double get entropyPerToken => log(_wordList.length) / log(2);

  /// The maximum possible entropy for the passphrase.
  double get maximumEntropy => numberOfTokens * entropyPerToken;

  /// Generates a passphrase with the specified number of words.
  ///
  /// [count] must be a positive integer less than the number of tokens in the word list.
  Future<List<String>> generate(int count) async {
    assert(count > 0, 'count must be positive integer');
    assert(count < _wordList.length,
        'count must be less than the number of tokens');

    final random = Random.secure();
    return _wordList.sample(count, random);
  }

  /// Generates a passphrase with at least the specified minimum entropy.
  ///
  /// [minimum] must be a positive number less than the maximum possible entropy.
  Future<List<String>> generateWithEntropy(double minimum) async {
    assert(minimum > 0, 'minimum entropy must be positive');
    assert(minimum < maximumEntropy,
        'minimum entropy must be less than maximum possible entropy');

    final count = (minimum / entropyPerToken).ceil();
    return generate(count);
  }

  /// Returns the word list used for generating passphrases.
  List<String> get words => List.unmodifiable(_wordList);
}
