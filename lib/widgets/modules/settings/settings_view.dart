import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/routes/route_names.dart';
import 'package:pp_8/services/repositories/currency_uint_repository.dart';
import 'package:pp_8/widgets/components/app_button.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _currencyUintRepository = GetIt.instance<CurrencyUintRepository>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Assets.icons.chevronLeft.svg(),
          onPressed: Navigator.of(context).pop,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 16, right: 16, top: 10),
        child: Column(
          children: [
            _SettingsTile(
              label: 'Write to us',
              onPressed: () =>
                  Navigator.of(context).pushNamed(RouteNames.writeUs),
            ),
            SizedBox(height: 10),
            _SettingsTile(
              label: 'Rate the app',
              onPressed: () => showDialog(
                context: context,
                builder: (context) => _RatingDialog(),
              ),
            ),
            SizedBox(height: 10),
            _SettingsTile(
              label: 'Share app',
              onPressed: () {},
            ),
            SizedBox(height: 10),
            _SettingsTile(
              label: 'Language',
              onPressed: () =>
                  Navigator.of(context).pushNamed(RouteNames.language),
              helperText: 'English',
            ),
            SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: _currencyUintRepository,
              builder: (context, value, child) => _SettingsTile(
                label: 'Default currency',
                onPressed: () =>
                    Navigator.of(context).pushNamed(RouteNames.changeCurrency),
                helperText: _currencyUintRepository.value.currencyUint!.symbol,
              ),
            ),
            SizedBox(height: 10),
            _SettingsTile(
              label: 'World Resources',
              onPressed: () =>
                  Navigator.of(context).pushNamed(RouteNames.resources),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String label;
  final String? helperText;
  final VoidCallback onPressed;
  const _SettingsTile({
    required this.label,
    this.helperText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.only(left: 24, right: 20, top: 19, bottom: 19),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Row(
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
            Spacer(),
            if (helperText != null)
              Text(helperText!, style: Theme.of(context).textTheme.bodySmall),
            SizedBox(width: 8),
            Assets.icons.chevronRight.svg()
          ],
        ),
      ),
    );
  }
}

class _RatingDialog extends StatefulWidget {
  const _RatingDialog();

  @override
  State<_RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<_RatingDialog> {
  var _currentRating = 5;

  void _updateRating(double rating) =>
      setState(() => _currentRating = rating.toInt());

  void _rate() {
    //TODO: Rate app
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.only(left: 18, right: 18, top: 16, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  child: Assets.icons.close.svg(),
                  onTap: Navigator.of(context).pop,
                )
              ],
            ),
            Text('Rate our app',
                style: Theme.of(context).textTheme.displayMedium),
            SizedBox(height: 12),
            Text(
              'your feedback will inspire us to\ncreate even cooler applications',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 12),
            RatingBar.builder(
              initialRating: _currentRating.toDouble(),
              itemBuilder: (context, index) => Icon(
                Icons.star_purple500_outlined,
                color: Color(0xFFFFBF1A),
              ),
              onRatingUpdate: _updateRating,
              itemSize: 50,
              maxRating: 5,
            ),
            SizedBox(height: 12),
            AppButton(
              label: 'Rate',
              onPressed: _rate,
            )
          ],
        ),
      ),
    );
  }
}
