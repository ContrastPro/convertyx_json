import 'classes/single_excel_file_reviews_import.dart';
import 'classes/single_page_excel_file_reviews_import.dart';

// Символ  

void main() async {
  // Convert from first Excel page
  final SinglePageExcelFileReviewsImport singlePageExcelFileReviewsImport =
      SinglePageExcelFileReviewsImport();

  await singlePageExcelFileReviewsImport.convertReviews(
    country: 'Черногория',
    fileName: 'База отзывов Черногория',
  );

  // Convert from Excel pages
  /*final SingleExcelFileReviewsImport singleExcelFileReviewsImport =
      SingleExcelFileReviewsImport();

  await singleExcelFileReviewsImport.convertReviews(
    fileName: 'База подготовленная отзывы',
  );*/
}
