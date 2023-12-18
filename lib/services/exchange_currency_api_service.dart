import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeCurrencyApiService {
  Future<String> getExchangeRate({
    required String from,
    required String to,
    required String amount,
  }) async {
    try {
      final response = await http.get(
          Uri.parse(
              'https://currency-convertor-api.p.rapidapi.com/convert/$amount/$from/$to'),
          headers: {
            'X-RapidAPI-Key':
                '894c12740cmshc0268519b72cc5fp1dea02jsn7b7a5b95c67e',
            'X-RapidAPI-Host': 'currency-convertor-api.p.rapidapi.com'
          });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.first['rate'];
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
