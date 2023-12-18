import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_8/models/currencies/crypto_currency.dart';
import 'package:pp_8/models/currencies/forex_currency.dart';
import 'package:pp_8/models/currency_uint.dart';
import 'package:pp_8/services/crypto_api_service.dart';
import 'package:pp_8/services/database/database_service.dart';
import 'package:pp_8/services/database/entities/crypto_currency_entity.dart';
import 'package:pp_8/services/database/entities/forex_currency_entity.dart';
import 'package:pp_8/services/exchange_currency_api_service.dart';
import 'package:pp_8/services/repositories/currency_uint_repository.dart';

class HomeController extends ValueNotifier<HomeState> {
  HomeController() : super(HomeState.initial()) {
    _init();
    _currencyUintRepository.addListener(_handleCurrenciesUpdate);
  }

  final _databaseService = GetIt.instance<DatabaseService>();
  final _currencyUintRepository = GetIt.instance<CurrencyUintRepository>();
  final _cryptoApiService = GetIt.instance<CryptoApiService>();
  final _echangeApiSerivce = GetIt.instance<ExchangeCurrencyApiService>();

  CurrencyUint get currencyUint => _currencyUintRepository.value.currencyUint!;

  Future<void> _init() async {
    final cryptoCurrencies = _databaseService.crypto
        .map((e) => CryptoCurrency.fromEntity(e))
        .toList();
    final forexCurrencies =
        _databaseService.forex.map((e) => ForexCurrency.fromEntity(e)).toList();
    try {
      value = value.copyWith(isLoading: true);

      await _updateCryptoValues(cryptoCurrencies);
      await _updateForexValues(forexCurrencies);
      value = value.copyWith(isLoading: false);
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        forexCurrencies: forexCurrencies,
        cryptoCurrencies: cryptoCurrencies,
      );
    }
  }

  void switchMode(HomeMode mode) => value = value.copyWith(mode: mode);

  void deleteCrypto(CryptoCurrency currency) {
    final currencyIndex = value.cryptoCurrencies.indexOf(currency);
    _databaseService.deleteCryptoCurrency(currencyIndex);
    value.cryptoCurrencies.removeAt(currencyIndex);
    notifyListeners();
  }

  void deleteForex(ForexCurrency currency) {
    final currencyIndex = value.forexCurrencies.indexOf(currency);
    _databaseService.deleteForexCurrency(currencyIndex);
    value.forexCurrencies.removeAt(currencyIndex);
    notifyListeners();
  }

  void _handleCurrenciesUpdate() {
    _refresh();
  }

  void _refresh() => _init();

  Future<void> _updateCryptoValues(List<CryptoCurrency> currencies) async {
    if (currencies.isEmpty) return;
    List<CryptoCurrency> updatedCurrencies = [];
    for (var i = 0; i < currencies.length; i++) {
      final updatedCurrency = await _cryptoApiService
          .getCoin(currencies[i].uuid, currency: currencyUint.uuid);
      _databaseService.updateCryptoCurrency(
          CryptoCurrencyEntity.fromOriginal(updatedCurrency), i);
      updatedCurrencies.add(updatedCurrency);
    }
    value = value.copyWith(cryptoCurrencies: updatedCurrencies);
  }

  Future<void> _updateForexValues(List<ForexCurrency> currencies) async {
    if (currencies.isEmpty) return;
    List<ForexCurrency> updatedCurrencies = [];
    for (var i = 0; i < currencies.length; i++) {
      final rate = await _echangeApiSerivce.getExchangeRate(
        from: currencies[i].code,
        to: currencyUint.symbol!,
        amount: '1',
      );
      final updatedCurrency = currencies[i].copyWith(rate);
      _databaseService.updateForexCurrency(
          ForexCurrencyEntity.fromOriginal(updatedCurrency), i);
      updatedCurrencies.add(updatedCurrency);
    }
    value = value.copyWith(forexCurrencies: updatedCurrencies);
  }

  void updateCrypto(List<CryptoCurrency> currencies) {
    for (var currency in currencies) {
      if (!value.cryptoCurrencies.contains(currency)) {
        value.cryptoCurrencies.add(currency);
          _databaseService.addCryptoCurrency(CryptoCurrencyEntity.fromOriginal(currency));
      }
    }
    notifyListeners();
  }

  void updateForex(List<ForexCurrency> currencies) {
    for (var currency in currencies) {
      if (!value.forexCurrencies.contains(currency)) {
        value.forexCurrencies.add(currency);
        _databaseService.addForexCurrency(ForexCurrencyEntity.fromOriginal(currency));
      }
    }
    notifyListeners();
  }
}

class HomeState {
  final bool isLoading;
  final List<CryptoCurrency> cryptoCurrencies;
  final List<ForexCurrency> forexCurrencies;
  final HomeMode mode;
  const HomeState({
    required this.isLoading,
    required this.cryptoCurrencies,
    required this.forexCurrencies,
    required this.mode,
  });

  factory HomeState.initial() => HomeState(
        cryptoCurrencies: [],
        forexCurrencies: [],
        mode: HomeMode.none,
        isLoading: false,
      );

  HomeState copyWith({
    List<CryptoCurrency>? cryptoCurrencies,
    List<ForexCurrency>? forexCurrencies,
    HomeMode? mode,
    bool? isLoading,
  }) =>
      HomeState(
        cryptoCurrencies: cryptoCurrencies ?? this.cryptoCurrencies,
        mode: mode ?? this.mode,
        forexCurrencies: forexCurrencies ?? this.forexCurrencies,
        isLoading: isLoading ?? this.isLoading,
      );
}

enum HomeMode { none, edit }
