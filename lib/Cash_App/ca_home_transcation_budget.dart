import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/data/index.dart';
import 'package:flutter_demo_collect/Cash_App/model/index.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_home_page/transaction_budget/ca_budget_container.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_home_page/transaction_chart/ca_pie_chart_category_summary.dart';
import 'package:flutter_demo_collect/Cash_App/widgets_common/widget_size.dart';

final List<CaBudgetModel> budgets = [
  CaBudgetModel(
      budgetPk: '1',
      name: '我的预算',
      amount: 20000.0,
      colour: '#90b9ec',
      startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
      endDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 1)
          .subtract(Duration(days: 1))),
  CaBudgetModel(
      budgetPk: '1',
      name: '家庭预算',
      amount: 30000.0,
      colour: '##f8d3c4',
      startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
      endDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 1)
          .subtract(Duration(days: 1)))
];

class CaHomeTranscationBudget extends StatefulWidget {
  const CaHomeTranscationBudget({super.key});

  @override
  State<CaHomeTranscationBudget> createState() =>
      _CaHomeTranscationBudgetState();
}

class _CaHomeTranscationBudgetState extends State<CaHomeTranscationBudget> {
  double height = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 用来获取 BudgetContainer 的高度
        IgnorePointer(
          child: Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Opacity(
              opacity: 0,
              child: WidgetSize(
                onChange: (Size size) {
                  setState(() {
                    height = size.height;
                  });
                },
                child: CaBudgetContainer(
                  budget: budgets.first,
                  budgets: categoriesWithTotalData,
                ),
                // child: Container(),
              ),
            ),
          ),
        ),

        /// 下面才是内容
        Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 13),
          child: CarouselSlider(
            options: CarouselOptions(
              height: height,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.zoom,
              viewportFraction: 0.95,
              clipBehavior: Clip.none,
              enlargeFactor: 0.3,
            ),
            items: [
              CaBudgetContainer(
                budget: budgets.first,
                budgets: categoriesWithTotalData,
              ),
              CaBudgetContainer(
                budget: budgets.last,
                budgets: categoriesWithTotalData,
              )
            ],
          ),
        )
      ],
    );
  }
}
