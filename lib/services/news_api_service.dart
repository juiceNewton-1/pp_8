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
              '894c12740cmshc0268519b72cc5fp1dea02jsn7b7a5b95c67e',
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
