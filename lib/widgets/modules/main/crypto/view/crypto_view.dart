import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/models/currencies/crypto_currency.dart';
import 'package:pp_8/widgets/components/app_text_field.dart';
import 'package:pp_8/widgets/components/currency_tile.dart';
import 'package:pp_8/widgets/components/settings_button.dart';
import 'package:pp_8/widgets/modules/main/crypto/controller/crypto_controller.dart';

class CryptoView extends StatefulWidget {
  const CryptoView({super.key});

  @override
  State<CryptoView> createState() => _CryptoViewState();
}

class _CryptoViewState extends State<CryptoView> {
  final _cryptoController = CryptoController();
  final _searchController = TextEditingController();

  var _searchQuery = '';

  @override
  void dispose() {
    _cryptoController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchUpdate(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto'),
        actions: [SettingsButton()],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 38,
              child: ValueListenableBuilder(
                valueListenable: _cryptoController,
                builder: (context, value, child) => AppTextField(
                  backgroundColor: Color(0xFFDFDEE5).withOpacity(0.93),
                  placeholder: 'Search',
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
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _cryptoController,
              builder: (context, value, child) {
                if (value.isLoading) {
                  return _LoadingState();
                } else if (value.errorMessage != null) {
                  return _ErrorState(refresh: _cryptoController.refresh);
                } else {
                  final filteredCurrencies = _searchQuery.isEmpty
                      ? value.currencies
                      : value.currencies.where(
                          (currency) {
                            final lowerName = currency.name.toLowerCase();
                            final lowerQuery = _searchQuery.toLowerCase();
                            final lowerSymbol = currency.symbol.toLowerCase();
                            return lowerName.startsWith(lowerQuery) ||
                                lowerName.contains(lowerQuery) ||
                                lowerSymbol.startsWith(lowerQuery);
                          },
                        );
                  return _LoadedState(
                    currencies: filteredCurrencies.toList(),
                    currencySymbol: _cryptoController.currencyUint.sign ?? '-',
                  );
                }
              },
            ),
          )
        ],
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

class _LoadedState extends StatelessWidget {
  final List<CryptoCurrency> currencies;
  final String currencySymbol;
  const _LoadedState({required this.currencies, required this.currencySymbol});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 20),
      itemBuilder: (context, index) => CryptoCurrencyTile(
        currency: currencies[index],
        currencySign: currencySymbol,
      ),
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemCount: currencies.length,
    );
  }
}
