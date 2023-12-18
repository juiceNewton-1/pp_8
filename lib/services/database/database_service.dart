import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pp_8/services/database/database_keys.dart';
import 'package:pp_8/services/database/entities/crypto_currency_entity.dart';
import 'package:pp_8/services/database/entities/currency_uint_entity.dart';
import 'package:pp_8/services/database/entities/forex_currency_entity.dart';

class DatabaseService {
  late final Box _common;
  late final Box<CurrencyUintEntity> _defaultCurrency;
  late final Box<CryptoCurrencyEntity> _crypto;
  late final Box<ForexCurrencyEntity> _forex;
  Future<DatabaseService> init() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDirectory.path);
    Hive.registerAdapter(CurrencyUintEntityAdapter());
    Hive.registerAdapter(CryptoCurrencyEntityAdapter());
    Hive.registerAdapter(ForexCurrencyEntityAdapter());
    _common = await Hive.openBox('common');
    _defaultCurrency = await Hive.openBox('defaultCurrency');
    _crypto = await Hive.openBox('crypto');
    _forex = await Hive.openBox('forex');
    return this;
  }

  Stream<BoxEvent> get cryptoStream => _crypto.watch();

  Stream<BoxEvent> get forexStream => _forex.watch(); 

  List<CryptoCurrencyEntity> get crypto => _crypto.values.toList();

  List<ForexCurrencyEntity> get forex => _forex.values.toList();

  bool get isCurrencyUintEmpty =>
      getCurrencyUint(DatabaseKeys.defaultCurrency) == null;

  void put(String key, dynamic value) => _common.put(key, value);

  dynamic get(String key) => _common.get(key);

  CurrencyUintEntity? getCurrencyUint(String key) => _defaultCurrency.get(key);

  void putCurrencyUint(String key, CurrencyUintEntity value) =>
      _defaultCurrency.put(key, value);

    void addCryptoCurrency(CryptoCurrencyEntity value) => _crypto.add(value);

    void deleteCryptoCurrency(int index) => _crypto.deleteAt(index);

    void updateCryptoCurrency(CryptoCurrencyEntity value, int index) => _crypto.putAt(index, value); 

    void addAllCrypto(Iterable<CryptoCurrencyEntity> entities) => _crypto.addAll(entities);

    void addForexCurrency(ForexCurrencyEntity value) => _forex.add(value);

    void deleteForexCurrency(int index) => _forex.deleteAt(index);

    void updateForexCurrency(ForexCurrencyEntity value, int index) => _forex.putAt(index, value); 

    void addAllForex(Iterable<ForexCurrencyEntity> entities) => _forex.addAll(entities);

  
}
