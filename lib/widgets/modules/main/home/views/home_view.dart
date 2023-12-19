import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/generated/locale_keys.g.dart';
import 'package:pp_8/models/currencies/crypto_currency.dart';
import 'package:pp_8/models/currencies/currency.dart';
import 'package:pp_8/models/currencies/forex_currency.dart';
import 'package:pp_8/routes/route_names.dart';
import 'package:pp_8/widgets/components/app_button.dart';
import 'package:pp_8/widgets/components/currency_tile.dart';
import 'package:pp_8/widgets/components/settings_button.dart';
import 'package:pp_8/widgets/modules/main/home/controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _homeController = HomeController();

  void _switchMode(HomeMode mode) => _homeController.switchMode(mode);

  void _showDeleteDialog(Currency currency) => showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          insetPadding: EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LocaleKeys.home_dialog_title.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _DeleteYesButton(
                        delete: () {
                          if (currency is CryptoCurrency) {
                            _homeController.deleteCrypto(currency);
                          } else if (currency is ForexCurrency) {
                            _homeController.deleteForex(currency);
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(child: _DeleteNoButton()),
                  ],
                )
              ],
            ),
          ),
        ),
      );

  Future<void> _navigateToAddCurrencies() async {
    final arguments =
        await Navigator.of(context).pushNamed(RouteNames.addCurrency) as (
      List<CryptoCurrency>?,
      List<ForexCurrency>?
    )?;
    if (arguments != null) {
      if (arguments.$1 != null) {
        _homeController.updateCrypto(arguments.$1!);
      }
      if (arguments.$2 != null) {
        _homeController.updateForex(arguments.$2!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _homeController,
        builder: (context, value, child) => value.isLoading
            ? SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppButton(
                  label: LocaleKeys.home_add_action.tr(),
                  onPressed: _navigateToAddCurrencies,
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text(LocaleKeys.home_title.tr()),
        actions: [
          SettingsButton(
            callback: () {
              setState(() {});
            },
          )
        ],
        leadingWidth: 90,
        leading: ValueListenableBuilder(
          valueListenable: _homeController,
          builder: (context, value, child) => CupertinoButton(
            padding: EdgeInsets.zero,
            child: FittedBox(
              child: Text(
                value.mode == HomeMode.none
                    ? LocaleKeys.home_edit.tr()
                    : LocaleKeys.home_done.tr(),
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            onPressed: () => _switchMode(
              value.mode == HomeMode.edit ? HomeMode.none : HomeMode.edit,
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: _homeController,
        builder: (context, value, child) {
          if (value.isLoading) {
            return Center(
              child: CupertinoActivityIndicator(radius: 10),
            );
          } else {
            if (value.cryptoCurrencies.isEmpty &&
                value.forexCurrencies.isEmpty) {
              return _EmptyState();
            } else {
              final isEditMode = value.mode == HomeMode.edit;
              return SingleChildScrollView(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (value.forexCurrencies.isNotEmpty) ...[
                      Text(
                        LocaleKeys.home_exchange_rates.tr(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 10),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => ForexCurrencyTile(
                          currency: value.forexCurrencies[index],
                          isEditMode: isEditMode,
                          delete: _showDeleteDialog,
                          currencySign: _homeController.currencyUint.sign ?? '',
                        ),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemCount: value.forexCurrencies.length,
                      )
                    ],
                    if (value.cryptoCurrencies.isNotEmpty) ...[
                      SizedBox(height: 32),
                      Text(
                        LocaleKeys.home_cryptocurrency.tr(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 10),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => CryptoCurrencyTile(
                          currency: value.cryptoCurrencies[index],
                          delete: _showDeleteDialog,
                          isEditMode: isEditMode,
                          currencySign: _homeController.currencyUint.sign ?? '',
                        ),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemCount: value.cryptoCurrencies.length,
                      )
                    ]
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        LocaleKeys.states_empty.tr(),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _DeleteYesButton extends StatelessWidget {
  final VoidCallback delete;
  const _DeleteYesButton({required this.delete});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: delete,
      padding: EdgeInsets.zero,
      child: Container(
        alignment: Alignment.center,
        height: 52,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          LocaleKeys.home_dialog_yes.tr(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}

class _DeleteNoButton extends StatelessWidget {
  const _DeleteNoButton();

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: Navigator.of(context).pop,
      padding: EdgeInsets.zero,
      child: Container(
        alignment: Alignment.center,
        height: 52,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          LocaleKeys.home_dialog_no.tr(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
