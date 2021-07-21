import 'dart:io';
import 'dart:convert';

import 'package:excel/excel.dart';

import '../../../model/company.dart';
import '../../../repositories/time_logger.dart';
import '../../../repositories/encode_classes.dart';

// TODO: для повышения скорости можно читать с разных листов
// TODO: как отзывы [SingleExcelFileReviewsImport]

class SingleExcelFileCompanyImport {
  int _totalRow;
  int _currentRow;
  String _countryName;
  final Map _companiesMap = {};

  Future<void> importFromSingleFile() async {
    const String fileName = 'База подготовленная';

    final TimeLogger timeLogger = TimeLogger();

    final Map assetsCategory = jsonDecode(await File(
      'bin/script/companies/assets/category.json',
    ).readAsString());

    final Map assetsTranslit = jsonDecode(await File(
      'bin/script/companies/assets/translit.json',
    ).readAsString());

    final Excel excel = Excel.decodeBytes(
      File('bin/script/companies/source/$fileName.xlsx').readAsBytesSync(),
    );

    final String tableExcel = excel.tables.keys.first;

    _totalRow = excel.tables[tableExcel].rows.length;

    for (int x = 1; x < _totalRow; x++) {
      if (x == 1) {
        timeLogger.displayMessage('START IMPORT FROM EXCEL FILE');
      }
      _currentRow = x;
      final List<Data> row = excel.tables[tableExcel].rows[x];
      _countryName = row[2]?.value?.toString()?.toLowerCase()?.trim();

      final String countryCode = Country.countryMap.keys.firstWhere((e) {
        return Country.countryMap[e].toLowerCase() == _countryName;
      }, orElse: () => null);

      if (countryCode != null) {
        final String uid = Uid.getUid();

        final String displayName = row[0]?.value?.toString()?.trim();

        final String siteURL = row[1].value.toString()?.trim();

        final String category = row[3]?.value?.toString()?.trim();

        // Create company object and convert to map
        _companiesMap.addAll({
          uid: Map.from(
            Company(
              uid: uid,
              displayName: displayName,
              siteURL: siteURL,
              photoURL: Url.encodeFavicon(
                url: siteURL,
              ),
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
            ).toMap(),
          ),
        });

        if (x + 1 < excel.tables[tableExcel].rows.length) {
          final List<Data> nextRow = excel.tables[tableExcel].rows[x + 1];
          final String nextCountry =
              nextRow[2]?.value?.toString()?.toLowerCase()?.trim();

          if (nextCountry != _countryName) {
            await _addToOutputFile(
              countryCode: countryCode,
              timeLogger: timeLogger,
            );
            _companiesMap.clear();
          }
        } else {
          await _addToOutputFile(
            countryCode: countryCode,
            timeLogger: timeLogger,
          );
        }
      }
    }

    timeLogger.displayTotal();
  }

  Future<void> _addToOutputFile({
    String countryCode,
    TimeLogger timeLogger,
  }) async {
    final File importFileCompanies = File(
      'bin/script/companies/output/import-$countryCode.json',
    );

    importFileCompanies.writeAsStringSync(
      jsonEncode({
        '__collections__': {
          'countries': {
            '$countryCode': {
              '__collections__': {
                'companies': _companiesMap,
              }
            }
          },
        }
      }),
    );

    timeLogger.displayCurrent(
      _currentRow,
      _totalRow,
      message: 'COUNTRY: ${_countryName.toUpperCase()}, $countryCode',
    );
  }
}
