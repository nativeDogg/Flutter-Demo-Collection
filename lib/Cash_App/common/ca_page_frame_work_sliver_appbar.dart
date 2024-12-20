import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_animate.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_enum.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_text_font.dart';

class CaPageFrameWorkSliverAppbar extends StatelessWidget {
  CaPageFrameWorkSliverAppbar({
    super.key,
    required this.appBarBackgroundColor,
    this.appBarTitle = 'Transaction Details',
    this.bottom,
    this.onBackButton,
    this.animationControllerOpacity,
  });
  final Color? appBarBackgroundColor;
  final String appBarTitle;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBackButton;

  /// 动画透明度
  final AnimationController? animationControllerOpacity;

  @override
  Widget build(BuildContext context) {
    Widget appBar = SliverAppBar(
      backgroundColor: appBarBackgroundColor,
      surfaceTintColor: Colors.transparent,
      bottom: bottom,
      shadowColor: Platform.isIOS
          ? Colors.transparent
          : Theme.of(context).shadowColor.withAlpha(130),
      leading: IconButton(
        onPressed: () {
          if (onBackButton != null) {
            onBackButton!();
          } else
            Navigator.of(context).maybePop();
        },
        icon: Icon(
            Platform.isIOS
                ? Icons.chevron_left_rounded
                : Icons.arrow_back_rounded,
            color: Colors.black),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          /// 大写
          String titleString = appBarTitle.capitalizeFirst;
          return FlexibleSpaceBar(
            title: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Transform.translate(
                offset: Offset(
                  0,
                  MediaQuery.sizeOf(context).width > 750 ? -1.3 : -3.3,
                ),
                child: Transform.scale(
                  scale: 0.8,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: TextFont(
                      text: titleString,
                      fontSize:
                          MediaQuery.sizeOf(context).width > 750 ? 20 : 18,
                      fontWeight: FontWeight.bold,
                      textColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                      textAlign: TextAlign.center,
                      // textColor: textColor == null
                      //     ? Theme.of(context).colorScheme.onSecondaryContainer
                      //     : textColor,
                      // textAlign: centeredTitleWithDefault
                      //     ? TextAlign.center
                      //     : TextAlign.left,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    return SliverPadding(
      padding: EdgeInsetsDirectional.only(bottom: 0),
      sliver: appBar,
    );
  }
}
