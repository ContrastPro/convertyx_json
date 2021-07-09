import 'dart:io';
import 'dart:convert';

import 'package:excel/excel.dart';

import '../companies/encode/encode_classes.dart';

void main() async {
  print('\n\n *** START *** \n\n');
  await _convertReviews(country: 'UA');
}

String _siteURL;
int _numOfReviews = 0;
double _totalRating = 0.0;
final Map _reviewsMap = {};

final Map _outputCompany = {};
final Map _outputReviews = {};

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
    _siteURL = row[1].value.trim();

    final Map companyInMap = companiesInMap.entries.firstWhere((e) {
      return e.value['siteURL'] == _siteURL;
    }, orElse: () => null)?.value;

    if (companyInMap != null) {
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
        if (i + 1 < excel.tables[tableExcel].rows.length) {
          final List<Data> nextRow = excel.tables[tableExcel].rows[i + 1];

          if (nextRow[1].value != _siteURL) {
            _addToOutputMap(companyInMap: companyInMap);
            _numOfReviews = 0;
            _totalRating = 0.0;
            _reviewsMap.clear();
          }
        }
      }
    }
  }

  await _addToOutputFile();
}

void _addToOutputMap({Map companyInMap}) {
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
    'RATING: $_totalRating\n',
  );
}

Future<void> _addToOutputFile() async {
  print('**********************************************************************'
      '**********************************************************************');

  final File importFile = File(
    'bin/reviews/output/import-reviews-UA.json',
  );

  importFile.writeAsStringSync(
    jsonEncode({
      '__collections__': {
        'countries': {
          'UA': {
            '__collections__': {
              'companies': _outputCompany,
            }
          }
        },
        'reviews': _outputReviews,
      }
    }),
  );
}
