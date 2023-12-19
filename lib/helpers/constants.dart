import 'package:flutter/material.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/models/currencies/forex_currency.dart';

import 'package:pp_8/models/language.dart';
import 'package:pp_8/models/resources/resource_query.dart';

class Constants {
  static const languages = [
    Language(name: 'العربية', locale: Locale('ar')),
    Language(name: 'বাংলা', locale: Locale('bn')),
    Language(name: 'Dansk', locale: Locale('de')),
    Language(name: 'English', locale: Locale('en')),
    Language(name: 'Español', locale: Locale('es')),
    Language(name: 'Français', locale: Locale('fr')),
    Language(name: 'हिन्दी', locale: Locale('hi')),
    Language(name: '日本語', locale: Locale('ja')),
    Language(name: '한국어', locale: Locale('ko')),
    Language(name: 'Português', locale: Locale('pt')),
      Language(name: 'Русский', locale: Locale('ru')),

  ];

  static final reourseQueries = [
    ResourceQuery(symbol: 'XAU', icon: Assets.images.gold, name: 'Gold'),
    ResourceQuery(symbol: 'XAG', icon: Assets.images.silver, name: 'Silver'),
    ResourceQuery(
        symbol: 'BRENTOIL', icon: Assets.images.oil, name: 'Brentoil'),
    ResourceQuery(symbol: 'COCOA', icon: Assets.images.cocoa, name: 'Cocoa'),
    ResourceQuery(symbol: 'NG', icon: Assets.images.gas, name: 'Gas'),
    ResourceQuery(symbol: 'XCU', icon: Assets.images.copper, name: 'Copper'),
    ResourceQuery(
        symbol: 'XPT', icon: Assets.images.platinum, name: 'Platinum'),
    ResourceQuery(symbol: 'WHEAT', icon: Assets.images.grain, name: 'Wheat'),
    ResourceQuery(
        symbol: 'HOU22', icon: Assets.images.liquid, name: 'Heating Oil'),
    ResourceQuery(symbol: 'NI', icon: Assets.images.beam, name: 'Nickel'),
  ];

  static final forexCurrencies = [
    ForexCurrency(
      code: 'USD',
      name: "US Dollar",
      symbol: '\$',
      flag: Assets.exchanges.usd,
    ),
    ForexCurrency(
      code: 'EUR',
      name: "Euro",
      flag: Assets.exchanges.eur,
      symbol: '€',
    ),
    ForexCurrency(
      code: 'GBP',
      name: "Brtitish pound",
      flag: Assets.exchanges.gbp,
      symbol: '£',
    ),
    ForexCurrency(
      code: 'CAD',
      name: "Canadian dollar",
      flag: Assets.exchanges.cad,
      symbol: 'C\$',
    ),
    ForexCurrency(
      code: 'AUD',
      name: "Australian dollar",
      flag: Assets.exchanges.aud,
      symbol: 'A\$',
    ),
    ForexCurrency(
        code: 'CHF',
        name: "Swiss franc",
        flag: Assets.exchanges.chf,
        symbol: 'Fr'),
    ForexCurrency(
      code: 'CNY',
      name: "Chinese Renminbi",
      flag: Assets.exchanges.cny,
      symbol: '¥',
    ),
    ForexCurrency(
      code: 'JPY',
      name: "Japanese yen",
      flag: Assets.exchanges.jpy,
      symbol: '¥',
    ),
    ForexCurrency(
        code: 'HKD',
        name: "Hong Kong dollar",
        flag: Assets.exchanges.hkd,
        symbol: '\$'),
    ForexCurrency(
      code: 'NZD',
      name: "New Zeland dollar",
      flag: Assets.exchanges.nzd,
      symbol: '\$',
    ),
    ForexCurrency(
      code: 'KRW',
      name: "Korean won",
      flag: Assets.exchanges.krw,
      symbol: '₩',
    ),
    ForexCurrency(
      code: 'SGD',
      name: "Singapore dollar",
      flag: Assets.exchanges.sgd,
      symbol: '\$',
    ),
    ForexCurrency(
      code: 'SEK',
      name: "Swedish krona",
      flag: Assets.exchanges.sek,
      symbol: 'kr',
    ),
    ForexCurrency(
      code: 'MXN',
      name: "Mexican peso",
      flag: Assets.exchanges.mxn,
      symbol: '\$',
    ),
    ForexCurrency(
      code: 'INR',
      name: "Indian rupee",
      flag: Assets.exchanges.inr,
      symbol: '₹',
    ),
    ForexCurrency(
      code: 'RUB',
      name: "Rusian ruble",
      flag: Assets.exchanges.rub,
      symbol: '₽',
    ),
  ];
}
