import 'dart:io';
import 'dart:convert';

import 'package:excel/excel.dart';

import 'models/review.dart';
import '../companies/encode/encode_classes.dart';

void main() async {
  await _create();
}

Future<void> _create() async {
  final File file = File('bin/reviews/source/UA.xlsx');
  final bytes = file.readAsBytesSync();
  final Excel excel = Excel.decodeBytes(bytes);
  final String table = excel.tables.keys.first;

  final Map outputCompanyMap = {};

  final Map outputReviewsMap = {};

  // Start from second row
  for (int rowIn = 1; rowIn < excel.tables[table].rows.length; rowIn++) {
    // Set current row
    final List<Data> row = excel.tables[table].rows[rowIn];
    final Map reviewsMap = {};

    // 1) Создаём объект компанию (если существует в json) получая данные
    // из неё иначе просто переходим к следующему объекту
    final Data company = row[1];
    print('*** COMPANY: $company ***');

    final String compUid = '7e6300c4-13c6-4012-9df7-a22839a6e6c1';

    // 2) Создаём объект Review
    for (int cellIn = 4; cellIn < row.length;) {
      final String displayName = row[cellIn]?.value;
      cellIn++;
      final double rating = row[cellIn]?.value?.toDouble();
      cellIn++;
      final String message = row[cellIn]?.value;
      cellIn++;

      // Если по каким-то параметрам он не подходит не добавляем его в
      // outputReviewsMap либо заменяем какие-то данные и добавляем в outputReviewsMap:
      //
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
      }
    }

    if (reviewsMap.isNotEmpty) {
      outputReviewsMap[compUid] = {
        '__collections__': {
          'clients': reviewsMap,
        }
      };
    }
  }

  // Преобразуем outputReviewsMap и outputReviewsMap в вид в котором будем
  // экспортировать в файл json для отправки в Firebase

  // Write to file
  final File importFile = File('bin/reviews/output/reviews-test.json');
  importFile.writeAsStringSync(
    jsonEncode({
      '__collections__': {
        'reviews': outputReviewsMap,
      }
    }),
  );

  /*'countries': {
          'UA': {
            '__collections__': {
              'companies': outputCompanyMap,
            }
          }
        },*/
}
