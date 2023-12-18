import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/helpers/datetime_helper.dart';
import 'package:pp_8/models/news.dart';
import 'package:pp_8/theme/custom_colors.dart';
import 'package:pp_8/widgets/components/news_cover.dart';

class SingleNewsView extends StatelessWidget {
  final News news;
  const SingleNewsView({super.key, required this.news});

  factory SingleNewsView.ceate(BuildContext context) {
    final news =
        ModalRoute.of(context)!.settings.arguments as News;
    return SingleNewsView(news: news);
  }

  @override
  Widget build(BuildContext context) {
    final hours = DateTimeHelper.getHours(news.date);
    final minutes = DateTimeHelper.getMinutes(news.date);
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
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
            SizedBox(height: 20),
            Text(
              'Today, ${hours}:$minutes',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w400,
                    color:
                        Theme.of(context).extension<CustomColors>()!.disabled,
                  ),
            ),
            SizedBox(height: 22),
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
