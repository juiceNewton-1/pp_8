import 'package:hive/hive.dart';
import 'package:pp_8/models/currency_uint.dart';

part 'currency_uint_entity.g.dart';

@HiveType(typeId: 0)
class CurrencyUintEntity {
  @HiveField(0)
  final String uuid;
  @HiveField(1)
  final String? iconUrl;
  @HiveField(2)
  final String? name;
  @HiveField(3)
  final String? symbol;
  @HiveField(4)
  final String? sign;

  const CurrencyUintEntity({
    required this.name,
    required this.symbol,
    required this.iconUrl,
    required this.sign,
    required this.uuid,
  });

  factory CurrencyUintEntity.fromOriginal(CurrencyUint currencyUint) =>
      CurrencyUintEntity(
        name: currencyUint.name,
        symbol: currencyUint.symbol,
        iconUrl: currencyUint.iconUrl,
        sign: currencyUint.sign,
        uuid: currencyUint.uuid,
      );
}
