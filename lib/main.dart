import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/firebase_options.dart';
import 'package:pp_8/routes/routes.dart';
import 'package:pp_8/services/service_locator.dart';
import 'package:pp_8/theme/default_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ServiceLocator.setup();

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
