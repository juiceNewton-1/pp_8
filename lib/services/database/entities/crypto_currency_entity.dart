import 'package:hive/hive.dart';
import 'package:pp_8/models/currencies/crypto_currency.dart';

part 'crypto_currency_entity.g.dart';

@HiveType(typeId: 1)
class CryptoCurrencyEntity {
  @HiveField(0)
  final String iconUrl;
  @HiveField(1)
  final double price;
  @HiveField(2)
  final double change;
  @HiveField(3)
  final String name;
  @HiveField(4)
  final String symbol;
  @HiveField(5)
  final String uuid;

  const CryptoCurrencyEntity({
    required this.iconUrl,
    required this.price,
    required this.change,
    required this.name,
    required this.symbol,
    required this.uuid, 
  });

  factory CryptoCurrencyEntity.fromOriginal(CryptoCurrency currency) =>
      CryptoCurrencyEntity(
        iconUrl: currency.iconUrl,
        price: currency.price,
        change: currency.change,
        name: currency.name,
        symbol: currency.symbol,
        uuid: currency.uuid, 
      );
}
