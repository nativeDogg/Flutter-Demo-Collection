// 公用组件
import 'dart:math';

import 'package:flutter/material.dart';

/// 缓存交易类型图标组件
class CacheCategoryIcon extends StatefulWidget {
  const CacheCategoryIcon({
    required this.iconName,
    required this.size,
    super.key,
  });
  final String iconName;
  final double size;
  @override
  State<CacheCategoryIcon> createState() => _CacheCategoryIconState();
}

class _CacheCategoryIconState extends State<CacheCategoryIcon> {
  late Image image;

  @override
  void initState() {
    super.initState();
    image = Image.asset(
      "assets/categories/${widget.iconName}",
      width: widget.size,
    );
  }

  @override
  void didUpdateWidget(covariant CacheCategoryIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.iconName != oldWidget.iconName ||
        widget.size != oldWidget.size) {
      setState(() {
        image = Image.asset(
          "assets/categories/${widget.iconName}",
          width: widget.size,
        );
      });
    }
  }

  @override
  void didChangeDependencies() {
    precacheImage(image.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return image;
  }
}

/// 数字动画组件
bool isWholeNumber(num value) => value is int || value == value.roundToDouble();

class CountNumber extends StatefulWidget {
  const CountNumber({
    Key? key,
    required this.count,
    required this.textBuilder,
    this.fontSize = 16,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeOutQuint,
    this.initialCount = 0,
    this.decimals,
    this.lazyFirstRender = true,
  }) : super(key: key);

  final double count;
  final Widget Function(double amount) textBuilder;
  final double fontSize;
  final Duration duration;
  final Curve curve;
  final double initialCount;
  final int? decimals;
  final bool lazyFirstRender;

  @override
  State<CountNumber> createState() => _CountNumberState();
}

class _CountNumberState extends State<CountNumber> {
  late double previousAmount = widget.initialCount;
  late bool lazyFirstRender = widget.lazyFirstRender;

  @override
  Widget build(BuildContext context) {
    // if (appStateSettings["numberCountUpAnimation"] == false ||
    //     appStateSettings["batterySaver"] == true) {
    //   previousAmount = widget.count;
    //   return widget.textBuilder(widget.count);
    // }

    int decimals = 0;

    if (isWholeNumber(
        double.parse(widget.count.toStringAsFixed(widget.decimals ?? 2)))) {
      decimals = 0;
    } else {
      int currentSelectedDecimals = 2;

      /// 如果存在小数点
      if (widget.count.toString().contains('.')) {
        decimals = ((widget.decimals ?? currentSelectedDecimals) > 2
            ? widget.count.toString().split('.')[1].length <
                    (widget.decimals ?? currentSelectedDecimals)
                ? widget.count.toString().split('.')[1].length
                : (widget.decimals ?? currentSelectedDecimals)
            : (widget.decimals ?? currentSelectedDecimals));
      } else {
        decimals = (widget.decimals ?? currentSelectedDecimals);
      }
    }

    if (lazyFirstRender && widget.initialCount == widget.count) {
      lazyFirstRender = false;
      return widget.textBuilder(
        double.parse((widget.count).toStringAsFixed(decimals)),
      );
    }

    Widget builtWidget = TweenAnimationBuilder<int>(
      tween: IntTween(
        begin: (double.parse((previousAmount).toStringAsFixed(decimals)) *
                pow(10, decimals))
            .round(),
        end: (double.parse((widget.count).toStringAsFixed(decimals)) *
                pow(10, decimals))
            .round(),
      ),
      duration: widget.duration,
      curve: widget.curve,
      builder: (BuildContext context, int animatedCount, Widget? child) {
        return widget.textBuilder(
          animatedCount / pow(10, decimals).toDouble(),
        );
      },
    );

    previousAmount = widget.count;
    return builtWidget;
  }
}
