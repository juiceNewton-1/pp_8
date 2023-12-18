import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/widgets/components/app_button.dart';
import 'package:pp_8/widgets/components/currency_uint_tile.dart';
import 'package:pp_8/widgets/modules/settings/change_currency/controller/change_currency_controller.dart';

class ChangeCurrencyView extends StatefulWidget {
  const ChangeCurrencyView({super.key});

  @override
  State<ChangeCurrencyView> createState() => _ChangeCurrencyViewState();
}

class _ChangeCurrencyViewState extends State<ChangeCurrencyView> {
  final _changeCurrencyController = ChangeCurrencyController();

  void _change() {
    _changeCurrencyController.changeCurrency();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: AppButton(
          label: 'Chnage',
          onPressed: _change,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: Navigator.of(context).pop,
          child: Assets.icons.chevronLeft.svg(),
        ),
        title: Text('Change currency'),
      ),
      body: ValueListenableBuilder(
        valueListenable: _changeCurrencyController,
        builder: (context, value, child) {
          if (value.isLoading) {
            return _LoadingState();
          } else if (value.errorMessage != null) {
            return _ErrorState(refresh: _changeCurrencyController.refresh);
          } else {
            return ListView.separated(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 80),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final currency = value.currencyUints[index];
                return CurrencyUintTile(
                  currency: currency,
                  isSelected: currency == value.selectedCurrency,
                  onPressed: () =>
                      _changeCurrencyController.selectCurrency(currency),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemCount: value.currencyUints.length,
            );
          }
        },
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(radius: 10),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback refresh;
  const _ErrorState({required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Some error has occured.\nPlease, try again',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(Icons.replay_circle_filled_rounded),
            onPressed: refresh,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ],
      ),
    );
  }
}
