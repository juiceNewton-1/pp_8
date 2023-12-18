import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/models/currencies/crypto_currency.dart';
import 'package:pp_8/models/currencies/forex_currency.dart';
import 'package:pp_8/theme/custom_colors.dart';
import 'package:pp_8/widgets/components/app_button.dart';
import 'package:pp_8/widgets/modules/main/home/controllers/add_currency_controller.dart';

class AddCurrencyView extends StatefulWidget {
  const AddCurrencyView({super.key});

  @override
  State<AddCurrencyView> createState() => _AddCurrencyViewState();
}

class _AddCurrencyViewState extends State<AddCurrencyView> {
  final _addCurrencyController = AddCurrencyController();

  void _add() {
    Navigator.of(context).pop(
      (
        _addCurrencyController.value.selectedCrypto,
        _addCurrencyController.value.selectedForex
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: AppButton(label: 'Add', onPressed: _add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text('Add currency'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Assets.icons.chevronLeft.svg(),
          onPressed: Navigator.of(context).pop,
        ),
      ),
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: _addCurrencyController,
            builder: (context, value, child) => _SegmentSelectionPanel(
              segment: value.segment,
              onLeftPressed: () =>
                  _addCurrencyController.switchSegment(Segment.forex),
              onRigthPressed: () =>
                  _addCurrencyController.switchSegment(Segment.crypto),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _addCurrencyController,
              builder: (context, value, child) {
                switch (value.segment) {
                  case Segment.crypto:
                    if (value.isCryptoLoading) {
                      return _LoadingState();
                    } else if (value.cryptoError != null) {
                      return _ErrorState(
                        refresh: _addCurrencyController.refreshCrypto,
                      );
                    } else {
                      return _Crypto(
                        currencies: value.cryptoCurrencies,
                        isActive: _addCurrencyController.isCryptoSelected,
                        onPressed: (currency) {
                          if (_addCurrencyController
                              .isCryptoSelected(currency)) {
                            _addCurrencyController.unselectCrypto(currency);
                          } else {
                            _addCurrencyController.selectCrypto(currency);
                          }
                        },
                      );
                    }

                  case Segment.forex:
                    if (value.isForexLoading) {
                      return _LoadingState();
                    } else if (value.forexError != null) {
                      return _ErrorState(
                          refresh: _addCurrencyController.refreshForex);
                    } else {
                      return _Forex(
                        currencies: value.forexCurrencies,
                        isActive: _addCurrencyController.isForexSelected,
                        onPressed: (currency) {
                          if (_addCurrencyController
                              .isForexSelected(currency)) {
                            _addCurrencyController.unselectForex(currency);
                          } else {
                            _addCurrencyController.selectForex(currency);
                          }
                        },
                      );
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentSelectionPanel extends StatelessWidget {
  final Segment segment;
  final VoidCallback onLeftPressed;
  final VoidCallback onRigthPressed;
  const _SegmentSelectionPanel({
    required this.segment,
    required this.onLeftPressed,
    required this.onRigthPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SegmentButton(
            name: 'Currency',
            onPressed: onLeftPressed,
            isActive: segment == Segment.forex,
          ),
        ),
        Expanded(
          child: _SegmentButton(
            name: 'CryptoCurrency',
            onPressed: onRigthPressed,
            isActive: segment == Segment.crypto,
          ),
        )
      ],
    );
  }
}

class _Crypto extends StatelessWidget {
  final List<CryptoCurrency> currencies;
  final bool Function(CryptoCurrency) isActive;
  final void Function(CryptoCurrency) onPressed;
  const _Crypto({
    required this.currencies,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
        itemBuilder: (context, index) => _CryptoCurrencyTile(
          onPressed: () => onPressed.call(currencies[index]),
          isActive: isActive.call(currencies[index]),
          currency: currencies[index],
        ),
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: currencies.length,
      ),
    );
  }
}

class _Forex extends StatelessWidget {
  final List<ForexCurrency> currencies;
  final bool Function(ForexCurrency) isActive;
  final void Function(ForexCurrency) onPressed;
  const _Forex({
    required this.currencies,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
        itemBuilder: (context, index) => _ForexCurrencyTile(
          onPressed: () => onPressed.call(currencies[index]),
          isActive: isActive.call(currencies[index]),
          currency: currencies[index],
        ),
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: currencies.length,
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

class _SegmentButton extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;
  final bool isActive;
  const _SegmentButton(
      {required this.name, required this.onPressed, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).extension<CustomColors>()!.disabled,
                ),
          ),
          SizedBox(height: 14),
          Divider(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).extension<CustomColors>()!.disabled,
            thickness: isActive ? 2 : 1,
          )
        ],
      ),
    );
  }
}

class _CryptoCurrencyTile extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;
  final CryptoCurrency currency;
  const _CryptoCurrencyTile({
    required this.onPressed,
    required this.isActive,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 16),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.surface,
            border: isActive
                ? Border.all(color: Theme.of(context).colorScheme.primary)
                : null),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).extension<CustomColors>()!.disabled,
              ),
              child: currency.iconUrl.contains('.png')
                  ? Image.network(
                      currency.iconUrl,
                      width: 37,
                      height: 37,
                      errorBuilder: (context, error, stackTrace) => Container(),
                    )
                  : SvgPicture.network(
                      currency.iconUrl,
                      width: 37,
                      height: 37,
                      placeholderBuilder: (context) => Container(),
                    ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    currency.symbol,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context)
                              .extension<CustomColors>()!
                              .disabled,
                        ),
                  ),
                ],
              ),
            ),
            if (isActive) Assets.icons.selected.svg()
          ],
        ),
      ),
    );
  }
}

class _ForexCurrencyTile extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;
  final ForexCurrency currency;
  const _ForexCurrencyTile({
    required this.onPressed,
    required this.isActive,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 16),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.surface,
            border: isActive
                ? Border.all(color: Theme.of(context).colorScheme.primary)
                : null),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).extension<CustomColors>()!.disabled,
              ),
              child: currency.flag.svg(height: 37, width: 37),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    currency.code,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context)
                              .extension<CustomColors>()!
                              .disabled,
                        ),
                  ),
                ],
              ),
            ),
            if (isActive) Assets.icons.selected.svg()
          ],
        ),
      ),
    );
  }
}
