import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/generated/locale_keys.g.dart';
import 'package:pp_8/routes/route_names.dart';
import 'package:pp_8/widgets/components/app_button.dart';
import 'package:pp_8/widgets/components/app_text_field.dart';
import 'package:pp_8/widgets/components/currency_uint_tile.dart';
import 'package:pp_8/widgets/modules/currency_selection/controller/currency_selection_controller.dart';

class CurrencySelectionView extends StatefulWidget {
  const CurrencySelectionView({super.key});

  @override
  State<CurrencySelectionView> createState() => _CurrencySelectionViewState();
}

class _CurrencySelectionViewState extends State<CurrencySelectionView> {
  final _currencySelectionController = CurrencySelectionController();
  final _searchController = TextEditingController();

  var _searchQuery = '';

  void _continue() {
    _currencySelectionController.saveCurrencyUint();
    Navigator.of(context).pushReplacementNamed(RouteNames.main);
  }

  void _handleSearchUpdate(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  void dispose() {
    _currencySelectionController.dispose();
    _searchController.dispose();
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
                        label: LocaleKeys.continue_action.tr(),
                        onPressed: _continue,
                      ),
                    ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: Text(LocaleKeys.currency_change_select.tr()),
        ),
        body: ValueListenableBuilder(
          valueListenable: _currencySelectionController,
          builder: (context, value, child) {
            if (value.isLoading) {
              return _LoadingState();
            } else if (value.errorMessage != null) {
              return _ErrorState(refresh: _currencySelectionController.refresh);
            } else {
              final lowerQuery = _searchQuery.toLowerCase();
              final filteredCurrencies =
                  value.currencyUints.where((currencyUint) {
                final lowerName = currencyUint.name?.toLowerCase() ?? '';
                final lowerSymbol = currencyUint.symbol?.toLowerCase() ?? '';

                return lowerName.contains(lowerQuery) ||
                    lowerName.startsWith(lowerQuery) ||
                    lowerSymbol.contains(lowerQuery) ||
                    lowerSymbol.startsWith(lowerQuery);
              });
              final currencies = filteredCurrencies.isEmpty
                  ? value.currencyUints
                  : filteredCurrencies.toList();
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 38,
                      child: AppTextField(
                        backgroundColor: Color(0xFFDFDEE5).withOpacity(0.93),
                        placeholder: LocaleKeys.crypto_search.tr(),
                        onChanged: _handleSearchUpdate,
                        controller: _searchController,
                        padding: EdgeInsets.only(left: 5, right: 10),
                        enabled: !value.isLoading && value.errorMessage == null,
                        prefix: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.search,
                            size: 20,
                            color: kCupertinoModalBarrierColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 10,
                        bottom: 80,
                      ),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final currency = currencies[index];
                        return CurrencyUintTile(
                          currency: currency,
                          isSelected: currency == value.selectedCurrency,
                          onPressed: () => _currencySelectionController
                              .selectCurrency(currency),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemCount: currencies.length,
                    ),
                  ),
                ],
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
           LocaleKeys.states_error.tr(),
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
