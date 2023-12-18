import 'package:flutter/cupertino.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/routes/route_names.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Assets.icons.settings.svg(),
      onPressed: () => Navigator.of(context).pushNamed(RouteNames.settings),
    );
  }
}
