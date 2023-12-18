import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:pp_8/models/resources/resource.dart';
import 'package:pp_8/models/resources/resource_query.dart';
import 'package:http/http.dart' as http;

class ResourcesApiService {
  Future<Resource> getResource(ResourceQuery query, {String? currency}) async {
    final dateFormat = DateFormat('yyyy-MM-dd');

    final formatedDate = dateFormat.format(DateTime.now());

    try {
      final response = await http.get(
        Uri.parse(
            'https://commodity-rates-api.p.rapidapi.com/open-high-low-close/$formatedDate?base=$currency&symbols=${query.symbol}'),
        headers: {
          'X-RapidAPI-Key':
              'fd27ef39b4msh8d4d74a66824eaap10bd48jsn209775895202',
          'X-RapidAPI-Host': 'commodity-rates-api.p.rapidapi.com'
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return Resource.fromJson(json);
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}