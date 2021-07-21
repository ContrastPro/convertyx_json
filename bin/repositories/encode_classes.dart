import 'package:uuid/uuid.dart';

class Uid {
  const Uid._();

  static String getUid() {
    return Uuid().v1();
  }
}

class Url {
  const Url._();

  static String encodeFavicon({
    String url,
  }) {
    const String faviconUrl = 'http://www.google.com/s2/favicons?sz=32&domain=';
    return '$faviconUrl$url';
  }
}

class Category {
  const Category._();

  static String encode({
    Map assetsCategory,
    String value,
  }) {
    return assetsCategory.keys.firstWhere((e) {
      return assetsCategory[e] == value;
    }, orElse: () => 'other');
  }
}

class Search {
  const Search._();

  static List<String> encodeKey({
    String searchQuery,
  }) {
    String key = '';
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
  const Translit._();

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
  const Country._();

  static const Map<String, String> countryMap = {
    'AU': 'Австралия', // Australia
    'AT': 'Австрия', // Austria
    'AZ': 'Азербайджан', // Azerbaijan
    'AL': 'Албания', // Albania
    'DZ': 'Алжир', // Algeria
    'AO': 'Ангола', // Angola
    'AD': 'Андорра', // Andorra
    'AG': 'Антигуа и Барбуда', // Antigua and Barbuda
    'AE': 'Арабские Эмираты', // Arab Emirates
    'AR': 'Аргентина', // Argentina
    'AM': 'Армения', // Armenia
    'AF': 'Афганистан', // Afghanistan
    'BS': 'Багамы', // Bahamas
    'BD': 'Бангладеш', // Bangladesh
    'BB': 'Барбадос', // Barbados
    'BH': 'Бахрейн', // Bahrain
    'BY': 'Беларусь', // Belarus
    'BZ': 'Белиз', // Belize
    'BE': 'Бельгия', // Belgium
    'BJ': 'Бенин', // Benin
    'BG': 'Болгария', // Bulgaria
    'BO': 'Боливия', // Bolivia
    'BA': 'Босния и Герцеговина', // Bosnia and Herzegovina
    'BW': 'Ботсвана', // Botswana
    'BR': 'Бразилия', // Brazil
    'BN': 'Бруней', // Brunei
    'BF': 'Буркина-Фасо', // Burkina Faso
    'BI': 'Бурунди', // Burundi
    'BT': 'Бутан', // Bhutan
    'VU': 'Вануату', // Vanuatu
    'GB': 'Великобритания', // United Kingdom
    'HU': 'Венгрия', // Hungary
    'VE': 'Венесуэла', // Venezuela
    'VG': 'Виргинские острова', // VIRGIN ISLANDS, BRITISH
    'TL': 'Тимор-Лесте', // East Timor
    'VN': 'Вьетнам', // Vietnam
    'GA': 'Габон', // Gabon
    'HT': 'Гаити', // Haiti
    'GY': 'Гайана', // Guyana
    'GM': 'Гамбия', // Gambia
    'GH': 'Гана', // Ghana
    'GT': 'Гватемала', // Guatemala
    'GN': 'Гвинея', // Guinea
    'GW': 'Гвинея-Бисау', // Guinea-Bissau
    'DE': 'Германия', // Germany
    'HN': 'Гондурас', // Honduras
    'HK': 'Гонконг', // Hong Kong
    'GD': 'Гренада', // Grenada
    'GR': 'Греция', // Greece
    'GE': 'Грузия', // Georgia
    'DK': 'Дания', // Denmark
    'DJ': 'Джибути', // Djibouti
    'DM': 'Доминика', // Dominica
    'DO': 'Доминиканская Республика', // Dominican Republic
    'CD': 'Демократическая Республика Конго', // DR Congo
    'EG': 'Египет', // Egypt
    'ZM': 'Замбия', // Zambia
    'ZW': 'Зимбабве', // Zimbabwe
    'YE': 'Йемен', // Yemen
    'IL': 'Израиль', // Israel
    'IN': 'Индия', // India
    'ID': 'Индонезия', // Indonesia
    'JO': 'Иордания', // Jordan
    'IQ': 'Ирак', // Iraq
    'IR': 'Иран', // Iran
    'IE': 'Ирландия', // Ireland
    'IS': 'Исландия', // Iceland
    'ES': 'Испания', // Spain
    'IT': 'Италия', // Italy
    'CV': 'Кабо-Верде', // Cape Verde
    'KZ': 'Казахстан', // Kazakhstan
    'KH': 'Камбоджа', // Cambodia
    'CM': 'Камерун', // Cameroon
    'CA': 'Канада', // Canada
    'QA': 'Катар', // Qatar
    'KE': 'Кения', // Kenya
    'CY': 'Кипр', // Cyprus
    'KG': 'Киргизия', // Kyrgyzstan
    'KI': 'Кирибати', // Kiribati
    'CN': 'Китай', // China
    'CO': 'Колумбия', // Colombia
    'KM': 'Коморы', // Comoros
    'CG': 'Конго', // Republic of the Congo
    'CR': 'Коста-Рика', // Costa Rica
    'CI': 'Кот дИвуар', // Ivory Coast
    'CU': 'Куба', // Cuba
    'KW': 'Кувейт', // Kuwait
    'LA': 'Лаос', // Laos
    'LV': 'Латвия', // Latvia
    'LS': 'Лесото', // Lesotho
    'LR': 'Либерия', // Liberia
    'LB': 'Ливан', // Lebanon
    'LY': 'Ливия', // Libya
    'LT': 'Литва', // Lithuania
    'LI': 'Лихтенштейн', // Liechtenstein
    'LU': 'Люксембург', // Luxembourg
    'MU': 'Маврикий', // Mauritius
    'MR': 'Мавритания', // Mauritania
    'MG': 'Мадагаскар', // Madagascar
    'MK': 'Македония', // Macedonia
    'MW': 'Малави', // Malawi
    'MY': 'Малайзия', // Malaysia
    'ML': 'Мали', // Mali
    'MV': 'Мальдивы', // Maldives
    'MT': 'Мальта', // Malta
    'MA': 'Марокко', // Morocco
    'MH': 'Маршалловы острова', // Marshall Islands
    'MX': 'Мексика', // Mexico
    'FM': 'Микронезия', // Micronesia
    'MZ': 'Мозамбик', // Mozambique
    'MD': 'Молдова', // Moldova
    'MC': 'Монако', // Monaco
    'MN': 'Монголия', // Mongolia
    'MM': 'Мьянма', // Myanmar
    'NA': 'Намибия', // Namibia
    'NR': 'Науру', // Nauru
    'NP': 'Непал', // Nepal
    'NE': 'Нигер', // Niger
    'NG': 'Нигерия', // Nigeria
    'NL': 'Нидерланды', // Netherlands
    'NI': 'Никарагуа', // Nicaragua
    'NZ': 'Новая Зеландия', // New Zealand
    'NO': 'Норвегия', // Norway
    'OM': 'Оман', // Oman
    'PK': 'Пакистан', // Pakistan
    'PW': 'Палау', // Palau
    'PA': 'Панама', // Panama
    'PG': 'Папуа-Новая Гвинея', // Papua New Guinea
    'PY': 'Парагвай', // Paraguay
    'PE': 'Перу', // Peru
    'PL': 'Польша', // Poland
    'PT': 'Португалия', // Portugal
    'PR': 'Пуэрто-Рико', // Puerto Rico
    'RU': 'Россия', // Russia
    'RW': 'Руанда', // Rwanda
    'RO': 'Румыния', // Romania
    'SV': 'Сальвадор', // Salvador
    'WS': 'Самоа', // Samoa
    'SM': 'Сан-Марино', // San Marino
    'ST': 'Сан-Томе и Принсипи', // Sao Tome and Principe
    'SA': 'Саудовская Аравия', // Saudi Arabia
    'SZ': 'Свазиленд', // Swaziland
    'KP': 'Корея', // North Korea
    'SC': 'Сейшелы', // Seychelles
    'SN': 'Сенегал', // Senegal
    'VC': 'Сент-Винсент и Гренадины', // Saint Vincent and the Grenadines
    'KN': 'Сент-Китс и Невис', // Saint Kitts and Nevis
    'LC': 'Сент-Люсия', // Saint Lucia
    'RS': 'Сербия', // Serbia
    'SG': 'Сингапур', // Singapore
    'SY': 'Сирия', // Syria
    'SK': 'Словакия', // Slovakia
    'SI': 'Словения', // Slovenia
    'SD': 'Судан', // Sudan
    'US': 'США', // United States
    'TW': 'Тайвань', // Taiwan
    'SB': 'Соломоновы острова', // Solomon Islands
    'SO': 'Сомали', // Somalia
    'SR': 'Суринам', // Suriname
    'SL': 'Сьерра-Леоне', // Sierra Leone
    'TJ': 'Таджикистан', // Tajikistan
    'TH': 'Таиланд', // Thailand
    'TZ': 'Танзания', // Tanzania
    'TG': 'Того', // Togo
    'TO': 'Тонга', // Tonga
    'TT': 'Тринидад и Тобаго', // Trinidad and Tobago
    'TV': 'Тувалу', // Tuvalu
    'TN': 'Тунис', // Tunisia
    'TM': 'Туркмения', // Turkmenistan
    'TR': 'Турция', // Turkey
    'UG': 'Уганда', // Uganda
    'UZ': 'Узбекистан', // Uzbekistan
    'UA': 'Украина', // Ukraine
    'UY': 'Уругвай', // Uruguay
    'FJ': 'Фиджи', // Fiji
    'PH': 'Филиппины', // Philippines
    'FI': 'Финляндия', // Finland
    'FR': 'Франция', // France
    'HR': 'Хорватия', // Croatia
    'CF': 'Центрально-Африканская Республика', // Central African Republic
    'TD': 'Чад', // Chad
    'ME': 'Черногория', // Montenegro
    'CZ': 'Чехия', // Czech Republic
    'CL': 'Чили', // Chile
    'CH': 'Швейцария', // Switzerland
    'SE': 'Швеция', // Sweden
    'LK': 'Шри-Ланка', // Sri Lanka
    'EC': 'Эквадор', // Ecuador
    'GQ': 'Экваториальная Гвинея', // Equatorial Guinea
    'ER': 'Государство Эритрея', // Eritrea
    'EE': 'Эстония', // Estonia
    'ET': 'Эфиопия', // Ethiopia
    'ZA': 'ЮАР', // South Africa
    'SS': 'Южный Судан', // South Sudan
    'KR': 'Южная Корея', // South Korea
    'JM': 'Ямайка', // Jamaica
    'JP': 'Япония', // Japan
  };
}

class InterfaceTranslate {
  InterfaceTranslate._();

