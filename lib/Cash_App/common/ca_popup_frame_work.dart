import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_function.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_page_frame_work_sliver_appbar.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_text_font.dart';

class CaPopupFrameWork extends StatelessWidget {
  const CaPopupFrameWork({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.customSubtitleWidget,
    this.hasPadding = true,
    this.underTitleSpace = true,
    this.aboveTitleSpace = true,
    this.bottomSafeAreaExtraPadding = true,
    this.showCloseButton = false,
    this.icon,
    this.outsideExtraWidget,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? customSubtitleWidget;
  final bool hasPadding;
  final bool underTitleSpace;
  final bool aboveTitleSpace;
  final bool bottomSafeAreaExtraPadding;
  final bool showCloseButton;
  final Widget? icon;
  final Widget? outsideExtraWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          /// 以ObjectPageContent的自定义颜色作为背景
          // color: dynamicPastel(
          //   context,
          //   Theme.of(context).colorScheme.secondaryContainer,
          //   amountDark: 0.3,
          //   amountLight: 0.6,
          // ),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (title != null) SizedBox(height: 17),

                /// IOS标题
                if (Platform.isIOS) ...[
                  Stack(
                    alignment: AlignmentDirectional.topStart,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title != null)
                            Padding(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 18),
                              child: TextFont(
                                // 每一个都大写
                                text: (title ?? ""),
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                maxLines: 5,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (subtitle != null || customSubtitleWidget != null)
                            Padding(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 18),
                              child: customSubtitleWidget ??
                                  TextFont(
                                    text: subtitle ?? "",
                                    fontSize: 14,
                                    maxLines: 5,
                                    textAlign: TextAlign.center,
                                  ),
                            ),
                          if (title != null || subtitle != null)
                            Container(
                              height: 1.5,
                              // color: appStateSettings["materialYou"] == true
                              //     ? Theme.of(context)
                              //         .colorScheme
                              //         .secondaryContainer
                              //     : getColor(context, "canvasContainer"),
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              margin: const EdgeInsetsDirectional.only(
                                  top: 10, bottom: 5),
                            )
                          else
                            const SizedBox(height: 5),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: 10,
                        ),
                        child: icon ?? SizedBox.shrink(),
                      )
                    ],
                  ),
                ],

                /// 主体内容
                Padding(
                  padding: hasPadding
                      ? EdgeInsetsDirectional.symmetric(horizontal: 18)
                      : EdgeInsetsDirectional.zero,
                  child: child,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
