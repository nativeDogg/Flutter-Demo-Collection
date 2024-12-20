import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class OpenContainerNavigation extends StatelessWidget {
  OpenContainerNavigation({
    Key? key,
    required this.openPage,
    required this.button,
    this.closedColor,
    this.borderRadius = 250,
    this.closedElevation,
    this.customBorderRadius,
    this.onClosed,
    this.onOpen,
  }) : super(key: key);

  /// 点击打开的页面
  final Widget openPage;
  final Widget Function(VoidCallback openFunc) button;
  final Color? closedColor;
  final double borderRadius;
  final double? closedElevation;
  final BorderRadiusGeometry? customBorderRadius;
  final VoidCallback? onClosed;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    // 常规状态下
    return OpenContainer(
      onClosed: (_) async {
        if (onClosed != null) onClosed!();
      },
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return openPage;
        // return Container();
      },
      tappable: false,
      transitionDuration: Platform.isIOS
          ? const Duration(milliseconds: 475)
          : const Duration(milliseconds: 400),
      closedElevation: closedElevation ?? 0,
      openColor: closedColor ?? Colors.transparent,
      closedColor: closedColor ?? Colors.transparent,
      openElevation: 0,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return button(() {
          if (onOpen != null) onOpen!();
          openContainer();
        });
      },
      closedShape: RoundedRectangleBorder(
        borderRadius: customBorderRadius ??
            BorderRadiusDirectional.all(
              Radius.circular(borderRadius),
            ),
      ),
    );
  }
}
