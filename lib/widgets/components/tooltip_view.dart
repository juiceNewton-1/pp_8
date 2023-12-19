import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/generated/locale_keys.g.dart';
import 'package:pp_8/widgets/components/wave_painter.dart';

class TooltipView extends StatefulWidget {
  final VoidCallback? dissmiss;
  final bool isActive;
  final Widget child;
  const TooltipView({
    super.key,
    this.dissmiss,
    required this.isActive,
    required this.child,
  });

  @override
  State<TooltipView> createState() => _TooltipViewState();
}

class _TooltipViewState extends State<TooltipView>
    with SingleTickerProviderStateMixin {
  late final Animation _waveAnimation;
  late final AnimationController _waveController;
  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    if (widget.isActive) {
      _waveController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
      );

      _waveAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _waveController,
          curve: Curves.easeInOut,
        ),
      );

      _waveAnimation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _waveController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _waveController.forward();
        }
      });

      _waveController.forward();
    }
  }

  int _currentIndex = 0;

  final _tooltipItems = [
    _TooltipItem(
        icon: Assets.icons.home, label: LocaleKeys.bottom_menu_home.tr()),
    _TooltipItem(
        icon: Assets.icons.exchanger, label: LocaleKeys.bottom_menu_news.tr()),
    _TooltipItem(
        icon: Assets.icons.crypto, label: LocaleKeys.bottom_menu_crypto.tr()),
    _TooltipItem(
        icon: Assets.icons.converter,
        label: LocaleKeys.bottom_menu_converter.tr()),
  ];

  void _progress() {
    if (_currentIndex == 3) {
      widget.dissmiss?.call();
    } else {
      _waveController.reset();
      setState(() => _currentIndex++);
    }
  }

  void _back() => setState(() => _currentIndex--);

  String _getTooltipText(int index) {
    switch (index) {
      case 0:
        return LocaleKeys.tooltip_text1.tr();
      case 1:
        return LocaleKeys.tooltip_text2.tr();
      case 2:
        return LocaleKeys.tooltip_text3.tr();
      default:
        return LocaleKeys.tooltip_text4.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          if (widget.isActive) ...[
            Container(
              color: Colors.black.withOpacity(0.5),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentIndex != 0)
                        _BackButton(back: _back)
                      else
                        SizedBox.shrink(),
                      _ForwardButton(
                        isLastStep: _currentIndex == 3,
                        progress: _progress,
                      ),
                    ],
                  ),
                  const Spacer(flex: 2),
                  SizedBox(
                    height: 40,
                    child: _currentIndex == 0
                        ? Text(
                            LocaleKeys.tooltip_headline.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                          )
                        : null,
                  ),
                  Text(
                    _getTooltipText(_currentIndex),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Theme.of(context).colorScheme.surface),
                  ),
                  const SizedBox(height: 12),
                  const Spacer(),
                  SizedBox(
                    height: 72,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                        _tooltipItems.length,
                        (index) => AnimatedBuilder(
                          animation: _waveAnimation,
                          builder: (context, child) => _TooltipBottomItem(
                            icon: _tooltipItems[index].icon,
                            isActive: index == _currentIndex,
                            label: _tooltipItems[index].label,
                            animationValue: _waveAnimation.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _back,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _progress,
                  ),
                )
              ],
            ),
          ]
        ],
      ),
    );
  }
}

class _ForwardButton extends StatelessWidget {
  final VoidCallback? progress;
  final bool isLastStep;
  const _ForwardButton({
    this.progress,
    required this.isLastStep,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: progress,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isLastStep
                ? LocaleKeys.tooltip_start.tr().toUpperCase()
                : LocaleKeys.tooltip_next.tr().toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Theme.of(context).colorScheme.surface),
          ),
          Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.surface,
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback? back;
  const _BackButton({this.back});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: back,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chevron_left,
            color: Theme.of(context).colorScheme.surface,
          ),
          Text(
            LocaleKeys.tooltip_back.tr().toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Theme.of(context).colorScheme.surface),
          )
        ],
      ),
    );
  }
}

class _TooltipBottomItem extends StatelessWidget {
  final SvgGenImage icon;
  final bool isActive;
  final String label;
  final double animationValue;
  const _TooltipBottomItem({
    required this.icon,
    required this.isActive,
    required this.label,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: null,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPaint(
            painter: isActive
                ? WavePainter(
                    animationValue: animationValue,
                    color: Theme.of(context).colorScheme.surface)
                : null,
            child: icon.svg(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                ),
          )
        ],
      ),
    );
  }
}

class _TooltipItem {
  final SvgGenImage icon;
  final String label;

  _TooltipItem({
    required this.icon,
    required this.label,
  });
}
