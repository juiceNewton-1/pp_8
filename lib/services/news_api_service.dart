import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:pp_8/models/news.dart';

class NewsApiService {
  static const _url = 'https://google-api31.p.rapidapi.com/';

  Future<List<News>> getArticles() async {
    try {
      List<News> articles = [];
      final data = {
        "text": "Forex and Crypto",
        "region": "wt-wt",
        "max_results": 20,
        "time_limit": "d"
      };
      final response = await post(
        Uri.parse(_url),
        headers: {
          'X-RapidAPI-Key':
              '19672c07cbmsh0eb7ed69aa7a086p18194ajsn1e466426c7bc',
          'X-RapidAPI-Host': 'google-api31.p.rapidapi.com'
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log(data.toString());
        final json = data['news'] as List<dynamic>;
        for (var articleJson in json) {
          articles.add(News.fromJson(articleJson));
        }
        return articles;
      } else {
        log(response.statusCode.toString());
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
