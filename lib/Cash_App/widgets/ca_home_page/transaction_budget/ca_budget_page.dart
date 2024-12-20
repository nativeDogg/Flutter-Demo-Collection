import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_animate.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_function.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_page_frame_work.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_text_font.dart';
import 'package:flutter_demo_collect/Cash_App/data/index.dart';
import 'package:flutter_demo_collect/Cash_App/model/index.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_home_page/transaction_budget/ca_budget_container.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_home_page/transaction_chart/ca_category_entry.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_home_page/transaction_chart/ca_pie_chart_category_summary.dart';
import 'package:flutter_demo_collect/Cash_App/widgets_common/color_theme.dart';
import 'package:flutter_demo_collect/Cash_App/widgets_common/widget_size.dart';

final List<Pair> points1 = [
  Pair(0, 0, dateTime: DateTime(2024, 12, 1)),
  Pair(4, 1000, dateTime: DateTime(2024, 12, 5)),
  Pair(30, 1000, dateTime: DateTime(2024, 12, 10)),
  Pair(40, 1000, dateTime: DateTime(2024, 12, 19)),
];

final List<Pair> points2 = [
  Pair(0, 0, dateTime: DateTime(2024, 12, 1)),
  Pair(29, 300, dateTime: DateTime(2024, 12, 5)),
  Pair(40, 200, dateTime: DateTime(2024, 12, 10)),
  Pair(60, 800, dateTime: DateTime(2024, 12, 19)),
];

final List<Pair> points3 = [
  Pair(0, 0, dateTime: DateTime(2024, 12, 1)),
  Pair(12, 398, dateTime: DateTime(2024, 12, 5)),
  Pair(40, 444, dateTime: DateTime(2024, 12, 10)),
  Pair(70, 690, dateTime: DateTime(2024, 12, 19)),
];

final List<Pair> points4 = [
  Pair(0, 0, dateTime: DateTime(2024, 12, 1)),
  Pair(20, 988, dateTime: DateTime(2024, 12, 5)),
  Pair(40, 299, dateTime: DateTime(2024, 12, 10)),
  Pair(50, 60, dateTime: DateTime(2024, 12, 19)),
  Pair(80, 600, dateTime: DateTime(2024, 12, 19)),
];

final List<List<Pair>> pointDataList = [points1, points2, points3, points4];

class CaBudgetPage extends StatelessWidget {
  final CaBudgetModel budget;
  const CaBudgetPage({
    super.key,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    Color accentColor = HexColor(budget.colour);
    print('我是hex:${accentColor}');
    return CustomColorTheme(
      child: _CaBudgetContent(
        budget: budget,
      ),
      accentColor: accentColor,
    );
  }
}

class _CaBudgetContent extends StatefulWidget {
  final CaBudgetModel budget;
  const _CaBudgetContent({super.key, required this.budget});

  @override
  State<_CaBudgetContent> createState() => __CaBudgetContentState();
}

class __CaBudgetContentState extends State<_CaBudgetContent> {
  List<CategoryWithTotalModel> categoriesWithTotal = categoriesWithTotalData;
  GlobalKey<CaPieChartDisplayState> pieChartDisplayStateKey = GlobalKey();
  TotalSpentCategoriesSummary totalSpentCategoriesSummary =
      TotalSpentCategoriesSummary(
    dataFilterUnassignedTransactions: categoriesWithTotalData,
    totalSpent: 2600,
  );
  bool expandCategorySelection = false;
  TransactionCategoryModel? selectedCategory;
  List<CaCategoryEntry> _categoryEntry = [];

  List<List<Pair>> pointList = [];

  // pointList.add(points1);
  @override
  Widget build(BuildContext context) {
    return CaPageFramework(
      appBarBackgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      // appBarBackgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      slivers: [
        /// 预算数额 显示
        _buildBudgetCount(),

        /// 一个文本 显示当前选中的分类
        _buildBudgetText(),

        // /// 折线图
        if (selectedCategory != null) _buildBudgetLineChart(),

        // /// 交易列表
        // _buildBudgetTranscation(),
      ],
    );
  }

  clearCategorySelection() {
    pieChartDisplayStateKey.currentState?.setTouchedIndex(-1);
    setState(() {
      expandCategorySelection = false;
    });
  }

