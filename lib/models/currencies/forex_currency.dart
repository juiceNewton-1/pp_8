import 'package:equatable/equatable.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/models/currencies/currency.dart';
import 'package:pp_8/services/database/entities/forex_currency_entity.dart';

class ForexCurrency extends Equatable implements Currency {
  final String code;
  final String name;
  final SvgGenImage flag;
  final String symbol;
  final String rate;
  const ForexCurrency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
     this.rate = '',
  });

  @override
  List<Object?> get props => [code];

  factory ForexCurrency.fromEntity(ForexCurrencyEntity entity) => ForexCurrency(
        code: entity.code,
        name: entity.name,
        symbol: entity.symbol,
        rate: entity.rate,
        flag: Assets.exchanges.values
            .firstWhere((element) => element.path == entity.flag),
      );


      ForexCurrency copyWith(String rate) => ForexCurrency(code: code, name: name, symbol: symbol, flag: flag, rate: rate);
}
