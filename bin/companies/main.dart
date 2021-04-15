import 'dart:io';
import 'dart:convert';

import 'decode/decode_classes.dart';
import 'model/company.dart';
import 'progress/progress_indicator.dart';

void main() async {
  final Progress progress = Progress();
  final Backup backup = Backup(
    fileName: 'bin/companies/output.json',
  );

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

  for (int index = 0; index < 20; index++) {
    // Do backups
    await backup.doBackup(index, 10);

    String uid = Uid.getUid();
    String siteURL = await Url.encode(url: sourceUrl[index]);

    // Create company object and convert to map
    backup.outputMap[uid] = Company(
      uid: uid,
      displayName: sourceName[index],
      siteURL: siteURL,
      photoURL: Url.encodeFavicon(url: siteURL),
      category: Category.encode(
        assetsCategory: assetsCategory,
        value: sourceCategory[index],
      ),
      keyName: Search.encodeKey(
        searchQuery: sourceName[index],
      ),
      keySite: Search.encodeKey(
        searchQuery: sourceUrl[index],
      ),
      keyTranslit: [],
    ).toMap();
    progress.display(index, sourceCategory.length);
  }

  // Write to file
  await backup.finalRecord();
  progress.displayTotal();
}
