import 'dart:convert';
import 'dart:io';

import 'package:passphrase/passphrase.dart';

void main() async {
  final jsonString = await File('./eff-wordlist.json').readAsString();
  final wordList = (json.decode(jsonString) as List).cast<String>();
  var passphrase = Passphrase(wordList);
  print('passphrase: ${await passphrase.generate(10)}');
  print(
      'passphrase with 100 entropy: ${await passphrase.generateWithEntropy(100)}');

  print('index of "stack": ${passphrase.words.indexOf('stack')}');
}
