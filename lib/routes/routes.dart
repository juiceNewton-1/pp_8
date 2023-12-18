import 'package:flutter/material.dart';
import 'package:pp_8/routes/route_names.dart';
import 'package:pp_8/widgets/modules/currency_selection/view/currency_selection_view.dart';
import 'package:pp_8/widgets/modules/main/home/views/add_currency_view.dart';
import 'package:pp_8/widgets/modules/main/main_view.dart';
import 'package:pp_8/widgets/modules/main/news/views/single_news_view.dart';
import 'package:pp_8/widgets/modules/privacy_view.dart';
import 'package:pp_8/widgets/modules/settings/change_currency/view/change_currency_view.dart';
import 'package:pp_8/widgets/modules/settings/language_view.dart';
import 'package:pp_8/widgets/modules/settings/resource/view/resources_view.dart';
import 'package:pp_8/widgets/modules/settings/settings_view.dart';
import 'package:pp_8/widgets/modules/settings/write_us_view.dart';
import 'package:pp_8/widgets/modules/splash_view.dart';

typedef AppRoute = Widget Function(BuildContext context);

class AppRoutes {
  static Map<String, AppRoute> get(BuildContext context) => {
        RouteNames.splash: (context) => const SplashView(),
        RouteNames.currencySelection: (context) =>
            const CurrencySelectionView(),
        RouteNames.settings: (context) => const SettingsView(),
        RouteNames.language: (context) => const LanguageView(),
        RouteNames.resources: (context) => const ResourcesView(),
        RouteNames.writeUs: (context) => const WriteUsView(),
        RouteNames.main: (context) => const MainView(),
        RouteNames.addCurrency: (context) => const AddCurrencyView(),
        RouteNames.changeCurrency: (context) =>  const ChangeCurrencyView(), 
        RouteNames.singleNews: (context) => SingleNewsView.ceate(context), 
        RouteNames.privacy: (context) => const  PrivacyView(),
      };
}
