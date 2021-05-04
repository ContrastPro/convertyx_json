import 'package:uuid/uuid.dart';

class Uid {
  Uid._();

  static String getUid() {
    return Uuid().v4();
  }
}

class Url {
  Url._();

  static String encodeFavicon({
    String url,
  }) {
    final String faviconUrl = 'http://www.google.com/s2/favicons?sz=32&domain=';
    return '$faviconUrl$url';
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

class Translit {
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

class Country {
  Country._();

  static const List<String> countryList = [
    "AU", // Australia
    "AT", // Austria
    "AZ", // Azerbaijan
    "AL", // Albania
    "DZ", // Algeria
    "AO", // Angola
    "AD", // Andorra
    "AG", // Antigua and Barbuda
    "AE", // Arab Emirates
    "AR", // Argentina
    "AM", // Armenia
    "AF", // Afghanistan
    "BS", // Bahamas
    "BD", // Bangladesh
    "BB", // Barbados
    "BH", // Bahrain
    "BY", // Belarus
    "BZ", // Belize
    "BE", // Belgium
    "BJ", // Benin
    "BG", // Bulgaria
    "BO", // Bolivia
    "BA", // Bosnia and Herzegovina
    "BW", // Botswana
    "BR", // Brazil
    "BN", // Brunei
    "BF", // Burkina Faso
    "BI", // Burundi
    "BT", // Bhutan
    "VU", // Vanuatu
    "GB", // United Kingdom
    "HU", // Hungary
    "VE", // Venezuela
    "TL", // East Timor
    "VN", // Vietnam
    "GA", // Gabon
    "HT", // Haiti
    "GY", // Guyana
    "GM", // Gambia
    "GH", // Ghana
    "GT", // Guatemala
    "GN", // Guinea
    "GW", // Guinea-Bissau
    "DE", // Germany
    "HN", // Honduras
    "GD", // Grenada
    "GR", // Greece
    "GE", // Georgia
    "DK", // Denmark
    "DJ", // Djibouti
    "DM", // Dominica
    "DO", // Dominican Republic
    "CD", // DR Congo
    "EG", // Egypt
    "ZM", // Zambia
    "ZW", // Zimbabwe
    "IL", // Israel
    "IN", // India
    "ID", // Indonesia
    "JO", // Jordan
    "IQ", // Iraq
    "IR", // Iran
    "IE", // Ireland
    "IS", // Iceland
    "ES", // Spain
    "IT", // Italy
    "YE", // Yemen
    "CV", // Cape Verde
    "KZ", // Kazakhstan
    "KH", // Cambodia
    "CM", // Cameroon
    "CA", // Canada
    "QA", // Qatar
    "KE", // Kenya
    "CY", // Cyprus
    "KG", // Kyrgyzstan
    "KI", // Kiribati
    "CN", // China
    "CO", // Colombia
    "KM", // Comoros
    "CG", // Republic of the Congo
    "CR", // Costa Rica
    "CI", // Ivory Coast
    "CU", // Cuba
    "KW", // Kuwait
    "LA", // Laos
    "LV", // Latvia
    "LS", // Lesotho
    "LR", // Liberia
    "LB", // Lebanon
    "LY", // Libya
    "LT", // Lithuania
    "LI", // Liechtenstein
    "LU", // Luxembourg
    "MU", // Mauritius
    "MR", // Mauritania
    "MG", // Madagascar
    "MK", // Macedonia
    "MW", // Malawi
    "MY", // Malaysia
    "ML", // Mali
    "MV", // Maldives
    "MT", // Malta
    "MA", // Morocco
    "MH", // Marshall Islands
    "MX", // Mexico
    "MZ", // Mozambique
    "MD", // Moldova
    "MC", // Monaco
    "MN", // Mongolia
    "MM", // Myanmar
    "NA", // Namibia
    "NR", // Nauru
    "NP", // Nepal
    "NE", // Niger
    "NG", // Nigeria
    "NL", // Netherlands
    "NI", // Nicaragua
    "NZ", // New Zealand
    "NO", // Norway
    "OM", // Oman
    "PK", // Pakistan
    "PW", // Palau
    "PA", // Panama
    "PG", // Papua New Guinea
    "PY", // Paraguay
    "PE", // Peru
    "PL", // Poland
    "PT", // Portugal
    "RU", // Russia
    "RW", // Rwanda
    "RO", // Romania
    "SV", // Salvador
    "WS", // Samoa
    "SM", // San Marino
    "ST", // Sao Tome and Principe
    "SA", // Saudi Arabia
    "SZ", // Swaziland
    "KP", // North Korea
    "SC", // Seychelles
    "SN", // Senegal
    "VC", // Saint Vincent and the Grenadines
    "KN", // Saint Kitts and Nevis
    "LC", // Saint Lucia
    "RS", // Serbia
    "SG", // Singapore
    "SY", // Syria
    "SK", // Slovakia
    "SI", // Slovenia
    "US", // United States
    "SB", // Solomon Islands
    "SO", // Somalia
    "SD", // Sudan
    "SR", // Suriname
    "SL", // Sierra Leone
    "TJ", // Tajikistan
    "TH", // Thailand
    "TZ", // Tanzania
    "TG", // Togo
    "TO", // Tonga
    "TT", // Trinidad and Tobago
    "TV", // Tuvalu
    "TN", // Tunisia
    "TM", // Turkmenistan
    "TR", // Turkey
    "UG", // Uganda
    "UZ", // Uzbekistan
    "UA", // Ukraine
    "UY", // Uruguay
    "FM", // Micronesia
    "FJ", // Fiji
    "PH", // Philippines
    "FI", // Finland
    "FR", // France
    "HR", // Croatia
    "CF", // Central African Republic
    "TD", // Chad
    "ME", // Montenegro
    "CZ", // Czech Republic
    "CL", // Chile
    "CH", // Switzerland
    "SE", // Sweden
    "LK", // Sri Lanka
    "EC", // Ecuador
    "GQ", // Equatorial Guinea
    "ER", // Eritrea
    "EE", // Estonia
    "ET", // Ethiopia
    "ZA", // South Africa
    "SS", // South Sudan
    "KR", // South Korea
    "JM", // Jamaica
    "JP", // Japan
  ];
}
