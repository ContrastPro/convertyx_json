import 'dart:io';
import 'dart:convert';

import 'package:excel/excel.dart';

import 'models/review.dart';
import 'encode/encode_classes.dart';
import '../companies/encode/encode_classes.dart';

void main() async {
  await _convertReviews(
    country: 'BY',
    fileName: 'RU+BE отзывы',
  );
}

int _currentRow;
int _totalRow;

String _siteURL;
int _numOfReviews = 0;
double _totalRating = 0.0;
final Map _reviewsMap = {};

final Map _outputCompany = {};
final Map _outputReviews = {};

Future<void> _convertReviews({
  String country,
  String fileName,
}) async {
  final Logger logger = Logger();
  print('\n\n *** START *** \n\n');

  final Map companiesInMap = jsonDecode(
    await File(
      'bin/reviews/source/import-$country.json',
    ).readAsString(),
  )['__collections__']['countries']['$country']['__collections__']['companies'];

  final Excel excel = Excel.decodeBytes(
    File('bin/reviews/source/$fileName.xlsx').readAsBytesSync(),
  );

  final String tableExcel = excel.tables.keys.first;

  _totalRow = excel.tables[tableExcel].rows.length;
  for (int i = 1; i < _totalRow; i++) {
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

        if (message != null && message.isNotEmpty) {
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
              logger: logger,
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
    country: country,
    logger: logger,
  );
}

void _addToOutputMap({
  Map companyInMap,
  Logger logger,
}) {
  companyInMap['displayName'] = companyInMap['displayName'].trim();
  companyInMap['rating']['totalRating'] = _totalRating;
  companyInMap['rating']['numOfReviews'] = _numOfReviews;

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
  print(
    '\nTOTAL: <$_siteURL> ${companyInMap['uid']} '
    'REVIEWS: $_numOfReviews '
    'RATING: $_totalRating',
  );
  logger.display(_currentRow, _totalRow);
}

Future<void> _addToOutputFile({
  String country,
  Logger logger,
}) async {
  final File importFileCompanies = File(
    'bin/reviews/output/import-companies-$country.json',
  );

  final File importFileReviews = File(
    'bin/reviews/output/import-reviews-$country.json',
  );

  importFileCompanies.writeAsStringSync(
    jsonEncode({
      '__collections__': {
        'countries': {
          '$country': {
            '__collections__': {
              'companies': _outputCompany,
            }
          }
        },
      }
    }),
  );

  importFileReviews.writeAsStringSync(
    jsonEncode({
      '__collections__': {
        'reviews': _outputReviews,
      }
    }),
  );

  logger.displayTotal();
}
