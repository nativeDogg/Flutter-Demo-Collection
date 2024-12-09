// 单个交易种类item
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_animate.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_function.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_text_font.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_widgets.dart';
import 'package:flutter_demo_collect/Cash_App/model/index.dart';
import 'package:flutter_demo_collect/Cash_App/widgets_common/keep_mixin.dart';

class CaCategoryEntry extends StatelessWidget {
  const CaCategoryEntry({
    super.key,
    required this.category,
    required this.categorySpent,
    required this.totalSpent,
    this.showIncomeExpenseIcons = false,
  });
  final CategoryWithTotalModel category;
  final double categorySpent;
  final double totalSpent;
  final bool showIncomeExpenseIcons;

  Widget _buildCategoryPercentIcon() {
    return _CategoryIconPercent(
      category: category.category,
      percent: (categorySpent / totalSpent).abs() * 100,
      // percentageOffset: appStateSettings["circularProgressRotation"] == true
      //     ? percentageOffset
      //     : 0,
      percentageOffset: 0,
      progressBackgroundColor: const Color(0xFFEBEBEB),
      size: 28,
      insetPadding: 18,
    );
  }

  Widget _buildCategoryPercentLabel() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFont(
                    text: category.category.name,
                    fontSize: 15,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 10),
                Transform.translate(
                  offset: Offset(3, 0),
                  child: Transform.rotate(
                    angle: categorySpent >= 0 ? pi : 0,
                    child: Icon(
                      Icons.arrow_drop_down_outlined,
                      color: showIncomeExpenseIcons
                          ? categorySpent > 0
                              ? Color(0xFF62CA77)
                              : Color(0xFFDA7272)
                          : Colors.black,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFont(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      text: 'RM${category.total.toStringAsFixed(2)}',
                      textColor: showIncomeExpenseIcons && categorySpent != 0
                          ? categorySpent > 0
                              ? Color(0xFF62CA77)
                              : Color(0xFFDA7272)
                          : Colors.black,
                    ),
                    // categoryBudgetLimit == null
                    //     ? SizedBox.shrink()
                    //     : Padding(
                    //         padding:
                    //             const EdgeInsetsDirectional.only(bottom: 1),
                    //         child: TextFont(
                    //           text: " / " +
                    //               convertToMoney(
                    //                   Provider.of<AllWallets>(context),
                    //                   spendingLimit),
                    //           fontSize: 14,
                    //           textColor: isOverspent
                    //               ? overSpentColor ??
                    //                   getColor(context, "expenseAmount")
                    //               : getColor(context, "black").withOpacity(0.3),
                    //         ),
                    //       ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 1,
            ),
            Row(
              children: [
                // Expanded(
                //   child: categoryBudgetLimit != null
                //       ? Padding(
                //           padding: const EdgeInsetsDirectional.only(
                //             top: 3,
                //             end: 13,
                //             bottom: 3,
                //           ),
                //           child: ThinProgress(
                //             backgroundColor: appStateSettings["materialYou"]
                //                 ? Theme.of(context)
                //                     .colorScheme
                //                     .secondaryContainer
                //                 : selected
                //                     ? getColor(context, "white")
                //                     : getColor(context, "lightDarkAccentHeavy"),
                //             color: dynamicPastel(
                //               context,
                //               HexColor(
                //                 category.colour,
                //                 defaultColor:
                //                     Theme.of(context).colorScheme.primary,
                //               ),
                //               inverse: true,
                //               amountLight: 0.1,
                //               amountDark: 0.1,
                //             ),
                //             progress: percentSpent,
                //             dotProgress: todayPercent == null
                //                 ? null
                //                 : (todayPercent ?? 0) / 100,
                //           ),
                //         )
                //       : Builder(
                //           builder: (context) {
                //             String percentString = convertToPercent(
                //               percentSpent * 100,
                //               useLessThanZero: true,
                //             );
                //             String text = percentString +
                //                 " " +
                //                 (isSubcategory
                //                     ? "of-category".tr().toLowerCase()
                //                     : getPercentageAfterText == null
                //                         ? ""
                //                         : getPercentageAfterText!(
                //                             categorySpent));

                //             return TextFont(
                //               text: text,
                //               fontSize: 14,
                //               textColor: selected
                //                   ? getColor(context, "black").withOpacity(0.4)
                //                   : getColor(context, "textLight"),
                //             );
                //           },
                //         ),
                // ),
                Builder(
                  builder: (context) {
                    String percentString = convertToPercent(
                      76,
                      useLessThanZero: true,
                    );

                    return TextFont(
                      text: '76% total',
                      fontSize: 14,
                      textColor: Colors.black.withOpacity(0.4),
                      // textColor: selected
                      //     ? Colors.black.withOpacity(0.4)
                      //     : getColor(context, "textLight"),
                    );
                  },
                ),
                // TextFont(
                //   text: max(transactionCount, 0).toString() +
                //       " " +
                //       (transactionCount == 1
                //           ? "transaction".tr().toLowerCase()
                //           : "transactions".tr().toLowerCase()),
                //   fontSize: 14,
                //   textColor: selected
                //       ? getColor(context, "black").withOpacity(0.4)
                //       : getColor(context, "textLight"),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildCategoryPercentIcon(),
        _buildCategoryPercentLabel(),
      ],
    );
  }
}

class _CategoryIconPercent extends StatelessWidget {
  /// 种类
  final TransactionCategoryModel category;

  /// 图标大小
  final double size;

  /// 占比
  final double percent;

  /// 内边距
  final double insetPadding;

  /// 占比颜色
  final Color progressBackgroundColor;

  ///
  final double percentageOffset;

  const _CategoryIconPercent({
    super.key,
    required this.category,
    this.size = 30,
    required this.percent,
    this.insetPadding = 23,
    required this.progressBackgroundColor,
    required this.percentageOffset,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = dynamicPastel(
      context,
      HexColor(category.colour,
          defaultColor: Theme.of(context).colorScheme.primary),
      amountLight: 0.55,
      amountDark: 0.35,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Stack(
            children: [
              if (category.iconName != null && category.emojiIconName == null)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? backgroundColor
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  height: size + insetPadding,
                  width: size + insetPadding,
                  padding: const EdgeInsetsDirectional.all(10),
                  child: CacheCategoryIcon(
                    iconName: category.iconName ?? "",
                    size: size,
                  ),
                ),

              // 占比条
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: SizedBox(
                  key: ValueKey(progressBackgroundColor.toString()),
                  height: size + insetPadding,
                  width: size + insetPadding,
                  child: CaAnimateCircularProgress(
                    rotationOffsetPercent: percentageOffset,
                    percent: clampDouble(percent / 100, 0, 1),
                    backgroundColor: progressBackgroundColor,
                    foregroundColor: dynamicPastel(
                      context,
                      HexColor(
                        category.colour,
                        defaultColor: Theme.of(context).colorScheme.primary,
                      ),
                      inverse: true,
                      amountLight: 0.1,
                      amountDark: 0.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
