import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/helpers/constants.dart';
import 'package:pp_8/models/resources/resource.dart';
import 'package:pp_8/models/resources/resource_query.dart';
import 'package:pp_8/theme/custom_colors.dart';
import 'package:pp_8/widgets/modules/settings/resource/controller/resources_controller.dart';

class ResourcesView extends StatefulWidget {
  const ResourcesView({super.key});

  @override
  State<ResourcesView> createState() => _ResourcesViewState();
}

class _ResourcesViewState extends State<ResourcesView> {
  final _resourcesController = ResourcesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Assets.icons.chevronLeft.svg(),
          onPressed: Navigator.of(context).pop,
        ),
        title: Text('World resources'),
      ),
      body: ValueListenableBuilder(
        valueListenable: _resourcesController,
        builder: (context, value, child) {
          if (value.isLoading) {
            return _LoadingState();
          } else if (value.errorMessage != null) {
            return _ErrorState(refresh: _resourcesController.refresh);
          } else {
            return _LoadedState(
              resources: value.resources,
              queries: Constants.reourseQueries,
              currencySign: _resourcesController.currencyUint.sign ?? '' ,
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

class _LoadedState extends StatelessWidget {
  final List<Resource> resources;
  final List<ResourceQuery> queries;
  final String currencySign;
  const _LoadedState(
      {required this.resources,
      required this.queries,
      required this.currencySign});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
      itemBuilder: (context, index) => _ResourceTile(
        resource: resources[index],
        query: queries[index],
        currencySign: currencySign,
      ),
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemCount: resources.length,
    );
  }
}

class _ResourceTile extends StatelessWidget {
  final Resource resource;
  final ResourceQuery query;
  final String currencySign;
  const _ResourceTile({
    required this.resource,
    required this.query,
    required this.currencySign,
  });

  @override
  Widget build(BuildContext context) {
    final startPrice = 1 / resource.open;
    final closePrice = 1 / resource.close;
    final changePercentege = ((closePrice - startPrice) / startPrice) * 100;
    final changePrice = 1 / (closePrice - startPrice);
    return Container(
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
              border: Border.all(
                color: Theme.of(context).extension<CustomColors>()!.disabled,
              ),
            ),
            child: query.icon.image(width: 37, height: 37),
          ),
          SizedBox(width: 8),
          Text(query.name, style: Theme.of(context).textTheme.titleMedium),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${closePrice.toStringAsFixed(2)}$currencySign',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                '${changePrice.toStringAsFixed(3)}$currencySign (${changePercentege.toStringAsFixed(1)}%) ',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: changePrice.isNegative
                          ? Theme.of(context).extension<CustomColors>()!.red
                          : Theme.of(context).extension<CustomColors>()!.green,
                    ),
              )
            ],
          )
        ],
      ),
    );
  }
}
