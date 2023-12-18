import 'package:get_it/get_it.dart';
import 'package:pp_8/services/crypto_api_service.dart';
import 'package:pp_8/services/database/database_service.dart';
import 'package:pp_8/services/exchange_currency_api_service.dart';
import 'package:pp_8/services/news_api_service.dart';
import 'package:pp_8/services/remote_config_service.dart';
import 'package:pp_8/services/repositories/currency_uint_repository.dart';
import 'package:pp_8/services/resources_api_service.dart';

class ServiceLocator {
  static Future<void> setup() async{
    GetIt.I.registerSingletonAsync(() => DatabaseService().init());
    await GetIt.I.isReady<DatabaseService>();
    GetIt.I.registerSingletonAsync( () => RemoteConfigService().init());
    await GetIt.I.isReady<RemoteConfigService>();
    GetIt.I.registerSingleton(ResourcesApiService());
    GetIt.I.registerSingleton(CryptoApiService());
    GetIt.I.registerSingleton(ExchangeCurrencyApiService());
    GetIt.I.registerSingleton(NewsApiService());
  }

  static void loadRepositories() {
    GetIt.I.registerSingleton(CurrencyUintRepository());
  }
}