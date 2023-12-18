import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/generated/locale_keys.g.dart';
import 'package:pp_8/models/news.dart';
import 'package:pp_8/widgets/components/news_cover.dart';

class SingleNewsView extends StatelessWidget {
  final News news;
  const SingleNewsView({super.key, required this.news});

  factory SingleNewsView.ceate(BuildContext context) {
    final news = ModalRoute.of(context)!.settings.arguments as News;
    return SingleNewsView(news: news);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.news_title.tr()),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Assets.icons.chevronLeft.svg(),
          onPressed: Navigator.of(context).pop,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 335 / 188,
              child: NewsCover(url: news.imageUrl),
            ),
            SizedBox(height: 18),
            Text(
              news.title,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontSize: 18),
            ),
            SizedBox(height: 25),
            Text(
              news.body,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
