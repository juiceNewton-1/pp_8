import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_8/models/currency_uint.dart';
import 'package:pp_8/services/crypto_api_service.dart';
import 'package:pp_8/services/database/database_keys.dart';
import 'package:pp_8/services/database/database_service.dart';
import 'package:pp_8/services/repositories/currency_uint_repository.dart';

class ChangeCurrencyController extends ValueNotifier<ChangeCurrencyState> {
  ChangeCurrencyController() : super(ChangeCurrencyState.inital()) {
    _init();
  }

  final _cryptoApiService = GetIt.instance<CryptoApiService>();
  final _currencyUintRepository = GetIt.instance<CurrencyUintRepository>();
  final _databaseService = GetIt.instance<DatabaseService>();

  Future<void> _init() async {
    final currencyUint = CurrencyUint.fromEntity(_databaseService.getCurrencyUint(DatabaseKeys.defaultCurrency)!);
    try {
      value = value.copyWith(isLoading: true);
      final currencyUints = await _cryptoApiService.getCurrencyUints();
      value = value.copyWith(
        currencyUints: currencyUints,
        isLoading: false,
        selectedCurrency: currencyUint,
      );
    } catch (e) {
      log(e.toString());
      value = value.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void refresh() => _init();

  void changeCurrency() {
   _currencyUintRepository.changeCurrency(value.selectedCurrency!);
  }

  void selectCurrency(CurrencyUint currency) =>
      value = value.copyWith(selectedCurrency: currency);
}

class ChangeCurrencyState {
  final List<CurrencyUint> currencyUints;
  final CurrencyUint? selectedCurrency;
  final bool isLoading;
  final String? errorMessage;
  const ChangeCurrencyState({
    required this.currencyUints,
    required this.isLoading,
    this.errorMessage,
    this.selectedCurrency,
  });

  factory ChangeCurrencyState.inital() => ChangeCurrencyState(
        currencyUints: [],
        isLoading: false,
      );

  ChangeCurrencyState copyWith({
    List<CurrencyUint>? currencyUints,
    bool? isLoading,
    String? errorMessage,
    CurrencyUint? selectedCurrency,
  }) =>
      ChangeCurrencyState(
        currencyUints: currencyUints ?? this.currencyUints,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      );
}
