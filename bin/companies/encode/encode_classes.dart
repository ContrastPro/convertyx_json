import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

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
    final Uri httpUri = Uri.http('$url', '/');
    final Uri httpsUri = Uri.https('$url', '/');
    // HTTP REQUEST
    try {
      http.Response httpResponse = await http.get(httpUri);
      if (httpResponse.statusCode == 200) {
        return 'http://$url';
      }
    } catch (_) {}

    // HTTPS REQUEST
    try {
      http.Response httpsResponse = await http.get(httpsUri);
      if (httpsResponse.statusCode == 200) {
        return 'https://$url';
      }
    } catch (_) {}

    final Uri httpUriWWW = Uri.http('www.$url', '/');
    final Uri httpsUriWWW = Uri.https('www.$url', '/');

    // HTTP REQUEST WITH WWW.
    try {
      http.Response httpResponse = await http.get(httpUriWWW);
      if (httpResponse.statusCode == 200) {
        return 'http://www.$url';
      }
    } catch (_) {}

    // HTTPS REQUEST WITH WWW.
    try {
      http.Response httpsResponse = await http.get(httpsUriWWW);
      if (httpsResponse.statusCode == 200) {
        return 'https://www.$url';
      }
    } catch (_) {}

    return 'http://$url';
  }

  static String encodeFavicon({
    String url,
  }) {
    final List<String> splitUrl = url.split('://');
    final String faviconUrl = 'http://www.google.com/s2/favicons?sz=16px&domain=';
    return '$faviconUrl${splitUrl[1]}';
  }
}

class Category {
  Category._();

  static String encode({
    Map assetsCategory,
    String value,
  }) {
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

class TranslitValidator {
  static String encode({
    Map assetsTranslit,
    String text,
  }) {
    List<String> translit = [];
    List<String> sourceSymbols = [];

    sourceSymbols = text.split('');
    sourceSymbols.forEach((String element) {
      translit.add(assetsTranslit.containsKey(element)
          ? assetsTranslit[element]
          : element);
    });

    return translit.join();
  }
}
