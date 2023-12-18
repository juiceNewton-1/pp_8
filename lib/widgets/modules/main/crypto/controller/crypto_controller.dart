import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_8/models/currencies/crypto_currency.dart';
import 'package:pp_8/models/currency_uint.dart';
import 'package:pp_8/services/crypto_api_service.dart';
import 'package:pp_8/services/repositories/currency_uint_repository.dart';

class CryptoController extends ValueNotifier<CryptoState> {
  CryptoController() : super(CryptoState.inital()) {
    _init();
    _currencyUintRepository.addListener(_handleCurrencyUpdates); 
  }

  final _cryptoApiService = GetIt.instance<CryptoApiService>();
  final _currencyUintRepository = GetIt.instance<CurrencyUintRepository>();

  CurrencyUint get currencyUint => _currencyUintRepository.value.currencyUint!;

  Future<void> _init() async {
    try {
      value = value.copyWith(isLoading: true);
      final currencies =
          await _cryptoApiService.getCoins(currency: currencyUint.uuid);
      value = value.copyWith(currencies: currencies, isLoading: false);
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void _handleCurrencyUpdates() {
    refresh();
  }

  void refresh() => _init();
}

class CryptoState {
  final List<CryptoCurrency> currencies;
  final bool isLoading;
  final String? errorMessage;

  const CryptoState({
    required this.currencies,
    required this.isLoading,
    this.errorMessage,
  });

  factory CryptoState.inital() => CryptoState(
        currencies: [],
        isLoading: false,
      );

  CryptoState copyWith({
    List<CryptoCurrency>? currencies,
    bool? isLoading,
    String? errorMessage,
  }) =>
      CryptoState(
        currencies: currencies ?? this.currencies,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
