import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsCover extends StatelessWidget {
  final String url;
  final double width;
  final double heigth;
  const NewsCover({
    super.key,
    required this.url,
    this.width = 70,
    this.heigth = 70,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        width: width,
        height: heigth,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
            frame != null
                ? child
                : Container(
                    color: Theme.of(context).colorScheme.surface,
                    width: width,
                    height: heigth,
                  ),
        loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null
                ? child
                : Container(
                    alignment: Alignment.center,
                    color: Theme.of(context).colorScheme.surface,
                    width: width,
                    height: heigth,
                    child: CupertinoActivityIndicator(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
        errorBuilder: (context, error, stackTrace) => Container(
          color: Theme.of(context).colorScheme.surface,
          width: width,
          height: heigth,
        ),
      ),
    );
  }
}
