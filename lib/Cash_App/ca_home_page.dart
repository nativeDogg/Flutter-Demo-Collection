import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/ca_home_transcation_budget.dart';
import 'package:flutter_demo_collect/Cash_App/ca_home_transcation_chart.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_enum.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_function.dart';
import 'package:flutter_demo_collect/Cash_App/model/index.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_home_page/transaction_list/ca_selector_income_expense.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_home_page/transaction_list/ca_view_all_transaction.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_transcation_list.dart';

class CaHomePage extends StatefulWidget {
  const CaHomePage({super.key});

  @override
  State<CaHomePage> createState() => _CaHomePageState();
}

class _CaHomePageState extends State<CaHomePage> {
  /// 交易列表的类型
  int selectedSlidingSelector = 1;

  Widget homePageTransactionBudget() {
    return CaHomeTranscationBudget();
  }

  /// HOME页面的交易chart列表
  Widget homePageTransactionChart() {
    return const CaHomeTranscationChart();
  }

  /// HOME页面的交易列表
  Widget homePageTransactionList() {
    return Container(
      // margin: const EdgeInsets.only(top: kToolbarHeight),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        // 希望 Column 只占据其子小部件所需的空间，你可以这样设置：
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSlidingSelector(),
          const SizedBox(height: 8),
          Expanded(child: _buildHomeTransactionList()),
          const SizedBox(height: 8),
          _buildViewAllTransaction(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSlidingSelector() {
    return CaSelectorIncomeExpense(
      onSelected: (index) {
        setState(() {
          selectedSlidingSelector = index;
        });
      },
    );
  }

  Widget _buildHomeTransactionList() {
    SearchFilters searchFilters = SearchFilters(
      expenseIncome: [
        if (selectedSlidingSelector == 1) ...[
          ExpenseIncome.expense,
          ExpenseIncome.income,
        ],
        if (selectedSlidingSelector == 2) ExpenseIncome.expense,
        if (selectedSlidingSelector == 3) ExpenseIncome.income,
      ],
      positiveCashFlow: selectedSlidingSelector == 2
          ? false
          : selectedSlidingSelector == 3
              ? true
              : null,
    );
    return CaTransactionList(
      sliverType: TransactionEntriesRenderType.implicitlyAnimatedNonSlivers,
      searchFilters: searchFilters,
    );
  }

  Widget _buildViewAllTransaction() {
    return CaViewAllTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: ScrollbarWrap(
            child: ListView(
              children: [
                homePageTransactionBudget(),
                homePageTransactionChart(),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: homePageTransactionList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ScrollbarWrap extends StatelessWidget {
  const ScrollbarWrap({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeLeft: true,
      removeRight: true,
      child: RawScrollbar(
        thumbColor: dynamicPastel(
          context,
          Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.3),
          amountDark: 0.3,
        ),
        radius: Radius.circular(20),
        thickness: 3,
        child: child,
      ),
    );
  }
}
