import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_tappable.dart';
import 'package:flutter_demo_collect/Cash_App/model/index.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_home_page/transaction_chart/ca_page_indicator.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_home_page/transaction_chart/ca_pie_chart_category_summary.dart';
import 'package:flutter_demo_collect/Cash_App/widgets_common/keep_mixin.dart';

class CaHomeTranscationChart extends StatefulWidget {
  const CaHomeTranscationChart({super.key});

  @override
  State<CaHomeTranscationChart> createState() => _CaHomeTranscationChartState();
}

class _CaHomeTranscationChartState extends State<CaHomeTranscationChart> {
  final PageController _pageController = PageController(initialPage: 0);
  TransactionCategoryModel? selectedCategory;

  @override
  Widget build(BuildContext context) {
    double borderRadius = 15;
    return KeepAliveClientMixin(
      child: Padding(
        padding:
            const EdgeInsetsDirectional.only(bottom: 13, start: 13, end: 13),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 0),
                spreadRadius: 1,
              ),
            ],
            borderRadius: BorderRadiusDirectional.circular(borderRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadiusDirectional.circular(borderRadius),
            child: Tappable(
              borderRadius: borderRadius,
              onTap: () {},
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    color: Colors.white,
                    padding: const EdgeInsetsDirectional.only(bottom: 10),
                    child: Stack(
                      children: [
                        // 饼图
                        ExpandablePageView(
                          estimatedPageSize: 255,
                          onPageChanged: (value) {},
                          animationDuration: const Duration(milliseconds: 500),
                          animateFirstPage: true,
                          pageSnapping: true,
                          clipBehavior: Clip.none,
                          controller: _pageController,
                          children: [
                            // 支出饼图
                            CaPieChartCategorySummary(
                              isIncome: false,
                              selectedCategory: selectedCategory,
                            ),
                            // 收入饼图
                            CaPieChartCategorySummary(
                              isIncome: true,
                              selectedCategory: selectedCategory,
                            ),
                          ],
                        ),
                        // 饼图指示器
                        PositionedDirectional(
                          start: 0,
                          end: 0,
                          bottom: 1,
                          child: CaPageIndicator(
                            controller: _pageController,
                            itemCount: 2,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
