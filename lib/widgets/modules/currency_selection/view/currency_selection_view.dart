import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/routes/route_names.dart';
import 'package:pp_8/widgets/components/app_button.dart';
import 'package:pp_8/widgets/components/currency_uint_tile.dart';
import 'package:pp_8/widgets/modules/currency_selection/controller/currency_selection_controller.dart';

class CurrencySelectionView extends StatefulWidget {
  const CurrencySelectionView({super.key});

  @override
  State<CurrencySelectionView> createState() => _CurrencySelectionViewState();
}

class _CurrencySelectionViewState extends State<CurrencySelectionView> {
  final _currencySelectionController = CurrencySelectionController();

  void _continue() {
    _currencySelectionController.saveCurrencyUint();
    Navigator.of(context).pushReplacementNamed(RouteNames.main);
  }

  @override
  void dispose() {
    _currencySelectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: ValueListenableBuilder(
          valueListenable: _currencySelectionController,
          builder: (context, value, child) =>
              value.isLoading || value.errorMessage != null
                  ? SizedBox.shrink()
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: AppButton(
                        label: 'Continue',
                        onPressed: _continue,
                      ),
                    ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: Text('Select default currency'),
        ),
        body: ValueListenableBuilder(
          valueListenable: _currencySelectionController,
          builder: (context, value, child) {
            if (value.isLoading) {
              return _LoadingState();
            } else if (value.errorMessage != null) {
              return _ErrorState(refresh: _currencySelectionController.refresh);
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
                        _currencySelectionController.selectCurrency(currency),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemCount: value.currencyUints.length,
              );
            }
          },
        ));
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
