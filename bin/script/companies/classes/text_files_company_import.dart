import 'dart:io';
import 'dart:convert';

import '../../../model/company.dart';
import '../../../repositories/encode_classes.dart';
import '../../../repositories/time_logger.dart';

class TextFilesCompanyImport {
  Future<void> getForEachCountry() async {
    final File importFile = File(
      'bin/script/companies/output/import-All.json',
    );

    final Map importMap = {};

    for (int i = 0; i < Country.countryMap.length; i++) {
      // Конвертируем компании для 1 страны
      final Map output = await importForSingleCountry(
        country: Country.countryMap.values.elementAt(i),
        saveImport: false,
      );

      // Добавляем сконвертированную компанию к другим странам
      importMap['${Country.countryMap.keys.elementAt(i)}'] = {
        '__collections__': {
          'companies': output,
        }
      };
    }

    // Импортируем полный список компаний готовых для загрузки в БД
    importFile.writeAsStringSync(
      jsonEncode({
        '__collections__': {
          'countries': importMap,
        }
      }),
    );
  }

  Future<Map> importForSingleCountry({
    String country,
    bool saveImport = true,
  }) async {
    TimeLogger timeLogger;
    if (saveImport == true) {
      timeLogger = TimeLogger();
    }

    final File fileName = File(
      'bin/script/companies/source/display_name.txt',
    );

    final File fileSite = File(
      'bin/script/companies/source/site_url.txt',
    );

    final File fileCategory = File(
      'bin/script/companies/source/category.txt',
    );

    // Читаем файлы для импорта
    final List<String> sourceName = await fileName.readAsLines();

    final List<String> sourceUrl = await fileSite.readAsLines();

    final List<String> sourceCategory = await fileCategory.readAsLines();

    if (sourceName.last.isEmpty) {
      sourceName.removeLast();
    }

    if (sourceUrl.last.isEmpty) {
      sourceUrl.removeLast();
    }

    if (sourceCategory.last.isEmpty) {
      sourceCategory.removeLast();
    }

    // Читаем данные для сравнения и преобразования
    final Map assetsCategory = jsonDecode(await File(
      'bin/script/companies/assets/category.json',
    ).readAsString());

    final Map assetsTranslit = jsonDecode(await File(
      'bin/script/companies/assets/translit.json',
    ).readAsString());

    final Map outputMap = {};
    final int itemsLength = sourceName.length;

    if (sourceName.length != sourceUrl.length ||
        sourceUrl.length != sourceCategory.length ||
        sourceName.length != sourceCategory.length) {
      timeLogger.displayMessage(
        'NOT RIGHT FILES LENGTH',
        error: 'ERROR',
      );
      return null;
    }

    for (int index = 0; index < itemsLength; index++) {
      final String uid = Uid.getUid();

      final String displayName = sourceName[index].trim();

      final String siteURL = sourceUrl[index].trim();

      final String category = sourceCategory[index].trim();

      // Create company object and convert to map
      outputMap[uid] = Company(
        uid: uid,
        displayName: displayName,
        siteURL: siteURL,
        photoURL: Url.encodeFavicon(url: siteURL),
        category: Category.encode(
          assetsCategory: assetsCategory,
          value: category,
        ),
        keyName: Search.encodeKey(
          searchQuery: displayName,
        ),
        keySite: Search.encodeKey(
          searchQuery: siteURL,
        ),
        keyTranslit: Search.encodeKey(
          searchQuery: Translit.encode(
            assetsTranslit: assetsTranslit,
            text: displayName,
          ),
        ),
      ).toMap();
    }

    final String countryCode = Country.countryMap.keys.firstWhere((e) {
      return Country.countryMap[e].toLowerCase() == country.toLowerCase();
    }, orElse: () => null);

    // Write to file
    if (saveImport == true) {
      if (countryCode != null) {
        final File importFile = File(
          'bin/script/companies/output/import-$countryCode.json',
        );
        importFile.writeAsStringSync(
          jsonEncode({
            '__collections__': {
              'countries': {
                '$countryCode': {
                  '__collections__': {
                    'companies': outputMap,
                  }
                }
              },
            }
          }),
        );

        timeLogger.displayMessage(
          'COUNTRY: ${country.toUpperCase()}, $countryCode',
        );

        await fileName.writeAsString('');
        await fileSite.writeAsString('');
        await fileCategory.writeAsString('');
      } else {
        timeLogger.displayMessage(
          'FILE NOT SAVED',
          error: 'ERROR',
        );
      }
    }

    return outputMap;
  }
}
