import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/models/currency_uint.dart';


class CurrencyUintTile extends StatelessWidget {
  final CurrencyUint currency;
  final bool isSelected;
  final VoidCallback? onPressed;
  const CurrencyUintTile({
    required this.currency,
    required this.isSelected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.only(left: 26, right: 18, top: 15, bottom: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: Theme.of(context).colorScheme.primary)
              : null,
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currency.name ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    currency.symbol ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
            ),
            Spacer(),
            if (isSelected) Assets.icons.selected.svg()
          ],
        ),
      ),
    );
  }
}