  /// 预算数额 显示
  _buildBudgetCount() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Transform.translate(
            offset: const Offset(0, -10),
            child: WidgetSize(
              onChange: (Size size) {
                // budgetHeaderHeight = size.height - 20;
                // setState(() {});
              },
              child: Container(
                padding: const EdgeInsetsDirectional.only(
                    top: 10, bottom: 15, start: 22, end: 22),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Column(
                  children: [
                    Transform.scale(
                      alignment: AlignmentDirectional.bottomCenter,
                      scale: 1500,
                      child: Container(
                        height: 10,
                        width: 100,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ),

                    /// 花费进度
                    CaBudgetTimeLine(
                      budget: widget.budget,
                      percent: 0.6,
                      yourPercent: 0,
                    ),

                    const SizedBox(height: 20),

                    /// 时间天数
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).colorScheme.secondaryContainer,
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
          ),
          const SizedBox(height: 35),

          /// 饼图
          Container(
            padding: EdgeInsets.only(left: 30),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(30),
                blurRadius: 20,
                offset: Offset(0, 0),
                spreadRadius: 8,
              ),
            ], borderRadius: BorderRadiusDirectional.circular(200)),
            child: CaPieChartCategoryWrapper(
              pieChartDisplayStateKey: pieChartDisplayStateKey,
              data:
                  totalSpentCategoriesSummary.dataFilterUnassignedTransactions,
              totalSpent: totalSpentCategoriesSummary.totalSpent,
              setSelectedCategory:
                  (String categoryPk, TransactionCategoryModel? category) {
                if (category == null) {
                  clearCategorySelection();
                } else {
                  setState(() {
                    final randomNum = Random().nextInt(5);
                    pointList = [pointDataList[randomNum]];
                    selectedCategory = category;
                    expandCategorySelection = true;
                  });
                  _categoryEntry = [
                    CaCategoryEntry(
                      showIncomeExpenseIcons: true,
                      category: CategoryWithTotalModel(
                        category: category,
                        total: totalSpentCategoriesSummary.totalSpent *
                            Random(1).nextDouble(),
                      ),
                      categorySpent: totalSpentCategoriesSummary.totalSpent *
                          Random(1).nextDouble(),
                      // categorySpent:category.categoryPk == selectedCategory?.categoryPk ? totalSpentCategoriesSummary.totalSpent : 0,
                      totalSpent: totalSpentCategoriesSummary.totalSpent,
                    ),
                  ];
                }
              },
              isPastBudget: false,
              middleColor: Colors.white,
            ),
          ),
          SizedBox(height: 40),
          if (_categoryEntry.isNotEmpty) ..._categoryEntry,
        ],
      ),
    );
  }

  /// 一个文本 显示当前选中的分类
  _buildBudgetText() {
    /// 一个文本 显示当前选中的分类
    return SliverToBoxAdapter(
      child: AnimatedExpanded(
        expand: selectedCategory != null,
        child: Padding(
          key: ValueKey(1),
          padding: const EdgeInsetsDirectional.only(
              start: 13, end: 15, top: 5, bottom: 15),
          child: Center(
            child: TextFont(
              text: "显示选定类别中的交易",
              maxLines: 10,
              textAlign: TextAlign.center,
              fontSize: 13,
              textColor: Colors.black.withAlpha(100),
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// 折线图
  _buildBudgetLineChart() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _LineChartWrapper(
          pointList: pointList,
          selectedCategory: selectedCategory,
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
      ),
    );
  }

  /// 交易列表
  _buildBudgetTranscation() {}
}

class _LineChartWrapper extends StatelessWidget {
  final List<List<Pair>> pointList;
  final bool isCurved;
  final Color? color;
  final DateTime? endDate;
  final double? verticalLineAt;
  final double? horizontalLineAt;
  final bool enableTouch;
  final List<Color> colors;
  final bool keepHorizontalLineInView;
  final double extraLeftPaddingIfSmall;
  final double amountBefore;
  final TransactionCategoryModel? selectedCategory;
  const _LineChartWrapper({
    super.key,
    required this.pointList,
    required this.color,
    this.selectedCategory,
    this.isCurved = false,
    this.endDate,
    this.verticalLineAt,
    this.horizontalLineAt,
    this.enableTouch = true,
    this.colors = const [],
    this.keepHorizontalLineInView = false,
    this.extraLeftPaddingIfSmall = 0,
    this.amountBefore = 0,
  });

  /// 将过滤的点放入List中
  List<List<Pair>> filterPointsList(List<List<Pair>> pointsList) {
    List<List<Pair>> pointsOut = [];
    for (List<Pair> points in pointsList) {
      pointsOut.add(filterPoints(points));
    }
    return pointsOut;
  }

  /// 过滤点
  List<Pair> filterPoints(List<Pair> points) {
    List<Pair> pointsOut = [];
    pointsOut.add(Pair(points.first.x, points.first.y));
    double previousTotal = 0;
    for (Pair point in points) {
      if (previousTotal != point.y) {
        pointsOut.add(Pair(point.x, point.y));
      }
      previousTotal = point.y;
    }
    if (pointsOut.length <= 0) {
      return [Pair(0, 0)];
    }
    pointsOut.last.x != points.last.x
        ? pointsOut.add(Pair(points.last.x, points.last.y))
        : 0;
    return pointsOut;
  }

  /// 将List<Pair>转换为List<FlSpot>
  List<List<FlSpot>> convertPoints(List<List<Pair>> pointsList) {
    List<List<FlSpot>> pointsOut = [];
    for (List<Pair> points in pointsList) {
      List<FlSpot> pointsOutCurrent = [];
      for (Pair pair in points) {
        pointsOutCurrent.add(FlSpot(pair.x, pair.y));
      }
      pointsOut.add(pointsOutCurrent);
    }
    // print('我是生成的点:${pointsOut}');
    return pointsOut;
  }

  /// 获取最大点
  Pair getMaxPoint(List<List<Pair>> pointsList) {
    Pair max = Pair(0, 0);
    if (amountBefore != 0 &&
        pointsList.isNotEmpty &&
        pointsList[0].isNotEmpty) {
      max.y = pointsList[0][0].y;
    }
    for (List<Pair> points in pointsList) {
      for (Pair pair in points) {
        if (pair.x > max.x) {
          max.x = pair.x;
        }
        if (pair.y > max.y) {
          max.y = pair.y;
        }
      }
    }
    // if (keepHorizontalLineInView &&
    //     horizontalLineAt != null &&
    //     horizontalLineAt != double.infinity &&
    //     (max.y) < ((horizontalLineAt ?? 0) + (horizontalLineAt ?? 0) * 0.1)) {
    //   max.y = (horizontalLineAt ?? 0) + (horizontalLineAt ?? 0) * 0.1;
    // }
    return max;
  }

  /// 获取最小点
  Pair getMinPoint(List<List<Pair>> pointsList) {
    Pair min = Pair(0, 0);
    if (amountBefore != 0 &&
        pointsList.isNotEmpty &&
        pointsList[0].isNotEmpty) {
      min.y = pointsList[0][0].y;
    }
    for (List<Pair> points in pointsList) {
      if (points.length <= 0 && min.x == 0 && min.y == 0) {
        min = Pair(0, 0);
      }
      for (Pair pair in points) {
        if (pair.x < min.x) {
          min.x = pair.x;
        }
        if (pair.y < min.y) {
          min.y = pair.y;
        }
      }
    }
    return min;
  }

  @override
  Widget build(BuildContext context) {
    Pair maxPair = getMaxPoint(pointList);
    Pair minPair = getMinPoint(pointList);
    return ClipRect(
      child: Container(
        // Left padding is omitted and added in the reserved size of the side titles
        margin: EdgeInsets.only(bottom: 12, top: 18, right: 7),
        height: MediaQuery.sizeOf(context).width > 700 ? 300 : 175,
        child: _LineChart(
          spots: convertPoints(filterPointsList(pointList)),
          maxPair: maxPair,
          minPair: minPair,
          // color: color == null ? Theme.of(context).colorScheme.primary : color!,
          color: selectedCategory != null
              ? HexColor(selectedCategory!.colour)
              : Theme.of(context).colorScheme.primary,
          isCurved: isCurved,
          endDate: endDate,
          verticalLineAt: verticalLineAt,
          horizontalLineAt: horizontalLineAt,
          enableTouch: enableTouch,
          colors: colors,
          extraLeftPaddingIfSmall: extraLeftPaddingIfSmall,
          amountBefore: amountBefore,
        ),
      ),
    );
  }
}

class _LineChart extends StatefulWidget {
  _LineChart({
    required this.spots,
    required this.maxPair,
    required this.minPair,
    required this.color,
    this.isCurved = false,
    this.endDate,
    this.verticalLineAt,
    this.horizontalLineAt,
    required this.enableTouch,
    this.extraLeftPaddingIfSmall = 0,
    this.colors = const [],
    this.amountBefore = 0,
    Key? key,
  }) : super(key: key);

  final List<List<FlSpot>> spots;
  final Pair maxPair;
  final Pair minPair;
  final Color color;
  final List<Color> colors;
  final bool isCurved;
  final DateTime? endDate;
  final double? verticalLineAt;
  final double? horizontalLineAt;
  final bool enableTouch;
  final double extraLeftPaddingIfSmall;
  final double amountBefore;

  @override
  State<_LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<_LineChart> with WidgetsBindingObserver {
  bool loaded = false;
  double extraHorizontalPadding = 10;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () {
      setState(() {
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: 15 + extraHorizontalPadding, top: 8, bottom: 0),
      child: GestureDetector(
        child: LineChart(
          data,
          duration: const Duration(milliseconds: 2000),
          curve: Curves.fastLinearToSlowEaseIn,
          chartRendererKey: ValueKey(1),
        ),
      ),
    );
  }

  LineChartData get data => LineChartData(
        // 触摸时候显示的数据
        lineTouchData: lineTouchData,
        // 网格样式
        gridData: gridData,
        // 边框样式
        borderData: borderData,
        // 线的样式
        lineBarsData: lineBarsData,
        minX: 0,
        // 使用loaded 控制不超过高度宽度
        maxX: loaded
            ? widget.maxPair.x
            : widget.maxPair.x - widget.maxPair.x * 0.7,

        minY: loaded
            ? widget.minPair.y == 0
                ? -0.000001
                : widget.minPair.y
            : widget.minPair.y - (widget.minPair.y - widget.amountBefore) * 0.7,
        maxY: loaded
            ? widget.maxPair.y == 0
                ? 0.000001
                : widget.maxPair.y
            : widget.maxPair.y + (widget.maxPair.y - widget.amountBefore) * 0.7,
        // 标题样式
        titlesData: titlesData,
        // y轴的颜色
        extraLinesData: extraLinesData,
      );

  ExtraLinesData get extraLinesData => ExtraLinesData(
        horizontalLines: [
          ...(((widget.minPair.y > 0 && widget.maxPair.y > 0) ||
                  (widget.minPair.y < 0 && widget.maxPair.y < 0))
              ? []
              : [HorizontalLine(strokeWidth: 2, y: 0, color: widget.color)]),
          HorizontalLine(
            y: 0,
            color: widget.color,
          ),
          ...(widget.horizontalLineAt == null
              ? []
              : [
                  HorizontalLine(
                    y: widget.horizontalLineAt!,
                    color: widget.color,
                    dashArray: [2, 2],
                  ),
                ])
        ],
        verticalLines: [
          // VerticalLine(
          //   x: 0.0001,
          //   dashArray: [2, 5],
          //   strokeWidth: 2,
          //   color: widget.color,
          // ),
          ...(widget.verticalLineAt != null
              ? [
                  VerticalLine(
                    x: widget.maxPair.x - widget.verticalLineAt!,
                    dashArray: [2, 2],
                    strokeWidth: 2,
                    color: widget.color,
                  )
                ]
              : [])
        ],
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,

        /// 日期时间
        bottomTitles: AxisTitles(
          axisNameSize: 25,
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, titleMeta) {
              if (value == widget.maxPair.x + 1) {
                return SizedBox.shrink();
              }
              DateTime currentDate =
                  widget.endDate == null ? DateTime.now() : widget.endDate!;
              // double valueBefore = value - titleMeta.appliedInterval;
              // print(valueBefore);
              // print(value);
              // print(titleMeta.max);

              String text = getWordedDateShort(
                DateTime(
                  currentDate.year,
                  currentDate.month,
                  currentDate.day - widget.maxPair.x.toInt() + value.round(),
                ),
                context,
                showTodayTomorrow: false,
              );

              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextFont(
                    textAlign: TextAlign.center,
                    fontSize: 13,
                    text: text,
                    textColor: dynamicPastel(context, widget.color,
                            amount: 0.8, inverse: true)
                        .withOpacity(0.5),
                    // textColor: widget.color,
                  ),
                ),
              );
            },
            reservedSize: 28,
            interval: widget.maxPair.x / 6 == 0 ? 5 : widget.maxPair.x / 6,
          ),
        ),

        /// 金额
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (
                value,
                titleMeta,
              ) {
                bool show = false;
                if (value == titleMeta.max || value == titleMeta.min) {
                  return SizedBox.shrink();
                } else if (value == 0) {
                  show = true;
                } else if (value < widget.maxPair.y &&
                    value > 1 &&
                    value < titleMeta.max) {
                  show = true;
                } else if (value > widget.minPair.y &&
                    value < 1 &&
                    value > titleMeta.min) {
                  show = true;
                } else {
                  return SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: TextFont(
                      textAlign: TextAlign.right,
                      text: value.toString(),
                      // text: getWordedNumber(context,
                      //     Provider.of<AllWallets>(context, listen: false), value),
                      textColor: dynamicPastel(context, widget.color,
                              amount: 0.5, inverse: true)
                          .withOpacity(0.3),
                      // textColor: widget.color,
                      fontSize: 13,
                    ),
                  ),
                );
              },
              // If the interval is equal to a really small number (almost 0, it freezes the app!)
              interval: double.parse((widget.maxPair.y - widget.minPair.y)
                          .toStringAsFixed(5)) ==
                      0.0
                  ? 0.001
                  : ((widget.maxPair.y - widget.minPair.y) / 7).abs(),
              reservedSize: 7 +
                  (widget.minPair.y <= -10000
                      ? 55
                      : widget.minPair.y <= -1000
                          ? 45
                          : widget.minPair.y <= -100
                              ? 40 + widget.extraLeftPaddingIfSmall / 2
                              : (widget.maxPair.y >= 100
                                      ? (widget.maxPair.y >= 1000 ? 37 : 33)
                                      : 25 + widget.extraLeftPaddingIfSmall) +
                                  extraHorizontalPadding) +
                  10),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  int? touchedValue = null;

  LineTouchData get lineTouchData => LineTouchData(
        enabled: true,
        touchSpotThreshold: 1000,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          // only show touch data for primary colored lines
          bool transparent = false;
          if (barData.color != lightenPastel(widget.color, amount: 0.3)) {
            transparent = true;
          }
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: transparent
                    ? Colors.transparent
                    : widget.color.withOpacity(0.9),
                strokeWidth: 2,
                dashArray: [2, 2],
              ),
              FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 3,
                  color: transparent
                      ? Colors.transparent
                      : widget.color.withOpacity(0.9),
                  strokeWidth: 2,
                  strokeColor: transparent
                      ? Colors.transparent
                      : widget.color.withOpacity(0.9),
                ),
              ),
            );
          }).toList();
        },
        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
          if (!event.isInterestedForInteractions || touchResponse == null) {
            touchedValue = null;
            return;
          }

          // print(event.runtimeType);

          double value = touchResponse.lineBarSpots![0].x;
          if (event.runtimeType == FlLongPressStart) {
            HapticFeedback.selectionClick();
          } else if (touchedValue != value.toInt() &&
              (event.runtimeType == FlLongPressMoveUpdate ||
                  event.runtimeType == FlPanUpdateEvent)) {
            HapticFeedback.selectionClick();
          }

          touchedValue = value.toInt();
        },
        touchTooltipData: LineTouchTooltipData(
          // tooltipBgColor: widget.color.withOpacity(0.7),
          tooltipRoundedRadius: 8,
          fitInsideVertically: true,
          fitInsideHorizontally: true,
          tooltipPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
            return lineBarsSpot.map((LineBarSpot lineBarSpot) {
              // only show touch data for primary colored lines
              if (lineBarSpot.bar.color !=
                  lightenPastel(widget.color, amount: 0.3)) {
                return null;
              }
              DateTime currentDate =
                  widget.endDate == null ? DateTime.now() : widget.endDate!;
              DateTime tooltipDate = DateTime(
                currentDate.year,
                currentDate.month,
                currentDate.day -
                    widget.maxPair.x.toInt() +
                    lineBarSpot.x.toInt(),
              );
              return LineTooltipItem(
                getWordedDateShort(
                      tooltipDate,
                      context,
                      includeYear: DateTime.now().year != tooltipDate.year,
                    ) +
                    "\n" +
                    lineBarSpot.y.toString(),
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamilyFallback: ['Inter'],
                ),
              );
            }).toList();
          },
        ),
      );

  List<LineChartBarData> get lineBarsData => [
        for (int spotsListIndex = 0;
            spotsListIndex < widget.spots.length;
            spotsListIndex++)
          lineChartBarData(widget.spots[spotsListIndex], spotsListIndex),
      ];

  FlGridData get gridData => FlGridData(
        show: true,
        // If the interval is equal to a really small number (almost 0, it freezes the app!)
        verticalInterval: double.parse(
                    (((widget.maxPair.x).abs() + (widget.minPair.x).abs()) / 6)
                        .toStringAsFixed(5)) ==
                0
            ? 5
            : ((widget.maxPair.x).abs() + (widget.minPair.x).abs()) / 6,

        getDrawingVerticalLine: (value) {
          return FlLine(
            color: dynamicPastel(context, widget.color, amount: 0.3)
                .withOpacity(0.2),
            // color: widget.color,
            strokeWidth: 2,
            dashArray: [2, 8],
          );
        },
        // If the interval is equal to a really small number (almost 0, it freezes the app!)
        horizontalInterval: double.parse(
                    (widget.maxPair.y - widget.minPair.y).toStringAsFixed(5)) ==
                0.0
            ? 0.001
            : ((widget.maxPair.y - widget.minPair.y) / 7).abs(),
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: dynamicPastel(context, widget.color.withOpacity(0.3),
                amount: 0.3),
            // color: widget.color,
            strokeWidth: 2,
            dashArray: [2, 8],
          );
        },
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LineChartBarData lineChartBarData(List<FlSpot> spots, int index) {
    return LineChartBarData(
      color: widget.colors.length > 0
          ? lightenPastel(widget.colors[index], amount: 0.3)
          : lightenPastel(widget.color, amount: 0.3),
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      isCurved: widget.isCurved,
      curveSmoothness: 0.1,
      preventCurveOverShooting: true,
      preventCurveOvershootingThreshold: 8,
      aboveBarData: BarAreaData(
        applyCutOffY: true,
        cutOffY: 0,
        show: widget.minPair.y >= 0 && widget.maxPair.y >= 0
            ? false
            : index != 0
                ? false
                : true,
        gradient: LinearGradient(
          colors: [
            index == 0
                ? widget.color.withAlpha(100)
                : widget.color.withAlpha(1),
            widget.color.withAlpha(1),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment(
              0,
              widget.maxPair.y > 0
                  ? -(widget.minPair.y).abs() /
                      ((widget.maxPair.y).abs() + (widget.minPair.y).abs())
                  : -1),
        ),
        // gradientFrom: Offset(
        //     0,
        //     ((widget.maxPair.y).abs()) /
        //         ((widget.maxPair.y).abs() + (widget.minPair.y).abs())),
      ),
      belowBarData: BarAreaData(
        applyCutOffY: true,
        cutOffY: 0,
        show: widget.minPair.y <= 0 && widget.maxPair.y <= 0 ? false : true,
        gradient: LinearGradient(
          colors: [
            index == 0
                ? widget.color.withAlpha(100)
                : widget.color.withAlpha(1),
            widget.color.withAlpha(1),
          ],
          begin: Alignment.topCenter,
          end: Alignment(
              0,
              (widget.maxPair.y).abs() /
                  ((widget.maxPair.y).abs() + (widget.minPair.y).abs())),
        ),
        // gradientTo: Offset(
        //     0,
        //     ((widget.maxPair.y).abs()) /
        //         ((widget.maxPair.y).abs() + (widget.minPair.y).abs())),
      ),
      spots: spots,
    );
  }
}
