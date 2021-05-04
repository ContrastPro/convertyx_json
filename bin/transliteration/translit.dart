import 'dart:convert';

import 'dart:io';

void main() async {
  /*String displayName = "Київстар Україна";
  String site = "google.com";

  String searchQuery = displayName;

  String temp = "";
  List<String> searchKey = [];
  for (int i = 0; i < searchQuery.length; i++) {
    temp = temp + searchQuery[i];
    searchKey.add(temp);
  }
  print(jsonEncode(searchKey));*/

  final List<String> file1Upper = await File('input1.txt').readAsLines();
  final List<String> file1Lover = await File('input1.txt').readAsLines();

  for (int i = 0; i < file1Lover.length; i++) {
    file1Upper.add(file1Lover[i].toLowerCase());
  }

  final List<String> file2Upper = await File('input2.txt').readAsLines();
  final List<String> file2Lover = await File('input2.txt').readAsLines();

  for (int i = 0; i < file1Lover.length; i++) {
    file2Upper.add(file2Lover[i].toLowerCase());
  }

  Map<String, String> map = Map.fromIterables(file1Upper, file2Upper);

  print(jsonEncode(map));
}

class Translit {
  final Map _transliteratedSymbol = {
    'А': 'A',
    'Б': 'B',
    'В': 'V',
    'Г': 'G',
    'Д': 'D',
    'Е': 'E',
    'Ё': 'Yo',
    'Ж': 'Zh',
    'З': 'Z',
    'И': 'I',
    'Й': 'J',
    'К': 'K',
    'Л': 'L',
    'М': 'M',
    'Н': 'N',
    'О': 'O',
    'П': 'P',
    'Р': 'R',
    'С': 'S',
    'Т': 'T',
    'У': 'U',
    'Ф': 'F',
    'Х': 'H',
    'Ц': 'C',
    'Ч': 'Ch',
    'Ш': 'Sh',
    'Щ': 'Shch',
    'Ы': 'Y',
    'Э': 'Eh',
    'Ю': 'Yu',
    'Я': 'Ya',
    'а': 'a',
    'б': 'b',
    'в': 'v',
    'г': 'g',
    'д': 'd',
    'е': 'e',
    'ё': 'yo',
    'ж': 'zh',
    'з': 'z',
    'и': 'i',
    'й': 'j',
    'к': 'k',
    'л': 'l',
    'м': 'm',
    'н': 'n',
    'о': 'o',
    'п': 'p',
    'р': 'r',
    'с': 's',
    'т': 't',
    'у': 'u',
    'ф': 'f',
    'х': 'h',
    'ц': 'c',
    'ч': 'ch',
    'ш': 'sh',
    'щ': 'shch',
    'ы': 'y',
    'э': 'eh',
    'ю': 'yu',
    'я': 'ya',
  };

  /// Method for converting to translit for the [source] value
  String toTranslit({String source}) {
    var translit = [];
    var sourceSymbols = [];

    sourceSymbols = source.split('');

    for (final element in sourceSymbols) {
      translit.add(_transliteratedSymbol.containsKey(element)
          ? _transliteratedSymbol[element]
          : element);
    }

    return translit.join();
  }
}
