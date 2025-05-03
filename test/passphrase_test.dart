import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:passphrase/passphrase.dart';
import 'package:test/test.dart';

void main() {
  group('Passphrase', () {
    late List<String> wordList;
    late Passphrase passphrase;

    setUp(() async {
      final jsonString = await File('./eff-wordlist.json').readAsString();
      wordList = (json.decode(jsonString) as List).cast<String>();
      passphrase = Passphrase(wordList);
    });

    test('ensure the world list is loaded properly', () async {
      expect(passphrase.words.length, 7776);
    });

    test('generate a passphrase with 10 words', () async {
      final result = await passphrase.generate(10);
      expect(result.length, 10);
    });

    test('generate a passphrase with 100 entropy', () async {
      final result = await passphrase.generateWithEntropy(100);
      expect(result.length, 8);
    });

    group('Basic Cryptographic Tests', () {
      late Passphrase passphrase;

      setUp(() async {
        final shortWordList = wordList.toList();
        shortWordList.shuffle(Random.secure());
        passphrase = Passphrase(shortWordList.take(100).toList());
      });

      test('verify randomness distribution', () async {
        final sampleSize = 10000;
        const wordCount = 5;
        final wordFrequencies = <String, int>{};

        // Generate multiple passphrases and count word frequencies
        for (var i = 0; i < sampleSize; i++) {
          final result = await passphrase.generate(wordCount);
          for (final word in result) {
            wordFrequencies[word] = (wordFrequencies[word] ?? 0) + 1;
          }
        }

        // Calculate expected frequency (should be roughly equal for each word)
        final expectedFrequency =
            (sampleSize * wordCount) / passphrase.words.length;

        // Check if frequencies are within reasonable bounds
        // We expect frequencies to be within 20% of expected value
        final lowerBound = expectedFrequency * 0.8;
        final upperBound = expectedFrequency * 1.2;

        for (final frequency in wordFrequencies.values) {
          expect(frequency, greaterThan(lowerBound));
          expect(frequency, lessThan(upperBound));
        }
      });

      test('verify uniqueness of generated passphrases', () async {
        const sampleSize = 10000;
        const wordCount = 5;
        final generatedPhrases = <String>{};

        for (var i = 0; i < sampleSize; i++) {
          final result = await passphrase.generate(wordCount);
          final phrase = result.join(' ');
          expect(generatedPhrases, isNot(contains(phrase)));
          generatedPhrases.add(phrase);
        }
      });

      test('verify entropy calculations', () async {
        final entropyPerWord = log(passphrase.words.length) / log(2);

        for (final entropy in [50.0, 100.0, 150.0, 200.0]) {
          final result = await passphrase.generateWithEntropy(entropy);
          final actualEntropy = result.length * entropyPerWord;
          expect(actualEntropy, greaterThanOrEqualTo(entropy));
        }
      });
    });
  });
}
