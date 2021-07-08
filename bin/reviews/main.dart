import 'dart:io';
import 'dart:convert';

import 'package:excel/excel.dart';

import 'models/review.dart';
import '../companies/encode/encode_classes.dart';

void main() async {
  await _create(country: 'UA');
}

Future<void> _create({
  String country,
}) async {
  final File fileExcel = File('bin/reviews/source/UA.xlsx');
  final Excel excel = Excel.decodeBytes(
    fileExcel.readAsBytesSync(),
  );
  final String tableExcel = excel.tables.keys.first;

  final Map companiesFile = jsonDecode(await File(
    'bin/reviews/source/import-$country.json',
  ).readAsString())['__collections__']['countries']['$country']
      ['__collections__']['companies'];

  final Map outputCompanyMap = {};

  final Map outputReviewsMap = {};

  // Начинаем обход со второй строки
  for (int rowIn = 1; rowIn < excel.tables[tableExcel].rows.length; rowIn++) {
    // Устанавливаем текущую строку
    final List<Data> row = excel.tables[tableExcel].rows[rowIn];

    final Map companyFile = companiesFile.entries.firstWhere((e) {
      return e.value['siteURL'] == row[1].value.trim();
    }, orElse: () => null)?.value;

    if (companyFile != null) {
      int numOfReviews = 0;

      double totalRating = 0;

      final Map reviewsMap = {};

      // Создаём объект Review
      for (int cellIn = 4; cellIn < row.length;) {
        final String displayName = row[cellIn]?.value;
        cellIn++;
        final double rating = row[cellIn]?.value?.toDouble();
        cellIn++;
        final String message = row[cellIn]?.value;
        cellIn++;

        // 1. Отзывы с оценкой 0, но с текстом и автором - необходимо импортировать с оценкой 4
        // 2. Отзывы без автора, но с текстом и оценкой - необходимо импортировать с указанием автора Anonymous
        // 3. Отзывы без текста, но с автором и оценкой - не импортируем

        if (message != null) {
          final String uid = Uid.getUid();

          reviewsMap[uid] = Review(
            uid: uid,
            uidOwner: Uid.getUid(),
            displayName: displayName,
            message: message,
            rating: rating == 0.0 ? 4.0 : rating,
          ).toMap();

          numOfReviews++;
          totalRating = totalRating + rating;
        }
      }

      if (reviewsMap.isNotEmpty) {
        companyFile['displayName'] = companyFile['displayName'].trim();
        companyFile['rating']['totalRating'] = totalRating;
        companyFile['rating']['numOfReviews'] = numOfReviews;

        outputCompanyMap.putIfAbsent(
          companyFile['uid'],
          () => companyFile,
        );

        outputReviewsMap.putIfAbsent(
          companyFile['uid'],
          () => {
            '__collections__': {
              'clients': reviewsMap,
            }
          },
        );
      }
    }
  }

  // Write to file
  final File importFile = File(
    'bin/reviews/output/import-reviews-$country.json',
  );

  importFile.writeAsStringSync(
    jsonEncode({
      '__collections__': {
        'countries': {
          '$country': {
            '__collections__': {
              'companies': outputCompanyMap,
            }
          }
        },
        'reviews': outputReviewsMap,
      }
    }),
  );
}
