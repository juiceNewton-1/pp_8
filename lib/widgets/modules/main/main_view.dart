import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/services/database/database_keys.dart';
import 'package:pp_8/services/database/database_service.dart';
import 'package:pp_8/services/service_locator.dart';
import 'package:pp_8/theme/custom_colors.dart';
import 'package:pp_8/widgets/components/tooltip_view.dart';
import 'package:pp_8/widgets/modules/main/converter/view/converter_view.dart';
import 'package:pp_8/widgets/modules/main/crypto/view/crypto_view.dart';
import 'package:pp_8/widgets/modules/main/news/views/news_view.dart';
import 'package:pp_8/widgets/modules/main/home/views/home_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final _databaseService = GetIt.instance<DatabaseService>();
  var _currentModule = Module.home;

  late var _seenTooltip;

  final _bottomNavigationItems = [
    _BottomNavItem(
      label: 'Home',
      icon: Assets.icons.home,
      module: Module.home,
    ),
    _BottomNavItem(
        label: 'News', icon: Assets.icons.exchanger, module: Module.exchanger),
    _BottomNavItem(
        label: 'Crypto', icon: Assets.icons.crypto, module: Module.crypto),
    _BottomNavItem(
        label: 'Converter',
        icon: Assets.icons.converter,
        module: Module.converter)
  ];

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    ServiceLocator.loadRepositories();
    setState(
      () => _seenTooltip =
          _databaseService.get(DatabaseKeys.seenTooltip) ?? false,
    );
  }

  void _selectModule(Module module) => setState(() => _currentModule = module);

  void _dismissTooltip() {
    setState(() => _seenTooltip = true);
    _databaseService.put(DatabaseKeys.seenTooltip, true);
  }

  @override
  Widget build(BuildContext context) {
    return TooltipView(
      dissmiss: _dismissTooltip,
      isActive: !_seenTooltip,
      child: Scaffold(
        bottomNavigationBar: Material(
          elevation: 5,
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                _bottomNavigationItems.length,
                (index) => _BottomNavItemWidget(
                  onPressed: () =>
                      _selectModule(_bottomNavigationItems[index].module),
                  isActive:
                      _bottomNavigationItems[index].module == _currentModule,
                  bottomNavItem: _bottomNavigationItems[index],
                ),
              ),
            ),
          ),
        ),
        body: switch (_currentModule) {
          Module.home => const HomeView(),
          Module.exchanger => NewsView(),
          Module.crypto => const CryptoView(),
          Module.converter => const ConverterView(),
        },
      ),
    );
  }
}

class _BottomNavItemWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;
  final _BottomNavItem bottomNavItem;
  const _BottomNavItemWidget({
    required this.onPressed,
    required this.isActive,
    required this.bottomNavItem,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          bottomNavItem.icon.svg(
              color: isActive ? Theme.of(context).colorScheme.primary : null),
          Text(
            bottomNavItem.label,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).extension<CustomColors>()!.disabled,
                ),
          )
        ],
      ),
      onPressed: onPressed,
    );
  }
}

class _BottomNavItem {
  final String label;
  final SvgGenImage icon;
  final Module module;
  _BottomNavItem({
    required this.label,
    required this.icon,
    required this.module,
  });
}

enum Module {
  home,
  exchanger,
  crypto,
  converter,
}
