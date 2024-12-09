import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_animate.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_function.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_text_font.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_widgets.dart';
import 'package:flutter_demo_collect/Cash_App/model/index.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_home_page/transaction_chart/ca_category_entry.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_home_page/transaction_chart/ca_pin_wheel_reval.dart';

List<CategoryWithTotalModel> categoriesWithTotalData = [
  CategoryWithTotalModel(
    category: TransactionCategoryModel(
      categoryPk: '10',
      name: '旅行',
      dateCreated: DateTime.now(),
      colour: '#f4ba61',
      order: 10,
      income: false,
      iconName: 'plane.png',
    ),
    total: 1000.00,
  ),
  CategoryWithTotalModel(
    category: TransactionCategoryModel(
      categoryPk: '6',
      name: '定期账单与费用',
      dateCreated: DateTime.now(),
      order: 0,
      colour: '#91c58a',
      income: false,
      iconName: 'bills.png',
    ),
    total: 800.00,
  ),
  CategoryWithTotalModel(
    category: TransactionCategoryModel(
      categoryPk: '1',
      name: '三餐',
      dateCreated: DateTime.now(),
      order: 8,
      income: false,
      colour: '#94a3ad',
      iconName: 'cutlery.png',
    ),
    total: 450.00,
  ),
  CategoryWithTotalModel(
    category: TransactionCategoryModel(
      categoryPk: '5',
      name: '娱乐',
      dateCreated: DateTime.now(),
      order: 4,
      income: false,
      colour: '#78b3f0',
      iconName: 'popcorn.png',
    ),
    total: 450.00,
  ),
  CategoryWithTotalModel(
    category: TransactionCategoryModel(
      categoryPk: '9',
      name: '交通',
      dateCreated: DateTime.now(),
      order: 4,
      income: false,
      colour: '#fdf288',
      iconName: 'sports.png',
    ),
    total: 666.00,
  ),
];

class TotalSpentCategoriesSummary {
  double totalSpent;
  Map<String, List<CategoryWithTotalModel>>
      subCategorySpendingIndexedByMainCategoryPk;
  Map<String, double> totalSpentOfCategoriesRemoveUnassignedTransactions;
  List<CategoryWithTotalModel> dataFilterUnassignedTransactions;
  bool hasSubCategories;

  TotalSpentCategoriesSummary({
    this.totalSpent = 0,
    this.subCategorySpendingIndexedByMainCategoryPk = const {},
    this.totalSpentOfCategoriesRemoveUnassignedTransactions = const {},
    this.dataFilterUnassignedTransactions = const [],
    this.hasSubCategories = false,
  }) {
    subCategorySpendingIndexedByMainCategoryPk =
        subCategorySpendingIndexedByMainCategoryPk.isEmpty
            ? {}
            : subCategorySpendingIndexedByMainCategoryPk;
    totalSpentOfCategoriesRemoveUnassignedTransactions =
        totalSpentOfCategoriesRemoveUnassignedTransactions.isEmpty
            ? {}
            : totalSpentOfCategoriesRemoveUnassignedTransactions;
    dataFilterUnassignedTransactions =
        dataFilterUnassignedTransactions.isEmpty == true
            ? []
            : dataFilterUnassignedTransactions;
  }
}

/// 包含饼图和分类的摘要
class CaPieChartCategorySummary extends StatefulWidget {
  final TransactionCategoryModel? selectedCategory;
  final bool isIncome;
  const CaPieChartCategorySummary({
    super.key,
    required this.selectedCategory,
    required this.isIncome,
  });

  @override
  State<CaPieChartCategorySummary> createState() =>
      _CaPieChartCategorySummaryState();
}

