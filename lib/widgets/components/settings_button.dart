import 'package:flutter/cupertino.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/routes/route_names.dart';

class SettingsButton extends StatelessWidget {
  final VoidCallback callback;
  const SettingsButton({
    super.key,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Assets.icons.settings.svg(),
      onPressed: () async{
        await Navigator.of(context).pushNamed(RouteNames.settings);
        callback.call();
      },
    );
  }
}
