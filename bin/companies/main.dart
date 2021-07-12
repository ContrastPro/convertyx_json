import 'dart:io';
import 'dart:convert';

import 'encode/encode_classes.dart';
import 'model/company.dart';

void main() async {
  // Импорт компании для 1 конкретной страны
  await importForSingleCountry(
    country: 'AR',
    saveImport: true,
  );

  // Импорт компаний для 193 стран
  //await getForEachCountry();
}

Future<Map> importForSingleCountry({
  String country,
  bool saveImport = true,
}) async {
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
    'bin/companies/assets/translit.json',
  ).readAsString());

  final Map outputMap = {};
  final int itemsLength = sourceName.length;

  for (int index = 0; index < itemsLength; index++) {
    final String uid = Uid.getUid();

    // Create company object and convert to map
    outputMap[uid] = Company(
      uid: uid,
      displayName: sourceName[index].trim(),
      siteURL: sourceUrl[index].trim(),
      photoURL: Url.encodeFavicon(url: sourceUrl[index].trim()),
      category: Category.encode(
        assetsCategory: assetsCategory,
        value: sourceCategory[index].trim(),
      ),
      keyName: Search.encodeKey(
        searchQuery: sourceName[index].trim(),
      ),
      keySite: Search.encodeKey(
        searchQuery: sourceUrl[index].trim(),
      ),
      keyTranslit: Search.encodeKey(
        searchQuery: Translit.encode(
          assetsTranslit: assetsTranslit,
          text: sourceName[index].trim(),
        ),
      ),
    ).toMap();
  }

  // Write to file
  if (saveImport == true) {
    final File importFile = File('bin/companies/output/import-$country.json');
    importFile.writeAsStringSync(
      jsonEncode({
        '__collections__': {
          'countries': {
            '$country': {
              '__collections__': {
                'companies': outputMap,
              }
            }
          },
        }
      }),
    );
  }

  return outputMap;
}

Future<void> getForEachCountry() async {
  final File importFile = File('bin/companies/output/import-All.json');
  final Map importMap = {};

  for (int i = 0; i < Country.countryList.length; i++) {
    // Конвертируем компании для 1 страны
    Map output = await importForSingleCountry(
      country: Country.countryList[i],
      saveImport: false,
    );

    // Добавляем сконвертированную компанию к другим странам
    importMap['${Country.countryList[i]}'] = {
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
