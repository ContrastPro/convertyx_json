import 'dart:io';
import 'dart:convert';

import 'package:excel/excel.dart';

import '../../../model/review.dart';
import '../../../repositories/encode_classes.dart';
import '../../../repositories/time_logger.dart';

// TODO: Отредактировать в соответствии с [SingleExcelFileReviewsImport]

class SinglePageExcelFileReviewsImport {
  int _currentRow;
  int _totalRow;

  String _siteURL;
  int _numOfReviews = 0;
  double _totalRating = 0.0;
  final Map _reviewsMap = {};

  final Map _outputCompany = {};
  final Map _outputReviews = {};

  //'Timestamp(seconds=1625830840, nanoseconds=853757000)';
  static const Map _creationTime = {
    '__datatype__': 'timestamp',
    'value': {
      '_seconds': 1625830840,
      '_nanoseconds': 853757000,
    }
  };

  Future<void> convertReviews({
    String country,
    String fileName,
  }) async {
    final TimeLogger timeLogger = TimeLogger();

    final String countryCode = Country.countryMap.keys.firstWhere((e) {
      return Country.countryMap[e].toLowerCase() == country.toLowerCase();
    }, orElse: () => null);

    if (countryCode == null) {
      timeLogger.displayMessage(
        'COUNTRY NOT EXIST',
        error: 'ERROR',
      );
      return;
    }

    final Map companiesInMap = jsonDecode(
      await File(
        'bin/script/reviews/source/import-$countryCode.json',
      ).readAsString(),
    )['__collections__']['countries'][countryCode]['__collections__']
        ['companies'];

    final Excel excel = Excel.decodeBytes(
      File('bin/script/reviews/source/$fileName.xlsx').readAsBytesSync(),
    );

    final String tableExcel = excel.tables.keys.first;

    _totalRow = excel.tables[tableExcel].rows.length;
    for (int i = 0; i < _totalRow; i++) {
      _currentRow = i;
      final List<Data> row = excel.tables[tableExcel].rows[i];
      _siteURL = row[1].value.trim();

      final Map companyInMap = companiesInMap.entries.firstWhere((e) {
        return e.value['siteURL'] == _siteURL;
      }, orElse: () => null)?.value;

      if (companyInMap != null) {
        for (int y = 4; y < row.length;) {
          final String displayName = row[y]?.value?.toString();
          y++;
          final double rating = row[y].value.toDouble();
          y++;
          final String message = row[y]?.value?.toString();
          y++;

          if (message != null && message.isNotEmpty && message != 'cell') {
            final String uid = Uid.getUid();

            _reviewsMap.addAll({
              uid: Map.from(
                Review(
                  uid: uid,
                  uidOwner: Uid.getUid(),
                  displayName: displayName,
                  message: message,
                  rating: rating == 0.0 ? 4.0 : rating,
                ).toMap(),
              )
            });

            _numOfReviews++;
            _totalRating += rating == 0.0 ? 4.0 : rating;
          }
        }

        if (_reviewsMap.isNotEmpty) {
          if (i + 1 < excel.tables[tableExcel].rows.length) {
            final List<Data> nextRow = excel.tables[tableExcel].rows[i + 1];

            if (nextRow[1].value != _siteURL) {
              _addToOutputMap(
                companyInMap: companyInMap,
                timeLogger: timeLogger,
              );
              _numOfReviews = 0;
              _totalRating = 0.0;
              _reviewsMap.clear();
            }
          }
        }
      }
    }

    await _addToOutputFile(
      countryCode: countryCode,
      timeLogger: timeLogger,
    );
  }

  void _addToOutputMap({
    Map companyInMap,
    TimeLogger timeLogger,
  }) {
    companyInMap['displayName'] = companyInMap['displayName'].trim();
    companyInMap['rating']['totalRating'] = _totalRating;
    companyInMap['rating']['numOfReviews'] = _numOfReviews;
    companyInMap['lastUpdate'] = _creationTime;

    _outputCompany.addAll({
      companyInMap['uid']: Map.from(companyInMap),
    });

    _outputReviews.addAll({
      companyInMap['uid']: Map.from({
        '__collections__': Map.from({
          'clients': Map.from(_reviewsMap),
        })
      }),
    });

    print(_reviewsMap);
    timeLogger.displayCurrent(
      _currentRow,
      _totalRow,
      message: 'TOTAL: <$_siteURL> ${companyInMap['uid']} '
          'REVIEWS: $_numOfReviews '
          'RATING: $_totalRating',
    );
  }

  Future<void> _addToOutputFile({
    String countryCode,
    TimeLogger timeLogger,
  }) async {
    if (_outputCompany.isNotEmpty) {
      final File importFileCompanies = File(
        'bin/script/reviews/output/import-company-$countryCode.json',
      );

      importFileCompanies.writeAsStringSync(
        jsonEncode({
          '__collections__': {
            'countries': {
              '$countryCode': {
                '__collections__': {
                  'companies': _outputCompany,
                }
              }
            },
          }
        }),
      );
    }

    if (_outputReviews.isNotEmpty) {
      final File importFileReviews = File(
        'bin/script/reviews/output/import-rev-$countryCode.json',
      );

      importFileReviews.writeAsStringSync(
        jsonEncode({
          '__collections__': {
            'reviews': _outputReviews,
          }
        }),
      );
    }

    timeLogger.displayTotal();
  }
}
