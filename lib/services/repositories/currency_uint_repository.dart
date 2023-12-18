import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_8/models/currency_uint.dart';
import 'package:pp_8/services/database/database_keys.dart';
import 'package:pp_8/services/database/database_service.dart';
import 'package:pp_8/services/database/entities/currency_uint_entity.dart';

class CurrencyUintRepository extends ValueNotifier<CurrencyUintState> {
  CurrencyUintRepository() : super(CurrencyUintState.inital()) {
    _init();
  }

  final _databaseService = GetIt.instance<DatabaseService>() ;

  void _init() {
    final uintEntity = _databaseService.getCurrencyUint(DatabaseKeys.defaultCurrency);
    value = value.copyWith(CurrencyUint.fromEntity(uintEntity!));
  }

  void changeCurrency(CurrencyUint currencyUint) {
    final entity = CurrencyUintEntity.fromOriginal(currencyUint);
    _databaseService.putCurrencyUint(DatabaseKeys.defaultCurrency, entity);
    value = value.copyWith(currencyUint);
  }
}

class CurrencyUintState {
  final CurrencyUint? currencyUint;

  const CurrencyUintState({this.currencyUint});

  factory CurrencyUintState.inital() => CurrencyUintState();

  CurrencyUintState copyWith(CurrencyUint currencyUint) =>
      CurrencyUintState(currencyUint: currencyUint);
}
