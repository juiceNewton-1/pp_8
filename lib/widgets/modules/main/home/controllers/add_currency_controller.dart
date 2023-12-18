import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_8/helpers/constants.dart';
import 'package:pp_8/models/currencies/crypto_currency.dart';
import 'package:pp_8/models/currencies/forex_currency.dart';
import 'package:pp_8/models/currency_uint.dart';
import 'package:pp_8/services/crypto_api_service.dart';
import 'package:pp_8/services/exchange_currency_api_service.dart';
import 'package:pp_8/services/repositories/currency_uint_repository.dart';

class AddCurrencyController extends ValueNotifier<AddCurrencyState> {
  AddCurrencyController() : super(AddCurrencyState.initial()) {
    _init();
  }

  final _cryptoApiService = GetIt.instance<CryptoApiService>();
  final _currencyUintRepository = GetIt.instance<CurrencyUintRepository>();
  final _exchangeApiService = GetIt.instance<ExchangeCurrencyApiService>();

  CurrencyUint get _currencyUint => _currencyUintRepository.value.currencyUint!;

  void _init() {
    _getCryptoCurrencies();
    _getForexCurrencies();
  }

  Future<void> _getCryptoCurrencies() async {
    try {
      value.copyWith(isCryptoLoading: true);
      final currencies =
          await _cryptoApiService.getCoins(currency: _currencyUint.uuid);
      value =
          value.copyWith(isCryptoLoading: false, cryptoCurrencies: currencies);
    } catch (e) {
      log(e.toString());
      value = value.copyWith(
        isCryptoLoading: false,
        cryptoError: e.toString(),
      );
    }
  }

  Future<void> _getForexCurrencies() async {
    try {
      value = value.copyWith(isForexLoading: true);
      List<ForexCurrency> currencies = [];
      for (var currency in Constants.forexCurrencies) {
        final rate = await _exchangeApiService.getExchangeRate(
            from: currency.code, to: _currencyUint.symbol!, amount: '1');
        currencies.add(currency.copyWith(rate));
      }
      value =
          value.copyWith(isForexLoading: false, forexCurrencies: currencies);
    } catch (e) {
      value = value.copyWith(
        isForexLoading: false,
        forexError: e.toString(),
      );
    }
  }

  void refreshCrypto() => _getCryptoCurrencies();

  void refreshForex() => _getForexCurrencies();

  void switchSegment(Segment segment) =>
      value = value.copyWith(segment: segment);

  bool isCryptoSelected(CryptoCurrency currency) =>
      value.selectedCrypto.contains(currency);

  bool isForexSelected(ForexCurrency currency) =>
      value.selectedForex.contains(currency);

  void selectCrypto(CryptoCurrency currency) {
    value.selectedCrypto.add(currency);
    notifyListeners();
  }

  void unselectCrypto(CryptoCurrency currency) {
    value.selectedCrypto.remove(currency);
    notifyListeners();
  }

  void selectForex(ForexCurrency currency) {
    value.selectedForex.add(currency);
    notifyListeners();
  }

  void unselectForex(ForexCurrency currency) {
    value.selectedForex.remove(currency);
    notifyListeners();
  }

}

class AddCurrencyState {
  final Segment segment;
  final bool isCryptoLoading;
  final String? cryptoError;
  final bool isForexLoading;
  final String? forexError;

  final List<CryptoCurrency> cryptoCurrencies;
  final List<ForexCurrency> forexCurrencies;
  final List<CryptoCurrency> selectedCrypto;
  final List<ForexCurrency> selectedForex;

  const AddCurrencyState(
      {required this.segment,
      required this.cryptoCurrencies,
      required this.forexCurrencies,
      required this.isCryptoLoading,
      required this.selectedCrypto,
      required this.selectedForex,
      required this.isForexLoading,
      this.cryptoError,
      this.forexError});

  factory AddCurrencyState.initial() => AddCurrencyState(
        segment: Segment.forex,
        cryptoCurrencies: [],
        forexCurrencies: [],
        isCryptoLoading: false,
        isForexLoading: false,
        selectedCrypto: [],
        selectedForex: [],
      );

  AddCurrencyState copyWith({
    List<CryptoCurrency>? cryptoCurrencies,
    List<ForexCurrency>? forexCurrencies,
    List<CryptoCurrency>? selectedCrypto,
    List<ForexCurrency>? selectedForex,
    Segment? segment,
    bool? isCryptoLoading,
    String? cryptoError,
    bool? isForexLoading,
    String? forexError,
  }) =>
      AddCurrencyState(
        segment: segment ?? this.segment,
        cryptoCurrencies: cryptoCurrencies ?? this.cryptoCurrencies,
        forexCurrencies: forexCurrencies ?? this.forexCurrencies,
        isCryptoLoading: isCryptoLoading ?? this.isCryptoLoading,
        selectedCrypto: selectedCrypto ?? this.selectedCrypto,
        selectedForex: selectedForex ?? this.selectedForex,
        isForexLoading: isForexLoading ?? this.isForexLoading,
        forexError: forexError ?? this.forexError,
      );
}

enum Segment {
  forex,
  crypto,
}
