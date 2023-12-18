import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_8/models/currency_uint.dart';
import 'package:pp_8/services/crypto_api_service.dart';
import 'package:pp_8/services/database/database_keys.dart';
import 'package:pp_8/services/database/database_service.dart';
import 'package:pp_8/services/database/entities/currency_uint_entity.dart';

class CurrencySelectionController
    extends ValueNotifier<CurrencySelectionState> {
  CurrencySelectionController() : super(CurrencySelectionState.inital()) {
    _init();
  }

  final _cryptoApiService = GetIt.instance<CryptoApiService>();
  final _databaseService = GetIt.instance<DatabaseService>();

  Future<void> _init() async {
    try {
      value = value.copyWith(isLoading: true);
      final currencyUints = await _cryptoApiService.getCurrencyUints();
      value = value.copyWith(
        currencyUints: currencyUints,
        isLoading: false,
        selectedCurrency: currencyUints.first,
      );
    } catch (e) {
      log(e.toString());
      value = value.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void refresh() => _init();

  void saveCurrencyUint() {
    _databaseService.putCurrencyUint(
      DatabaseKeys.defaultCurrency,
      CurrencyUintEntity.fromOriginal(value.selectedCurrency!),
    );
  }

  void selectCurrency(CurrencyUint currency) => value = value.copyWith(selectedCurrency: currency);
}

class CurrencySelectionState {
  final List<CurrencyUint> currencyUints;
  final CurrencyUint? selectedCurrency;
  final bool isLoading;
  final String? errorMessage;
  const CurrencySelectionState({
    required this.currencyUints,
    required this.isLoading,
    this.errorMessage,
    this.selectedCurrency,
  });

  factory CurrencySelectionState.inital() => CurrencySelectionState(
        currencyUints: [],
        isLoading: false,
      );

  CurrencySelectionState copyWith(
          {List<CurrencyUint>? currencyUints,
          bool? isLoading,
          String? errorMessage,
          CurrencyUint? selectedCurrency}) =>
      CurrencySelectionState(
        currencyUints: currencyUints ?? this.currencyUints,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      );
}
