import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

/// 类似tabbar组件 分成全部、收入、支出三个选项
class CaSelectorIncomeExpense extends StatelessWidget {
  final List<String>? options;
  final Function(int)? onSelected;

  const CaSelectorIncomeExpense({
    super.key,
    this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius =
        Platform.isIOS ? BorderRadius.circular(10) : BorderRadius.circular(15);
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0x2D5A5A5A).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 0),
              spreadRadius: 8,
            ),
          ],
        ),
        child: DefaultTabController(
          length: options != null ? options!.length : 3,
          initialIndex: 0,
          child: SizedBox(
            height: 45,
            child: Material(
              borderRadius: borderRadius,
              color: Colors.white,
              child: TabBar(
                splashFactory: Platform.isIOS ? NoSplash.splashFactory : null,
                splashBorderRadius: borderRadius,
                onTap: (value) {
                  onSelected!(value + 1);
                },
                labelColor: Colors.white,
                dividerColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: borderRadius,
                ),
                tabs: options == null
                    ? [
                        const Tab(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(top: 5.0),
                            child: AutoSizeText(
                              minFontSize: 11,
                              maxLines: 1,
                              "All",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamilyFallback: ['Inter'],
                              ),
                            ),
                          ),
                        ),
                        const Tab(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(top: 5.0),
                            child: AutoSizeText(
                              minFontSize: 11,
                              maxLines: 1,
                              "Expense",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamilyFallback: ['Inter'],
                              ),
                            ),
                          ),
                        ),
                        const Tab(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(top: 5.0),
                            child: AutoSizeText(
                              minFontSize: 11,
                              maxLines: 1,
                              'Income',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamilyFallback: ['Inter'],
                              ),
                            ),
                          ),
                        ),
                      ]
                    : [
                        for (String option in options!)
                          Tab(
                            child: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(top: 5.0),
                              child: AutoSizeText(
                                minFontSize: 11,
                                maxLines: 1,
                                option,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamilyFallback: ['Inter']),
                              ),
                            ),
                          ),
                      ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
