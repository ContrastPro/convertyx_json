import 'dart:io';
import 'dart:convert';

import '../../repositories/encode_classes.dart';
import '../../repositories/time_logger.dart';

void main() async {
  await _splitCompanyFile(
    country: 'Бразилия', // Бразилия, США
  );
}

int _indexFile = 1;
final Map _splitMap = {};

int _totalLength = 0;

Future<void> _splitCompanyFile({
  String country,
}) async {
  final TimeLogger timeLogger = TimeLogger();

  final String countryCode = Country.countryMap.keys.firstWhere((e) {
    return Country.countryMap[e].toLowerCase() == country.toLowerCase();
  }, orElse: () => null);

  if (countryCode == null) {
    timeLogger.displayMessage(
      'COUNTRY NOT EXIST <${country.toUpperCase()}>',
      error: 'ERROR',
    );
    return;
  }

  final Map companiesInMap = jsonDecode(
    await File(
      'bin/script/split/source/import-$countryCode.json',
    ).readAsString(),
  )['__collections__']['countries'][countryCode]['__collections__']
      ['companies'];

  for (int i = 0; i < companiesInMap.keys.length; i++) {
    _splitMap.addAll(
      Map.from({
        companiesInMap.keys.elementAt(i): Map.from(
          companiesInMap.values.elementAt(i),
        ),
      }),
    );

    if (i != 0 && i % 20000 == 0) {
      _saveMiddle(
        countryCode: countryCode,
        timeLogger: timeLogger,
      );
    }

    if (i == companiesInMap.length - 1) {
      _saveTotal(
        countryCode: countryCode,
        timeLogger: timeLogger,
      );
    }
  }

  timeLogger.displayMessage(
    'ORIGINAL: ${companiesInMap.length}'
    ' TOTAL: $_totalLength',
  );
  timeLogger.displayTotal();
}

void _saveMiddle({
  String countryCode,
  TimeLogger timeLogger,
}) {
  final File importFileCompanies = File(
    'bin/script/split/output/import-${countryCode}_$_indexFile.json',
  );

  importFileCompanies.writeAsStringSync(
    jsonEncode({
      '__collections__': {
        'countries': {
          '$countryCode': {
            '__collections__': {
              'companies': _splitMap,
            }
          }
        },
      }
    }),
  );

  _totalLength += _splitMap.length;

  timeLogger.displayMessage(
    'SPLIT FILE SAVED: '
    'import-${countryCode}_$_indexFile.json'
    ' $_totalLength',
  );

  _indexFile++;
  _splitMap.clear();
}

void _saveTotal({
  String countryCode,
  TimeLogger timeLogger,
}) async {
  if (_splitMap.isNotEmpty) {
    final File importFileCompanies = File(
      'bin/script/split/output/import-${countryCode}_$_indexFile.json',
    );

    importFileCompanies.writeAsStringSync(
      jsonEncode({
        '__collections__': {
          'countries': {
            '$countryCode': {
              '__collections__': {
                'companies': _splitMap,
              }
            }
          },
        }
      }),
    );

    _totalLength += _splitMap.length;

    timeLogger.displayMessage(
      'SPLIT FILE SAVED: '
      'import-${countryCode}_$_indexFile.json'
      ' $_totalLength',
    );
  }
}
