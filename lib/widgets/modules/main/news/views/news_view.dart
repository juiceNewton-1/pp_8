import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/generated/locale_keys.g.dart';
import 'package:pp_8/models/news.dart';
import 'package:pp_8/routes/route_names.dart';
import 'package:pp_8/widgets/components/news_cover.dart';
import 'package:pp_8/widgets/components/settings_button.dart';
import 'package:pp_8/widgets/modules/main/news/controller/news_controller.dart';

class NewsView extends StatefulWidget {
  NewsView({super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  late final _articlesController = NewsController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.news_title.tr()),
        actions: [
                    SettingsButton(
            callback: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _articlesController,
        builder: (context, value, child) {
          if (value.isLoading) {
            return _LoadingState();
          } else {
            if (value.errorMessage != null) {
              return _ErrorState(
                errorMessage: value.errorMessage!,
                refresh: _articlesController.refresh,
              );
            } else {
              return _LoadedState(
                articles: value.news,
                refresh: _articlesController.refresh,
              );
            }
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
  final String errorMessage;
  final VoidCallback? refresh;
  const _ErrorState({required this.errorMessage, this.refresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
           LocaleKeys.states_error.tr().tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 20),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(Icons.refresh_outlined, size: 30),
            onPressed: refresh,
          ),
        ],
      ),
    );
  }
}

class _LoadedState extends StatelessWidget {
  final List<News> articles;
  final VoidCallback? refresh;
  const _LoadedState({
    required this.articles,
    this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return articles.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                 LocaleKeys.states_error.tr().tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 20),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(Icons.refresh_outlined, size: 30),
                  onPressed: refresh,
                ),
              ],
            ),
          )
        : ListView.separated(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
            ),
            itemBuilder: (context, index) => _NewsTile(
              news: articles[index],
            ),
            separatorBuilder: (context, index) => SizedBox(height: 15),
            itemCount: articles.length,
          );
  }
}

class _NewsTile extends StatelessWidget {
  final News news;
  const _NewsTile({required this.news});

  @override
  Widget build(BuildContext context) {


    return SizedBox(
      height: 70,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.of(context).pushNamed(
          RouteNames.singleNews,
          arguments: news,
        ),
        child: Row(
          children: [
            NewsCover(url: news.imageUrl),
            SizedBox(width: 21),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
