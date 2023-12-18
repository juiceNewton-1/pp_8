import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/generated/locale_keys.g.dart';
import 'package:pp_8/helpers/rate_helper.dart';
import 'package:pp_8/models/currencies/forex_currency.dart';
import 'package:pp_8/theme/custom_colors.dart';
import 'package:pp_8/widgets/components/settings_button.dart';
import 'package:pp_8/widgets/modules/main/converter/controller/converter_controller.dart';

class ConverterView extends StatefulWidget {
  const ConverterView({super.key});

  @override
  State<ConverterView> createState() => _ConverterViewState();
}

class _ConverterViewState extends State<ConverterView> {
  final _converterController = ConverterController();
  final _currencyController = TextEditingController();

  void _clear() {
    _converterController.clear();
    setState(() => _currencyController.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.converter_title.tr()),
        actions: [
                    SettingsButton(
            callback: () {
              setState(() {});
            },
          ),
        ],
        leadingWidth: 90,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(
            LocaleKeys.converter_clear_action.tr(),
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          onPressed: _clear,
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: _converterController,
        builder: (context, value, child) => ListView.separated(
          addAutomaticKeepAlives: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 20),
          itemBuilder: (context, index) {
            final currency = value.currencies[index];
            final isSelected = value.selectedCurrency == currency;
            return _ExchangeCurrencyTile(
              currency: currency,
              onPressed: value.isRatesLoading
                  ? null
                  : () => _converterController.selectCurrency(currency),
              isSelected: isSelected,
              onSubmitted: isSelected ? _converterController.submit : null,
              controller: isSelected ? _currencyController : null,
              rate: isSelected || value.rates.isEmpty
                  ? null
                  : value.rates[min(index, value.rates.length - 1)],
              isRatesLoading: value.isRatesLoading,
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemCount: value.currencies.length,
        ),
      ),
    );
  }
}

class _ExchangeCurrencyTile extends StatelessWidget {
  final ForexCurrency currency;
  final bool isSelected;
  final VoidCallback? onPressed;
  final void Function(String)? onSubmitted;
  final TextEditingController? controller;
  final String? rate;
  final bool isRatesLoading;

  const _ExchangeCurrencyTile({
    required this.currency,
    required this.isSelected,
    required this.onPressed,
    required this.rate,
    required this.isRatesLoading,
    this.onSubmitted,
    this.controller,
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
          border: isSelected
              ? Border.all(color: Theme.of(context).colorScheme.primary)
              : null,
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
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.name,
                    style: Theme.of(context).textTheme.titleMedium,
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
            if (isSelected)
              Expanded(
                child: CupertinoTextField(
                  controller: controller,
                  onSubmitted: onSubmitted,
                  autofocus: true,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.fromBorderSide(BorderSide.none),
                  ),
                  maxLength: 6,
                  padding: EdgeInsets.only(left: 10),
                  placeholder: '0.0',
                  suffix: Text('${currency.symbol}'),
                  placeholderStyle:
                      Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context)
                                .extension<CustomColors>()!
                                .disabled,
                          ),
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.number,
                ),
              )
            else if (isRatesLoading)
              CupertinoActivityIndicator()
            else
              Text(
                '${rate != null ? RateHelper.getFormattedRate(rate!) : '0.0'}${currency.symbol}' ,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color:
                          Theme.of(context).extension<CustomColors>()!.disabled,
                    ),
              )
          ],
        ),
      ),
    );
  }
}
