import 'dart:io';
import 'dart:convert';

class Backup {
  final File file;
  final Map outputMap = {};

  Backup({String fileName}) : file = File(fileName);

  Future<void> doBackup(int index, int period) async {
    if (index % period == 0) {
      await file.writeAsString(
        jsonEncode(outputMap),
      );
      print('*** BACKUP ***');
    }
  }

  Future<void> finalRecord() async {
    await file.writeAsString(
      jsonEncode(outputMap),
    );
  }
}
