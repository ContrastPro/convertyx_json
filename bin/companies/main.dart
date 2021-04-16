import 'dart:io';
import 'dart:convert';

import 'service/backup.dart';
import 'service/logger.dart';

import 'encode/encode_classes.dart';
import 'model/company.dart';

void main() async {
  final Logger progress = Logger();
  final Backup backup = Backup(
    fileName: 'bin/companies/output/output.json',
  );

  // Читаем файлы для импорта
  final List<String> sourceCategory = await File(
    'bin/companies/source/category.txt',
  ).readAsLines();

  final List<String> sourceName = await File(
    'bin/companies/source/display_name.txt',
  ).readAsLines();

  final List<String> sourceUrl = await File(
    'bin/companies/source/site_url.txt',
  ).readAsLines();

  // Читаем данные для сравнения и преобразования
  final Map assetsCategory = jsonDecode(await File(
    'bin/companies/assets/category.json',
  ).readAsString());

  final Map assetsTranslit = jsonDecode(await File(
    'bin/companies/assets/ru-EN.json',
  ).readAsString());

  int itemsLength = sourceCategory.length;
  for (int index = 0; index < itemsLength; index++) {
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
      keyTranslit: Search.encodeKey(
        searchQuery: TranslitValidator.encode(
          assetsTranslit: assetsTranslit,
          text: sourceName[index],
        ),
      ),
    ).toMap();
    progress.display(index, itemsLength);
  }

  // Write to file
  await backup.finalRecord();
  progress.displayTotal();
}
