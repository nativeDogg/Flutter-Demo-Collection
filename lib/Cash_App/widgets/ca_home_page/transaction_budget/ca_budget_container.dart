import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/ca_home_transcation_budget.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_animate.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_enum.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_function.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_tappable.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_text_font.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_widgets.dart';
import 'package:flutter_demo_collect/Cash_App/model/index.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_home_page/transaction_budget/ca_budget_page.dart';
import 'package:flutter_demo_collect/Cash_App/widgets_common/open_container_navigation.dart';
import 'package:flutter_demo_collect/Cash_App/widgets_common/widget_size.dart';

int determineBudgetPolarity(CaBudgetModel budget) {
  if (budget.income == true) {
    return 1;
  } else {
    return -1;
  }
}

/// 预算容器
class CaBudgetContainer extends StatelessWidget {
  final CaBudgetModel budget;
  final List<CategoryWithTotalModel> budgets;
  const CaBudgetContainer(
      {super.key, required this.budget, required this.budgets});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      double totalSpent = 0;
      budgets.forEach((CategoryWithTotalModel element) {
        totalSpent = totalSpent + element.total;
      });
      totalSpent = totalSpent * determineBudgetPolarity(budget);

      return OpenContainerNavigation(
        openPage: CaBudgetPage(budget: budget),
        borderRadius: 15,
        button: (void Function() openFunc) {
          return Tappable(
            onTap: () => openFunc(),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 0),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// 标题栏
                    Stack(
                      children: [
                        Positioned.fill(
                          child: AnimatedGooBackground(
                            color: HexColor(budget.colour),
                          ),
                        ),
                        // 标题文字
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 23, end: 23, bottom: 13, top: 13),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: TextFont(
                                      text: budget.name,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CountNumber(
                                    count: 1000,
                                    duration: const Duration(milliseconds: 700),
                                    initialCount: (0),
                                    textBuilder: (number) {
                                      return TextFont(
                                        text: 'RM${convertToMoney(
                                          199900.00,
                                          decimals: 2,
                                        )}',
                                        fontSize: 18,
                                        textAlign: TextAlign.left,
                                        fontWeight: FontWeight.bold,
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsetsDirectional.only(
                                          bottom: 1.4),
                                      child: TextFont(
                                        // text: getBudgetOverSpentText(budget.income) +
                                        //     convertToMoney(
                                        //         Provider.of<AllWallets>(context),
                                        //         budgetAmount),
                                        text: '总预算为 ${convertToMoney(20000)}',
                                        fontSize: 13,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        /// 预算按钮
                        Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: Container(
                            padding: EdgeInsetsDirectional.only(
                                top: 10, end: 10, start: 10),
                            child: ButtonIcon(
                              onTap: () {
                                // pushRoute(
                                //   context,
                                //   PastBudgetsPage(budgetPk: budget.budgetPk),
                                // );
                              },
                              icon: Icons.history_outlined,
                              color: dynamicPastel(
                                  context,
                                  HexColor(budget.colour,
                                      defaultColor: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  amount: 0.5),
                              iconColor: dynamicPastel(
                                  context,
                                  HexColor(budget.colour,
                                      defaultColor: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  amount: 0.7,
                                  inverse: true),
                              size: 38,
                              iconPadding: 18,
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// 预算进度条
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsetsDirectional.only(
                        start: 15,
                        end: 15,
                        top: 16.5,
                        bottom: 16.5,
                      ),
                      child: CaBudgetTimeLine(
                        budget: budget,
                      ),
                    ),

                    /// 时间天数
                    Container(
                      padding: const EdgeInsetsDirectional.only(bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Center(
                        child: TextFont(
                          fontSize: 12,
                          textColor: Colors.black.withOpacity(0.4),
                          text: '您当前的预算为RM${convertToMoney(99.23)}/天',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

class AnimatedGooBackground extends StatelessWidget {
  const AnimatedGooBackground({
    Key? key,
    required this.color,
    this.randomOffset = 1,
  });

  final Color color;
  final int randomOffset;

  @override
  Widget build(BuildContext context) {
    // Transform slightly to remove graphic artifacts
    // return Transform(
    //   transform: Matrix4.skewX(0.001),
    //   child: Container(
    //     decoration: BoxDecoration(
    //       color: Colors.white.withAlpha(200),
    //     ),
    //     child: PlasmaRenderer(
    //       key: ValueKey(key),
    //       type: PlasmaType.infinity,
    //       particles: 10,
    //       color: Theme.of(context).brightness == Brightness.light
    //           ? this.color.withOpacity(0.1)
    //           : this.color.withOpacity(0.3),
    //       blur: 0.3,
    //       size: 1.3,
    //       speed: 3.3,
    //       offset: 0,
    //       blendMode: BlendMode.multiply,
    //       particleType: ParticleType.atlas,
    //       variation1: 0,
    //       variation2: 0,
    //       variation3: 0,
    //       rotation:
    //           (randomInt[0] % (randomOffset > 0 ? randomOffset : 1)).toDouble(),
    //     ),
    //   ),
    // );
    return Container(
      decoration: BoxDecoration(
        color: dynamicPastel(context, color, amountLight: 0.6, amountDark: 0.3),
      ),
    );
  }
}

class ButtonIcon extends StatelessWidget {
  const ButtonIcon({
    Key? key,
    required this.onTap,
    required this.icon,
    this.size = 44,
    this.color,
    this.iconColor,
    this.padding,
    this.iconPadding = 20,
  }) : super(key: key);
  final VoidCallback onTap;
  final IconData icon;
  final double size;
  final Color? color;
  final Color? iconColor;
  final EdgeInsetsDirectional? padding;
  final double iconPadding;
  @override
  Widget build(BuildContext context) {
    return Tappable(
      child: Container(
        height: size,
        width: size,
        margin: padding,
        child: Icon(
          icon,
          color: iconColor == null
              ? Theme.of(context).colorScheme.onSecondaryContainer
              : iconColor,
          size: size - iconPadding,
        ),
      ),
      color: color == null
          ? Theme.of(context).colorScheme.secondaryContainer
          : color,
      borderRadius: Platform.isIOS ? 10 : 15,
      onTap: onTap,
    );
  }
}

class CaBudgetTimeLine extends StatelessWidget {
  final CaBudgetModel budget;
  final double percent;
  final double yourPercent;
  const CaBudgetTimeLine({
    super.key,
    required this.budget,
    this.percent = 0,
    this.yourPercent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            /// 左侧文本
            TextFont(
              textAlign: TextAlign.center,
              // text: getWordedDateShort(
              // getBudgetDate(budget, dateForRangeLocal).start,
              // includeYear: budget.reoccurrence == BudgetReoccurence.yearly),
              text: budget.startDate.toString().split(' ').first,
              fontSize: 12,
            ),

            /// 中间进度条
            Expanded(
              child: BudgetProgress(
                // color: HexColor(
                //   budget.colour,
                //   defaultColor: Theme.of(context).colorScheme.primary,
                // ),
                backgroundColor: HexColor('0xffebebeb'),
                // color: Colors.red,
                color: HexColor(
                  budget.colour,
                  defaultColor: Theme.of(context).colorScheme.primary,
                ),
                percent: percent,
                yourPercent: yourPercent,
                // ghostPercent: ghostPercent,
                // todayPercent: todayPercent,
                // large: large,
              ),
            ),

            /// 右侧文本
            TextFont(
              textAlign: TextAlign.center,
              // text: getWordedDateShort(
              // getBudgetDate(budget, dateForRangeLocal).start,
              // includeYear: budget.reoccurrence == BudgetReoccurence.yearly),
              text: budget.startDate.toString().split(' ').first,
              fontSize: 12,
            ),
          ],
        ),
      ],
    );
  }
}

class BudgetProgress extends StatelessWidget {
  const BudgetProgress({
    super.key,
    required this.color,
    this.backgroundColor,
    this.padding = const EdgeInsetsDirectional.symmetric(horizontal: 8.0),
    required this.percent,
    required this.yourPercent,
  });

  final Color color;
  final backgroundColor;
  final EdgeInsetsDirectional padding;

  /// 占比
  final double percent;

  /// 我的占比
  final double yourPercent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ShakeAnimation(),
        Padding(
          padding: padding,
          child: ClipRRect(
            borderRadius: BorderRadiusDirectional.circular(50),
            child: SizedBox(
              height: 18,
              child: Stack(
                children: [
                  /// 整体进度条
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(50),
                      color: backgroundColor,
                    ),
                  ),

                  /// 占比进度条
                  ClipRRect(
                    borderRadius: BorderRadiusDirectional.circular(50),
                    child: CaAnimateProgress(
                      color: color,
                      // percent: percent,
                      // large: large,
                      // color: color,
                      // getPercentText: getPercentText,
                      // otherPercent: yourPercent,
                    ),
                  ),

                  /// 占比文本
                ],
              ),
            ),
          ),
        ),

        /// 界限
        // showToday == true
        //     ? todayPercent < 0 || todayPercent > 100
        //         ? Container(height: 39)
        //         : TodayIndicator(
        //             percent: todayPercent,
        //             large: large,
        //           )
        //     : SizedBox.shrink(),
        TodayIndicator(
            // percent: todayPercent,
            // large: large,
            )
      ],
    );
  }
}

class TodayIndicator extends StatefulWidget {
  const TodayIndicator({super.key});

  @override
  State<TodayIndicator> createState() => _TodayIndicatorState();
}

class _TodayIndicatorState extends State<TodayIndicator> {
  /// 指示器大小
  Size? todayIndicatorSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        WidgetSize(
          onChange: (Size size) {},
          child: Column(
            children: [
              WidgetSize(
                onChange: (Size size) {
                  todayIndicatorSize = size;
                  setState(() {});
                },
                child: AnimatedOpacity(
                  // 根据是否获取到了 todayIndicatorSize 来决定是否显示
                  opacity: todayIndicatorSize != null ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(6),
                      color: Theme.of(context).brightness == Brightness.light
                          ? const Color(0xFF1F1F1F)
                          : Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        top: 3,
                        end: 5,
                        start: 5,
                        bottom: 3,
                      ),
                      child: MediaQuery(
                        child: TextFont(
                          textAlign: TextAlign.center,
                          text: "Today",
                          fontSize: 9,
                          textColor: Colors.white,
                        ),
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Align(
          alignment: FractionalOffset(50 / 100, 0),
          child: FadeIn(
            child: Container(
              margin: EdgeInsetsDirectional.symmetric(horizontal: 10),
              width: 3,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.vertical(
                  bottom: Radius.circular(5),
                ),
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