  static const Map<String, String> fields = {
    'favorites': '',
    'recent': '',
    'review': '',
    'company': '',
    'clients': '',
    'employees': '',
    'discount': '',
    'discounts': '',
    'job': '',
    'rating': '',
    'support': ''
  };
}

class CategoryTranslate {
  CategoryTranslate._();

  static const Map<String, String> fields = {
    'airlines': '',
    'auto_shops': '',
    'car_wash': '',
    'car_dealerships': '',
    'car_service': '',
    'car_parks': '',
    'driving_schools': '',
    'real_estate_agency': '',
    'gambling': '',
    'accessories': '',
    'mountaineering': '',
    'pharmacy': '',
    'car_rent': '',
    'bicycle_rent': '',
    'rent_of_dresses': '',
    'rent_of_goods': '',
    'atelier_sewing': '',
    'airports': '',
    'banks': '',
    'bars_pubs': '',
    'business': '',
    'charity': '',
    'drilling_of_the_wells': '',
    'accounting_services': '',
    'web_studios': '',
    'bicycles_motorcycles': '',
    'veterinary_clinics': '',
    'visa_centers': '',
    'galleries_museums': '',
    'hotels_hotels': '',
    'cargo_transportation': '',
    'doors': '',
    'kindergartens': '',
    'childrens_products': '',
    'diagnostics': '',
    'interior_design': '',
    'notice_boards': '',
    'water_delivery': '',
    'food_delivery': '',
    'goods_delivery': '',
    'leisure': '',
    'factories_production': '',
    'pet_supplies': '',
    'games': '',
    'investments': '',
    'foreign_languages': '',
    'internet_directories': '',
    'online_stores': '',
    'internet_service_providers': '',
    'art': '',
    'catering': '',
    'cinemas_theaters': '',
    'bookstores': '',
    'call_centers': '',
    'consulting': '',
    'cosmetics_perfumery': '',
    'cosmetology': '',
    'beauty_health': '',
    'loans': '',
    'cryptocurrencies': '',
    'resorts': '',
    'laboratories': '',
    'pawnshops': '',
    'watch_shops': '',
    'furniture': '',
    'medical_supplies': '',
    'music': '',
    'science_research': '',
    'the_property': '',
    'currency_exchange': '',
    'public_organizations': '',
    'clothes_shoes': '',
    'windows': '',
    'telecom_operators': '',
    'optics': '',
    'organization_of_events': '',
    'ophthalmology': '',
    'security': '',
    'boarding_houses': '',
    'passenger_transportation': '',
    'printing_typography': '',
    'pizzerias': '',
    'plastic_surgery': '',
    'payment_systems': '',
    'software': '',
    'grocery_stores': '',
    'food': '',
    'industry_equipment': '',
    'radio': '',
    'entertainment': '',
    'rehabilitation_centers': '',
    'advertising_marketing': '',
    'reproductive_medicine': '',
    'restaurants_cafes': '',
    'fishing_hunting': '',
    'websites': '',
    'beauty_salons': '',
    'sanatoriums': '',
    'plumbing': '',
    'wedding_salons': '',
    'agriculture': '',
    'service_centers': '',
    'certification': '',
    'discounts_coupons': '',
    'warehouses_storage': '',
    'media_news': '',
    'sports_clubs': '',
    'dentistry': '',
    'insurance': '',
    'construction_materials': '',
    'construction_renovation': '',
    'sushi': '',
    'taxi': '',
    'tattoo_parlors': '',
    'texts_translations': '',
    'telecommunications_cinema': '',
    'technics_electronics': '',
    'home_goods_services': '',
    'trade': '',
    'tourism_cruises': '',
    'cleaning_of_premises': '',
    'services_for_animals': '',
    'finance': '',
    'photo_studios': '',
    'hosting': '',
    'flowers_plants': '',
    'schools_training_centers': '',
    'epilation': '',
    'jewelry': '',
    'legal_services': '',
    'medical_centers': '',
    'childrens_centers': '',
    'petroleum_products_gas': '',
    'energy': '',
    'sports_sporting_goods': '',
    'dry_cleaners_laundries': '',
    'tour_operators_travel': '',
    'transport_logistics': '',
    'tickets': '',
    'gifts_souvenirs': '',
    'office_goods_services': '',
    'architecture_engineering': '',
    'defense_sector': '',
    'biotechnology_pharmaceuticals': '',
    'it_services': '',
    'staff_work': '',
    'ecology_environment': '',
    'antiques_collecting': ''
  };
}
