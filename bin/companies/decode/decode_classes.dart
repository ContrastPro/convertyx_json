import 'dart:convert';
import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

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

class Uid {
  Uid._();

  static String getUid() {
    return Uuid().v4();
  }
}

class Url {
  Url._();

  static Future<String> encode({
    String url,
  }) async {
    final Uri httpUri = Uri.http("$url", "/");
    final Uri httpsUri = Uri.https("$url", "/");
    // HTTP REQUEST
    try {
      http.Response httpResponse = await http.get(httpUri);
      if (httpResponse.statusCode == 200) {
        return "http://$url";
      }
    } catch (_) {}

    // HTTPS REQUEST
    try {
      http.Response httpsResponse = await http.get(httpsUri);
      if (httpsResponse.statusCode == 200) {
        return "https://$url";
      }
    } catch (_) {}

    // HTTP REQUEST WITH WWW.
    try {
      http.Response httpResponse = await http.get(httpUri);
      if (httpResponse.statusCode == 200) {
        return "http://www.$url";
      }
    } catch (_) {}

    // HTTPS REQUEST WITH WWW.
    try {
      http.Response httpsResponse = await http.get(httpsUri);
      if (httpsResponse.statusCode == 200) {
        return "https://www.$url";
      }
    } catch (_) {}

    return "http://$url";
  }

  static String encodeFavicon({
    String url,
  }) {
    return "$url/favicon.ico";
  }
}

class Category {
  Category._();

  static String encode({Map assetsCategory, String value}) {
    return assetsCategory.keys.firstWhere((e) {
      return assetsCategory[e] == value;
    }, orElse: () {
      return 'leisure';
    });
  }
}

class Search {
  Search._();

  static List<String> encodeKey({
    String searchQuery,
  }) {
    String key = "";
    String query = searchQuery.trim().toLowerCase();
    List<String> searchKey = [];
    for (int i = 0; i < query.length; i++) {
      key = key + query[i];
      searchKey.add(key);
    }
    return searchKey;
  }
}
