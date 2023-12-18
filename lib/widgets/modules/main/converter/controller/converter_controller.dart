import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_8/helpers/constants.dart';
import 'package:pp_8/models/currencies/forex_currency.dart';
import 'package:pp_8/services/exchange_currency_api_service.dart';

class ConverterController extends ValueNotifier<ConverterState> {
  ConverterController() : super(ConverterState.initial()) {
    _init();
  }

  final _exchangeCurrencyApiService =
      GetIt.instance<ExchangeCurrencyApiService>();

  void _init() => value = value.copyWith(currencies: Constants.forexCurrencies);

  void selectCurrency(ForexCurrency currency) {
    if (value.selectedCurrency != null) {
      clear();
    }
    value = value.copyWith(selectedCurrency: currency);
  }
      

  Future<void> submit(String amount) async {
    if (amount.isEmpty) return;
    value = value.copyWith(isRatesLoading: true);
    List<String> rates = [];
    for (var currency in value.currencies) {
      if (currency != value.selectedCurrency!) {
        final rate = await _exchangeCurrencyApiService.getExchangeRate(
          from: value.selectedCurrency!.code,
          to: currency.code,
          amount: amount,
        );
        rates.add(rate);
      }
    }

    value = value.copyWith(isRatesLoading: false, rates: rates);
  }

  void clear() => value = value.copyWith(rates: []);
}

class ConverterState {
  final List<String> rates;
  final List<ForexCurrency> currencies;
  final ForexCurrency? selectedCurrency;
  final bool isRatesLoading;

  const ConverterState({
    required this.currencies,
    required this.rates,
    required this.isRatesLoading,
    this.selectedCurrency,
  });

  factory ConverterState.initial() => ConverterState(
        currencies: [],
        rates: [],
        isRatesLoading: false,
      );

  ConverterState copyWith({
    List<String>? rates,
    List<ForexCurrency>? currencies,
    ForexCurrency? selectedCurrency,
    bool? isRatesLoading,
  }) =>
      ConverterState(
        rates: rates ?? this.rates,
        currencies: currencies ?? this.currencies,
        selectedCurrency: selectedCurrency ?? this.selectedCurrency,
        isRatesLoading: isRatesLoading ?? this.isRatesLoading,
      );
}
