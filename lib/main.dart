import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/firebase_options.dart';
import 'package:pp_8/routes/routes.dart';
import 'package:pp_8/services/service_locator.dart';
import 'package:pp_8/theme/default_theme.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ServiceLocator.setup();
  runApp(const ExchangeRates());
}

class ExchangeRates extends StatelessWidget {
  const ExchangeRates({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExchangeRates',
      debugShowCheckedModeBanner: false,
      theme: DefaultTheme.get,
      routes: AppRoutes.get(context),
    );
  }
}
