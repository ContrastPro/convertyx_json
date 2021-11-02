import 'classes/single_excel_file_company_import.dart';
import 'classes/text_files_company_import.dart';

// Символ

void main() async {
  /*final SingleExcelFileCompanyImport _singleExcelFile =
      SingleExcelFileCompanyImport();

  // Импорт всех компании из одного файла для каждой страны
  await _singleExcelFile.importFromSingleFile();*/

  TextFilesCompanyImport textFilesCompanyImport = TextFilesCompanyImport();

  // Импорт компаний для 195 стран
  //await textFilesCompanyImport.getForEachCountry();

  // Импорт компании для 1 конкретной страны
  await textFilesCompanyImport.importForSingleCountry(
    country: 'Черногория',
    saveImport: true,
  );
}
