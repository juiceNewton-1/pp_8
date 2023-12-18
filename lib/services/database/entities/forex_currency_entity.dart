import 'package:hive/hive.dart';
import 'package:pp_8/models/currencies/forex_currency.dart';

part 'forex_currency_entity.g.dart';

@HiveType(typeId: 2)
class ForexCurrencyEntity {
  @HiveField(0)
  final String code;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String flag;
  @HiveField(3)
  final String symbol;
  @HiveField(4)
  final String rate;

  factory ForexCurrencyEntity.fromOriginal(ForexCurrency currency) =>
      ForexCurrencyEntity(
        code: currency.code,
        flag: currency.flag.path,
        name: currency.name,
        symbol: currency.symbol,
        rate:  currency.rate, 
      );

  ForexCurrencyEntity({
    required this.code,
    required this.name,
    required this.flag,
    required this.symbol,
    required this.rate, 
  });
}
