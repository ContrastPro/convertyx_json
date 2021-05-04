import 'dart:io';

import 'dart:convert';

void main() async {
  final String outputName = 'fr'.toLowerCase();

  final List<String> fileFrom = await File(
    'bin/transliteration/source/input_from.txt',
  ).readAsLines();

  final List<String> fileTo = await File(
    'bin/transliteration/source/input_to.txt',
  ).readAsLines();

  final List<String> fileFromLover = [...fileFrom];
  final List<String> fileToLover = [...fileTo];

  for (int i = 0; i < fileFromLover.length; i++) {
    fileFrom.add(fileFromLover[i].toLowerCase());
  }

  for (int i = 0; i < fileFromLover.length; i++) {
    fileTo.add(fileToLover[i].toLowerCase());
  }

  final Map<String, String> transliteration =
      Map.fromIterables(fileFrom, fileTo);

  final File outputFile = File(
    'bin/transliteration/output/$outputName-EN.json',
  );

  outputFile.writeAsStringSync(
    jsonEncode(transliteration),
  );
}
