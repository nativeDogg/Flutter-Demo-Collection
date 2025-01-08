import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_popup_frame_work.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_sliver.dart';
import 'package:flutter_demo_collect/Cash_App/data/index.dart';
import 'package:flutter_demo_collect/Cash_App/model/index.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_month_transaction/ca_month_selector.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_month_transaction/search_filter/ca_search_filter.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_multi_direction_infinite_scroll.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_transcation_list.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sliver_tools/sliver_tools.dart';

class CaViewMonthTranscation extends StatefulWidget {
  const CaViewMonthTranscation({super.key});

  @override
  State<CaViewMonthTranscation> createState() => _CaViewMonthTranscationState();
}

class _CaViewMonthTranscationState extends State<CaViewMonthTranscation> {
  // 将MonthSelector的状态类从_MonthSelectorState变成MonthSelectorState公有访问 用于在调用MonthSelector的setSelectedDateStart时 可以同时调用外层的setSelectedDateStart
  GlobalKey<MonthSelectorState> monthSelectorStateKey = GlobalKey();

  late PageController _pageController;
  late SearchFilters searchFilters;

  @override
  void initState() {
    _pageController = PageController(initialPage: 1000000);
    searchFilters = SearchFilters();
    super.initState();
  }

  /// 设置过滤参数
  void setSearchFilters(SearchFilters searchFilters) {
    this.searchFilters = searchFilters;
    print('我是searchFilter.expen:${searchFilters.expenseIncome}');
    print('我是searchFilter.tran:${searchFilters.transactionTypes}');
    print('我是searchFilter.amount:${searchFilters.amountRange}');
  }

  /// 清空过滤参数
  void clearSearchFilters() {
    searchFilters.clearSearchFilters();
    // updateSettings("transactionsListPageSetFiltersString", null,
    //     updateGlobalState: false);
    setState(() {});
  }

  Future<void> selectFilters(BuildContext context) async {
    return showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          constraints: const BoxConstraints(maxHeight: 600, minHeight: 600),
          child: CaPopupFrameWork(
            child: CaTransactionFilter(
              searchFilters: searchFilters,
              setSearchFilters: setSearchFilters,
              clearSearchFilters: clearSearchFilters,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      // color: Theme.of(context).canvasColor,
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          // backgroundColor: Theme.of(context).canvasColor,
          body: NestedScrollView(
            headerSliverBuilder: (contextHeader, innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    contextHeader,
                  ),
                  sliver: MultiSliver(
                    children: [
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        title: const Text('交易'),
                        actions: [
                          // 弹出搜索框
                          IconButton(
                            tooltip: '过滤条件',
                            onPressed: () {
                              selectFilters(context);
                            },
                            padding: const EdgeInsetsDirectional.all(15 - 8),
                            icon: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadiusDirectional.circular(100),
                              ),
                              padding: const EdgeInsetsDirectional.all(8),
                              child: const Icon(Icons.filter_alt_outlined),
                            ),
                          ),
                          IconButton(
                            padding: const EdgeInsetsDirectional.all(15),
                            tooltip: '搜索交易',
                            onPressed: () {
                              // pushRoute(context, TransactionsSearchPage());
                            },
                            icon: const Icon(Icons.search_outlined),
                          ),
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(bottom: 5),
                          child: MonthSelector(
                            key: monthSelectorStateKey,
                            setSelectedDateStart: (_, index) {
                              // 如果相差等于1 使用animateToPage 否则 使用jumpToPage
                              if (((_pageController.page ?? 0) -
                                          index -
                                          _pageController.initialPage)
                                      .abs() ==
                                  1) {
                                _pageController.animateToPage(
                                  _pageController.initialPage + index,
                                  duration: const Duration(milliseconds: 1000),
                                  curve: Curves.easeInOutCubicEmphasized,
                                );
                              } else {
                                _pageController.jumpToPage(
                                  _pageController.initialPage + index,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ];
            },
            body: Stack(
              children: [
                Builder(
                  builder: (context) {
                    return PageView.builder(
                      controller: _pageController,
                      onPageChanged: (int index) {
                        // 1、在页面切换的时候调用MonthSelector的setSelectedDateStart方法
                        int pageOffset = index - _pageController.initialPage;
                        DateTime startDateTime = DateTime(DateTime.now().year,
                            DateTime.now().month + pageOffset);
                        monthSelectorStateKey.currentState
                            ?.setSelectedDateStart(startDateTime, pageOffset);

                        // 2、将当前月份移动到中间 在页面切换的时候调用MonthSelector的scrollTo方法
                        double middle =
                            -(MediaQuery.sizeOf(context).width) / 2 + 100 / 2;

                        monthSelectorStateKey.currentState
                            ?.scrollTo(middle + (pageOffset - 1) * 100 + 100);
                      },
                      itemBuilder: (contextPageView, index) {
                        return CustomScrollView(
                          slivers: [
                            // 占位空间 不再滚动
                            // SliverPinnedOverlapInjector(
                            //   handle: NestedScrollView
                            //       .sliverOverlapAbsorberHandleFor(
                            //     contextPageView,
                            //   ),
                            // ),
                            CaTransactionList(
                              sliverType: TransactionEntriesRenderType
                                  .implicitlyAnimatedSlivers,
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
