import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_8/helpers/dialog_helper.dart';
import 'package:pp_8/routes/route_names.dart';
import 'package:pp_8/services/database/database_keys.dart';
import 'package:pp_8/services/database/database_service.dart';
import 'package:pp_8/widgets/components/splash_loading.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final _databaseService = GetIt.instance<DatabaseService>();
  final _connectivity = Connectivity();

  @override
  void initState() {
    Timer(Duration(milliseconds: 1500), _init);
    super.initState();
  }

  Future<void> _init() async {
    await _initConnectivity(
      () async => await DialogHelper.showNoInternetDialog(context),
    );

    _navigate();
  }

  Future<void> _initConnectivity(Future<void> Function() callback) async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        await callback.call();
        return;
      }
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }
  }

  void _navigate() {
    final acceptedPrivacy =
        _databaseService.get(DatabaseKeys.acceptedPrivacy) ?? false;
    if (!acceptedPrivacy) {
      Navigator.of(context).pushReplacementNamed(RouteNames.privacy);
    } else {
      if (_databaseService.isCurrencyUintEmpty) {
        Navigator.of(context).pushReplacementNamed(RouteNames.currencySelection);
      } else {
        Navigator.of(context).pushReplacementNamed(RouteNames.main);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SplashLoading(),
    );
  }
}
