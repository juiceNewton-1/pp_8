import 'dart:convert';
import 'dart:developer';
import 'package:pp_8/models/currencies/crypto_currency.dart';
import 'package:http/http.dart' as http;
import 'package:pp_8/models/currency_uint.dart';

class CryptoApiService {
  Future<List<CryptoCurrency>> getCoins({
    String? currency
  }) async {
    List<CryptoCurrency> currencies = [];
    try {
      final response = await http.get(
        Uri.parse('https://coinranking1.p.rapidapi.com/coins?referenceCurrencyUuid=$currency'),
        headers: {
          'X-RapidAPI-Key':
              '894c12740cmshc0268519b72cc5fp1dea02jsn7b7a5b95c67e',
          'X-RapidAPI-Host': 'coinranking1.p.rapidapi.com'
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data']['coins'] as List<dynamic>;
        for (var coinData in data) {
          currencies.add(CryptoCurrency.fromjson(coinData));
        }
        return currencies;
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CurrencyUint>> getCurrencyUints() async {
    List<CurrencyUint> currencies =[];
    try {
      final response = await http.get(
        Uri.parse('https://coinranking1.p.rapidapi.com/reference-currencies?limit=30'),
        headers: {
          'X-RapidAPI-Key':
              '894c12740cmshc0268519b72cc5fp1dea02jsn7b7a5b95c67e',
          'X-RapidAPI-Host': 'coinranking1.p.rapidapi.com'
        },
      );
      if (response.statusCode == 200) {
        final currenciesJson = jsonDecode(response.body)['data']['currencies'] as List<dynamic>;
        for (var currencyJson in currenciesJson) {
          currencies.add(CurrencyUint.fromJson(currencyJson));
        }
        return currencies;
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

    Future<CryptoCurrency> getCoin(String id, {String? currency}) async{
    try {
      final response = await http.get(
        Uri.parse('https://coinranking1.p.rapidapi.com/coin/$id?referenceCurrencyUuid=$currency'),
        headers: {
          'X-RapidAPI-Key':
              '19672c07cbmsh0eb7ed69aa7a086p18194ajsn1e466426c7bc',
          'X-RapidAPI-Host': 'coinranking1.p.rapidapi.com'
        },
      );

      final json = jsonDecode(response.body)['data']['coin'];
      return CryptoCurrency.fromjson(json);
    } catch (e) {
      log('GETCOIN: ${e.toString()}');
      rethrow;
    }
  }
}




