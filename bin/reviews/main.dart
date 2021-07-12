import 'dart:io';
import 'dart:convert';

import 'package:excel/excel.dart';

import 'models/review.dart';
import 'encode/encode_classes.dart';
import '../companies/encode/encode_classes.dart';

void main() async {
  for (int i = 5; i < 11; i++) {
    await _convertReviews(
      suffix: '$i',
      country: 'US',
      fileName: '3 партия',
    );
  }
}

int _currentRow;
int _totalRow;

String _siteURL;
int _numOfReviews = 0;
double _totalRating = 0.0;
final Map _reviewsMap = {};

final Map _outputCompany = {};
final Map _outputReviews = {};

//'Timestamp(seconds=1625830840, nanoseconds=853757000)';
const Map _creationTime = {
  '__datatype__': 'timestamp',
  'value': {
    '_seconds': 1625830840,
    '_nanoseconds': 853757000,
  }
};

Future<void> _convertReviews({
  String suffix,
  String country,
  String fileName,
}) async {
  final TimeLogger timeLogger = TimeLogger();
  print('\n\n *** START *** \n\n');

  final Map companiesInMap = jsonDecode(
    await File(
      suffix != null
          ? 'bin/reviews/source/import-${country}_$suffix.json'
          : 'bin/reviews/source/import-$country.json',
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
    suffix: suffix,
    country: country,
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
  String suffix,
  String country,
  TimeLogger timeLogger,
}) async {
  // TODO:
  final File importFileCompanies = File(
    suffix != null
        ? 'bin/reviews/output/import-companies-${country}_$suffix.json'
        : 'bin/reviews/output/import-companies-$country.json',
  );

  // TODO:
  final File importFileReviews = File(
    suffix != null
        ? 'bin/reviews/output/import-reviews-${country}_$suffix.json'
        : 'bin/reviews/output/import-reviews-$country.json',
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

  timeLogger.displayTotal();
}
