import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';

import '../companies/encode/encode_classes.dart';

void main() async {
  print('\n\n *** START *** \n\n');
  await _convertReviews(country: 'UA');
}

String _siteURL;
int _numOfReviews = 0;
double _totalRating = 0.0;
Map _reviewsMap = {};

Map _outputCompanies = {};
Map _outputReviews = {};

Future<void> _convertReviews({
  String country,
}) async {
  final Map companiesInMap = jsonDecode(
    await File(
      'bin/reviews/source/import-$country.json',
    ).readAsString(),
  )['__collections__']['countries']['$country']['__collections__']['companies'];

  final Excel excel = Excel.decodeBytes(
    File('bin/reviews/source/UA.xlsx').readAsBytesSync(),
  );

  final String tableExcel = excel.tables.keys.first;

  for (int i = 1; i < excel.tables[tableExcel].rows.length; i++) {
    final List<Data> row = excel.tables[tableExcel].rows[i];
    _siteURL = row[1].value;

    for (int y = 4; y < row.length;) {
      final String displayName = row[y]?.value;
      y++;
      final double rating = row[y].value.toDouble();
      y++;
      final String message = row[y]?.value;
      y++;

      if (message != null) {
        final String uid = Uid.getUid();

        _reviewsMap[uid] = {
          'displayName': displayName,
          'rating': rating,
          'message': message,
        };

        _numOfReviews++;
        _totalRating += rating;
      }
    }

    if (_reviewsMap.isNotEmpty) {
      final Map companyInMap = companiesInMap.entries.firstWhere((e) {
        return e.value['siteURL'] == row[1].value.trim();
      }, orElse: () => null)?.value;

      if (i + 1 < excel.tables[tableExcel].rows.length) {
        final List<Data> nextRow = excel.tables[tableExcel].rows[i + 1];

        if (nextRow[1].value != _siteURL) {
          await _addToOutputMap(compUid: companyInMap['uid']);
          _numOfReviews = 0;
          _totalRating = 0.0;
          _reviewsMap.clear();
        }
      } else {
        await _addToOutputFile();
      }
    }
  }
}

Future<void> _addToOutputMap({String compUid}) async {
  _outputReviews[compUid] = {
    '__collections__': {
      'clients': _reviewsMap,
    }
  };

  print(_reviewsMap);
  print(
    '\nTOTAL: <$_siteURL> $compUid '
    'REVIEWS: $_numOfReviews '
    'RATING: $_totalRating\n',
  );
}

Future<void> _addToOutputFile() async {
  // Write to file
  final File importFile = File(
    'bin/reviews/output/import-reviews-UA.json',
  );

  importFile.writeAsStringSync(
    jsonEncode({
      '__collections__': {
        /*'countries': {
          '$country': {
            '__collections__': {
              'companies': outputCompanyMap,
            }
          }
        },*/
        'reviews': _outputReviews,
      }
    }),
  );

  print(_reviewsMap);
  print(
    '\nLAST TOTAL: <$_siteURL> '
    'REVIEWS: $_numOfReviews '
    'RATING: $_totalRating\n',
  );
}
