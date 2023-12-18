import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/models/currencies/crypto_currency.dart';
import 'package:pp_8/models/currencies/forex_currency.dart';
import 'package:pp_8/theme/custom_colors.dart';

class CryptoCurrencyTile extends StatelessWidget {
  final CryptoCurrency currency;
  final String currencySign;
  final VoidCallback? onPressed;
  final void Function(CryptoCurrency)? delete;
  final bool isEditMode;
  const CryptoCurrencyTile({
    super.key,
    required this.currency,
    this.onPressed,
    this.delete,
    this.isEditMode = false,
    required this.currencySign,
  });

  @override
  Widget build(BuildContext context) {
    final isNegative = currency.change.isNegative;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surface,
        ),
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
                  Text(currency.symbol),
                ],
              ),
            ),
            if (isEditMode)
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Assets.icons.delete.svg(),
                onPressed: () => delete?.call(currency),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${currency.price.toStringAsFixed(2)}$currencySign',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '${!isNegative ? '+' : ''}${(currency.price * (currency.change / 100)).toStringAsFixed(2)}$currencySign (${!isNegative ? '+' : ''}${currency.change}%)',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: isNegative
                              ? Theme.of(context).extension<CustomColors>()!.red
                              : Theme.of(context)
                                  .extension<CustomColors>()!
                                  .green,
                        ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}

class ForexCurrencyTile extends StatelessWidget {
  final ForexCurrency currency;
  final String currencySign;
  final VoidCallback? onPressed;
  final void Function(ForexCurrency)? delete;
  final bool isEditMode;
  const ForexCurrencyTile({
    super.key,
    required this.currency,
    this.onPressed,
    this.delete,
    this.isEditMode = false,
    required this.currencySign,
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
        ),
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
              child: currency.flag.svg(width: 37, height: 37),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currency.name,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(currency.code),
                ],
              ),
            ),
            if (isEditMode)
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Assets.icons.delete.svg(),
                onPressed: () => delete?.call(currency),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${double.parse(currency.rate).toStringAsFixed(2)} $currencySign',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