class _CaPieChartCategorySummaryState extends State<CaPieChartCategorySummary> {
  /// 饼图数据
  List<CategoryWithTotalModel> categoriesWithTotal = categoriesWithTotalData;
  GlobalKey<CaPieChartDisplayState> pieChartDisplayStateKey = GlobalKey();
  TotalSpentCategoriesSummary totalSpentCategoriesSummary =
      TotalSpentCategoriesSummary(
    dataFilterUnassignedTransactions: categoriesWithTotalData,
    totalSpent: 2600,
  );
  bool expandCategorySelection = false;
  late TransactionCategoryModel? selectedCategory = widget.selectedCategory;
  List<CaCategoryEntry> _categoryEntry = [];

  // 清空选中的分类
  clearCategorySelection() {
    pieChartDisplayStateKey.currentState?.setTouchedIndex(-1);
    setState(() {
      expandCategorySelection = false;
    });
  }

  //

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        children: [
          Column(
            // clipBehavior: Clip.none,
            children: [
              // 饼图位置
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 10,
                  end: 10,
                  bottom: 15,
                  top: 30,
                ),
                child: LayoutBuilder(
                  builder: (context, boxConstraints) {
                    bool showTopCategoriesLegend =
                        boxConstraints.maxWidth > 320 &&
                            categoriesWithTotal.isNotEmpty;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 显示饼图种类
                        // if (showTopCategoriesLegend)

                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(start: 12),
                            child: _CaPieChartCategoryLegend(
                              categoriesWithTotal: categoriesWithTotal
                                  .take(boxConstraints.maxWidth < 420 ? 3 : 5)
                                  .toList(),
                            ),
                          ),
                        ),

                        /// 显示饼图
                        Flexible(
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: AlignmentDirectional.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 45),
                                child: _CaPieChartCategoryWrapper(
                                  disableLarge: true,
                                  pieChartDisplayStateKey:
                                      pieChartDisplayStateKey,
                                  data: totalSpentCategoriesSummary
                                      .dataFilterUnassignedTransactions,
                                  setSelectedCategory: (String categoryPk,
                                      TransactionCategoryModel? category) {
                                    if (category == null) {
                                      clearCategorySelection();
                                    } else {
                                      setState(() {
                                        selectedCategory = category;
                                        expandCategorySelection = true;
                                      });
                                      _categoryEntry = [
                                        CaCategoryEntry(
                                          showIncomeExpenseIcons: true,
                                          category: CategoryWithTotalModel(
                                            category: category,
                                            total: totalSpentCategoriesSummary
                                                    .totalSpent *
                                                Random(1).nextDouble(),
                                          ),
                                          categorySpent:
                                              totalSpentCategoriesSummary
                                                      .totalSpent *
                                                  Random(1).nextDouble(),
                                          // categorySpent:category.categoryPk == selectedCategory?.categoryPk ? totalSpentCategoriesSummary.totalSpent : 0,
                                          totalSpent:
                                              totalSpentCategoriesSummary
                                                  .totalSpent,
                                        ),
                                      ];
                                    }
                                  },
                                  isPastBudget: true,
                                  totalSpent:
                                      totalSpentCategoriesSummary.totalSpent,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 15),
              // 点击饼图种类显示详细数据
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: expandCategorySelection == false
                    ? Container(key: ValueKey(1), height: 10)
                    : Column(
                        children: _categoryEntry,
                        key: ValueKey(selectedCategory?.categoryPk ?? ""),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CaPieChartCategoryLegend extends StatelessWidget {
  const _CaPieChartCategoryLegend(
      {required this.categoriesWithTotal, super.key});
  final List<CategoryWithTotalModel> categoriesWithTotal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (CategoryWithTotalModel categoryWithTotal in categoriesWithTotal)
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(100),
                    color: HexColor(categoryWithTotal.category.colour),
                  ),
                ),
                SizedBox(width: 5),
                Flexible(
                  child: TextFont(
                    text: categoryWithTotal.category.name,
                    fontSize: 15,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// 一个包装过的chart饼图 包括饼图本身、中间挖一个空洞、以及中间给一个过渡的白色圆圈
class _CaPieChartCategoryWrapper extends StatelessWidget {
  /// 数据data 是CategoryWithTotal类型(包括categoryPk和total)
  final List<CategoryWithTotalModel> data;

  /// 总花费
  final double totalSpent;

  /// 设置选中类别的函数
  final Function(String categoryPk, TransactionCategoryModel? category)
      setSelectedCategory;

  /// 没啥用
  final bool isPastBudget;

  /// 一个全局GlobalKey，用于清除一些操作
  final GlobalKey<CaPieChartDisplayState>? pieChartDisplayStateKey;

  /// 中间空白圆圈的过渡颜色
  final Color? middleColor;

  /// 是否禁用大图
  final bool disableLarge;

  const _CaPieChartCategoryWrapper({
    super.key,
    required this.data,
    required this.totalSpent,
    required this.setSelectedCategory,
    required this.isPastBudget,
    required this.pieChartDisplayStateKey,
    this.middleColor,
    this.disableLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        children: [
          // 一整个饼图
          ScaledAnimatedSwitcher(
            keyToWatch: (data.isEmpty).toString(),
            duration: const Duration(milliseconds: 300),
            child: CaPieChartDisplay(
              data: data,
              totalSpent: totalSpent,
              setSelectedCategory: setSelectedCategory,
              key: pieChartDisplayStateKey,
              disableLarge: disableLarge,
            ),
          ),
          // 中间空白圆圈的过渡颜色
          IgnorePointer(
            child: Center(
              child: Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  color: middleColor?.withOpacity(0.2) ??
                      Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // 中间挖一个空洞
          IgnorePointer(
            child: Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: middleColor ?? Theme.of(context).canvasColor,
                    shape: BoxShape.circle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CaPieChartDisplay extends StatefulWidget {
  final List<CategoryWithTotalModel> data;
  final double totalSpent;
  final Function(String categoryPk, TransactionCategoryModel? category)
      setSelectedCategory;
  final bool disableLarge;
  const CaPieChartDisplay({
    super.key,
    required this.data,
    required this.totalSpent,
    required this.setSelectedCategory,
    this.disableLarge = false,
  });

  @override
  State<CaPieChartDisplay> createState() => CaPieChartDisplayState();
}

class CaPieChartDisplayState extends State<CaPieChartDisplay> {
  int touchedIndex = -1;
  int showLabels = 0;
  bool scaleIn = false;

  void setTouchedIndex(index) {
    setState(() {
      touchedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      setState(() {
        scaleIn = true;
      });
    });
    Future.delayed(Duration(milliseconds: 500), () async {
      int numCategories = widget.data.length;
      print('我是所有的种类:$numCategories');
      for (int i = 1; i <= numCategories + 25; i++) {
        await Future.delayed(const Duration(milliseconds: 70));
        if (mounted)
          setState(() {
            showLabels = showLabels + 1;
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // PinWheelReveal 用于切换的时候出现动画
    return CaPinWheelReveal(
      delay: const Duration(milliseconds: 0),
      duration: const Duration(milliseconds: 850),
      child: PieChart(
        PieChartData(
          startDegreeOffset: -45,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  return;
                }
                if (event.runtimeType == FlTapDownEvent &&
                    touchedIndex !=
                        pieTouchResponse.touchedSection!.touchedSectionIndex) {
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                  widget.setSelectedCategory(
                      widget.data[touchedIndex].category.categoryPk,
                      widget.data[touchedIndex].category);
                } else if (event.runtimeType == FlTapDownEvent) {
                  touchedIndex = -1;
                  widget.setSelectedCategory("-1", null);
                } else if (event.runtimeType == FlLongPressMoveUpdate) {
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                  widget.setSelectedCategory(
                      widget.data[touchedIndex].category.categoryPk,
                      widget.data[touchedIndex].category);
                }
              });
            },
          ),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 0,
          // 数据展示
          sections: showingSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    double totalPercentAccumulated = 0;
    return List.generate(
      widget.data.length,
      (index) {
        final bool isTouched = index == touchedIndex;
        final double widgetScale = isTouched ? 1.3 : 1.0;
        final double radius = isTouched ? 106.0 : 100.0;
        bool isTouchingSameColorSection = true;
        final Color color = dynamicPastel(
          context,
          HexColor(widget.data[index].category.colour,
              defaultColor: Theme.of(context).colorScheme.primary),
        );
        double percent = widget.totalSpent == 0
            ? 0
            : (widget.data[index].total / widget.totalSpent * 100).abs();
        totalPercentAccumulated = totalPercentAccumulated + percent;
        return PieChartSectionData(
          color: color,
          value: widget.totalSpent == 0
              ? 5
              : (widget.data[index].total / widget.totalSpent).abs(),
          title: "",
          radius: radius,
          badgeWidget: _Badge(
            totalPercentAccumulated: totalPercentAccumulated,
            showLabels: index < showLabels,
            // showLabels: true,
            scale: widgetScale,
            color: color,
            iconName: widget.data[index].category.iconName ?? "",
            categoryColor: HexColor(widget.data[index].category.colour,
                defaultColor: Theme.of(context).colorScheme.primary),
            emojiIconName: widget.data[index].category.emojiIconName,
            percent: percent,
            isTouched: isTouched,
          ),
          titlePositionPercentageOffset: 1.4,
          badgePositionPercentageOffset: .98,
        );
      },
    );
  }
}

class _Badge extends StatelessWidget {
  final double scale;
  final Color color;
  final String iconName;
  final String? emojiIconName;
  final double percent;
  final bool isTouched;
  final bool showLabels;
  final Color categoryColor;
  final double totalPercentAccumulated;

  const _Badge({
    Key? key,
    required this.scale,
    required this.color,
    required this.iconName,
    required this.emojiIconName,
    required this.percent,
    required this.isTouched,
    required this.showLabels,
    required this.categoryColor,
    required this.totalPercentAccumulated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool showIcon = percent.abs() < 5;
    return AnimatedScale(
      curve: showIcon
          ? Curves.easeInOutCubicEmphasized
          : const ElasticOutCurve(0.6),
      duration:
          showIcon ? Duration(milliseconds: 700) : Duration(milliseconds: 1300),
      scale: showIcon && isTouched == false
          ? 0
          : (showLabels || isTouched ? (showIcon ? 1 : scale) : 0),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: Container(
          key: ValueKey(iconName),
          height: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 2.5,
            ),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              // 百分比
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: scale == 1 ? 0 : 1,
                child: Center(
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      // Prevent overlapping labels when displayed on top
                      // Divider percent by 2, because the label is in the middle
                      // This means any label location that is past 50% will change orientation
                      totalPercentAccumulated - percent / 2 < 50 ? -34 : 34,
                    ),
                    child: IntrinsicWidth(
                      child: Container(
                        height: 20,
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(5),
                          border: Border.all(
                            color: color,
                            width: 1.5,
                          ),
                          color: Theme.of(context).canvasColor,
                        ),
                        child: Center(
                          child: MediaQuery(
                            child: TextFont(
                              text: convertToPercent(percent),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // 图标种类
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).canvasColor,
                ),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? dynamicPastel(context, categoryColor,
                              amountLight: 0.55, amountDark: 0.35)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsetsDirectional.all(8),
                    child: emojiIconName != null
                        ? Container()
                        : CacheCategoryIcon(
                            iconName: iconName,
                            size: 34,
                          ),
                  ),
                ),
              ),
              // emoji表情
              // emojiIconName != null
              //     ? EmojiIcon(
              //         emojiIconName: emojiIconName,
              //         size: 34 * 0.7,
              //       )
              //     : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
