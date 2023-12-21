import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pp_8/firebase_options.dart';
import 'package:pp_8/routes/routes.dart';
import 'package:pp_8/services/service_locator.dart';
import 'package:pp_8/theme/default_theme.dart';

Future<void> main() async {
  final bindings = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: bindings);
  await EasyLocalization.ensureInitialized();
  await _initApp();

  runApp(
    EasyLocalization(
      child: const ExchangeRates(),
      supportedLocales: [
        Locale('ar'),
        Locale('bn'),
        Locale('de'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('hi'),
        Locale('ja'),
        Locale('ko'),
        Locale('pt'),
        Locale('ru'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
    ),
  );
}

Future<void> _initApp() async {
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } on Exception catch (e) {
    log("Failed to initialize Firebase: $e");
  }

  await ServiceLocator.setup();
}

class ExchangeRates extends StatelessWidget {
  const ExchangeRates({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Compact exchange rates',
      debugShowCheckedModeBanner: false,
      theme: DefaultTheme.get,
      routes: AppRoutes.get(context),
    );
  }
}
