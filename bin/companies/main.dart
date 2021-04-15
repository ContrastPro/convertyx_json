import 'dart:convert';
import 'dart:io';

import 'decode/decode_classes.dart';
import 'model/company.dart';
import 'progress_indicator.dart';

void main() async {
  final Progress progress = Progress();
  final File file = File('bin/companies/output.json');
  final Map outputMap = {};

  // Читаем файлы со списка
  final List<String> sourceCategory = await File(
    'bin/companies/source/category.txt',
  ).readAsLines();

  final List<String> sourceName = await File(
    'bin/companies/source/display_name.txt',
  ).readAsLines();

  final List<String> sourceUrl = await File(
    'bin/companies/source/site_url.txt',
  ).readAsLines();

  final Map assetsCategory = jsonDecode(await File(
    'bin/companies/assets/category.json',
  ).readAsString());

  for (int i = 0; i < 5; i++) {
    String uid = Uid.getUid();
    String siteURL = await Url.encode(url: sourceUrl[i]);

    // Create company object and convert to map
    outputMap[uid] = Company(
      uid: uid,
      displayName: sourceName[i],
      siteURL: siteURL,
      photoURL: Url.encodeFavicon(url: siteURL),
      category: assetsCategory.keys.firstWhere((e) {
        return assetsCategory[e] == sourceCategory[i];
      }),
      keyName: Search.encodeKey(
        searchQuery: sourceName[i],
      ),
      keySite: Search.encodeKey(
        searchQuery: sourceUrl[i],
      ),
      keyTranslit: [],
    ).toMap();
    progress.display(i, sourceCategory.length);
  }

  // Write to file
  file.writeAsStringSync(
    jsonEncode(outputMap),
  );
  progress.displayTotal();
}
