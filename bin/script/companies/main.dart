import 'classes/single_excel_file_company_import.dart';
import 'classes/text_files_company_import.dart';

void main() async {
  // Импорт всех компании из одного файла для каждой страны
  final SingleExcelFileCompanyImport _singleExcelFile =
      SingleExcelFileCompanyImport();
  await _singleExcelFile.importFromSingleFile();

  // Импорт компаний для 195 стран
  TextFilesCompanyImport textFilesCompanyImport = TextFilesCompanyImport();
  await textFilesCompanyImport.getForEachCountry();

  // Импорт компании для 1 конкретной страны
  await textFilesCompanyImport.importForSingleCountry(
    country: 'Босния и Герцеговина',
    saveImport: true,
  );
}
