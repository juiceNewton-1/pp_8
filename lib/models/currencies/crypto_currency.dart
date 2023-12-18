import 'package:equatable/equatable.dart';
import 'package:pp_8/models/currencies/currency.dart';
import 'package:pp_8/services/database/entities/crypto_currency_entity.dart';

class CryptoCurrency extends Equatable implements Currency {
  final String iconUrl;
  final double price;
  final double change;
  final String name;
  final String symbol;
  final String uuid;
  CryptoCurrency({
    required this.iconUrl,
    required this.uuid,
    required this.price,
    required this.change,
    required this.name,
    required this.symbol,
  });

  factory CryptoCurrency.fromjson(Map<String, dynamic> json) => CryptoCurrency(
        iconUrl: json['iconUrl'],
        price: double.parse(json['price']),
        change: double.parse(json['change']),
        name: json['name'],
        symbol: json['symbol'],
        uuid: json['uuid'],
      );

  @override
  List<Object?> get props => [
        iconUrl,
        name,
        price,
        change,
        symbol,
        uuid,
      ];

  factory CryptoCurrency.fromEntity(CryptoCurrencyEntity entity) =>
      CryptoCurrency(
        iconUrl: entity.iconUrl,
        price: entity.price,
        change: entity.change,
        name: entity.name,
        symbol: entity.symbol,
        uuid: entity.uuid,
      );

  CryptoCurrency copyWith({double? change, double? price}) => CryptoCurrency(
        iconUrl: iconUrl,
        price: price ?? this.price,
        change: change ?? this.change,
        name: name,
        symbol: symbol,
        uuid: uuid,
      );
}
