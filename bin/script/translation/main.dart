import 'dart:io';
import 'dart:convert';

import '../../repositories/encode_classes.dart';

void main() async {
  final File inputFile = File('bin/translation/source/input.txt');
  final File outputFile = File('bin/translation/output/output.json');
  final List<String> fileListOfStrings = await inputFile.readAsLines();

  final Map<String, String> res = {};

  int i = 0;
  CategoryTranslate.fields.forEach((key, value) {
    res[key] = '${fileListOfStrings[i]}';
    i++;
  });

  inputFile.writeAsStringSync('');
  outputFile.writeAsStringSync(jsonEncode({
    'categories': res,
  }));


  /*
  // Generate stop words
  List<String> res =[];

  fileListOfStrings.forEach((element) {
    res.add(element);
  });

  fileListOfStrings.forEach((element) {
    res.add(element.toUpperCase());
  });

  print(json.encode(res));*/
}
