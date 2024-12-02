import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_sliver.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_month_selector.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_multi_direction_infinite_scroll.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_transcation_list.dart';
import 'package:sliver_tools/sliver_tools.dart';

class CashAppHomePage extends StatefulWidget {
  const CashAppHomePage({super.key});

  @override
  State<CashAppHomePage> createState() => _CashAppHomePageState();
}

class _CashAppHomePageState extends State<CashAppHomePage> {
  // 将MonthSelector的状态类从_MonthSelectorState变成MonthSelectorState公有访问 用于在调用MonthSelector的setSelectedDateStart时 可以同时调用外层的setSelectedDateStart
  GlobalKey<MonthSelectorState> monthSelectorStateKey = GlobalKey();

  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 1000000);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).canvasColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).canvasColor,
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
                        title: Text('交易'),
                        actions: [
                          IconButton(
                            tooltip: '过滤条件',
                            onPressed: () {
                              // selectFilters(context);
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
