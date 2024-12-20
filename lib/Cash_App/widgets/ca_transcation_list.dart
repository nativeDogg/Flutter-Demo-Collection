import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_enum.dart';
import 'package:flutter_demo_collect/Cash_App/model/index.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_transcation_item.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sliver_tools/sliver_tools.dart';

enum TransactionEntriesRenderType {
  slivers,
  sliversNotSticky,
  implicitlyAnimatedSlivers,
  nonSlivers,
  implicitlyAnimatedNonSlivers,
}

final transcationItems = [
  TransactionWithCategory(
    category: TransactionCategoryModel(
      categoryPk: 'C001',
      name: '运动',
      dateCreated: DateTime.now(),
      order: 1,
      income: false,
      iconName: 'sports.png',
      colour: '#f8d295',
    ),
    transaction: TransactionModel(
      transactionPk: 'T001',
      name: '打球🏀',
      category: 'C001',
      type: TransactionSpecialType.credit,
      transaction: '1000',
      amount: 3000,
      date: DateTime.now().microsecondsSinceEpoch.toString(),
      time: DateTime.now().microsecondsSinceEpoch.toString(),
      income: true,
    ),
  ),
  TransactionWithCategory(
    category: TransactionCategoryModel(
      categoryPk: 'C002',
      name: '游泳',
      dateCreated: DateTime.now(),
      order: 1,
      income: false,
      iconName: 'skincare.png',
      colour: '#00FFFF',
    ),
    transaction: TransactionModel(
      transactionPk: 'T002',
      name: '打球🏀',
      category: 'C002',
      type: TransactionSpecialType.credit,
      transaction: '1000',
      amount: 3940,
      date: DateTime.now().microsecondsSinceEpoch.toString(),
      time: DateTime.now().microsecondsSinceEpoch.toString(),
      income: false,
    ),
  ),
  TransactionWithCategory(
    category: TransactionCategoryModel(
      categoryPk: 'C003',
      name: '娱乐',
      dateCreated: DateTime.now(),
      order: 2,
      income: true,
      colour: '#f5bec0',
      iconName: 'orange-juice.png',
    ),
    transaction: TransactionModel(
      transactionPk: 'T003',
      name: '玩电脑💻',
      category: 'C003',
      transaction: '1000',
      amount: 3900,
      date: DateTime.now().microsecondsSinceEpoch.toString(),
      time: DateTime.now().microsecondsSinceEpoch.toString(),
      income: true,
    ),
  )
];

class CaTransactionList extends StatefulWidget {
  final TransactionEntriesRenderType sliverType;
  const CaTransactionList({super.key, required this.sliverType});

  @override
  State<CaTransactionList> createState() => _CaTransactionListState();
}

class _CaTransactionListState extends State<CaTransactionList> {
  // 创建列表
  _buildTransactionList() {
    return Builder(
      builder: (context) {
        List<Widget> widgetOuts = [];
        // 根据各种要求生成widgetOuts
        if (widget.sliverType ==
            TransactionEntriesRenderType.implicitlyAnimatedSlivers) {
          widgetOuts.add(
            SliverStickyHeader(
              header: Transform.translate(
                offset: const Offset(0, -1),
                child: const SizedBox.shrink(),
              ),
              sticky: true,
              sliver: SliverImplicitlyAnimatedList<TransactionWithCategory>(
                // spawnIsolate: false,
                areItemsTheSame: (a, b) =>
                    a.transaction.transactionPk == b.transaction.transactionPk,
                // items: [
                //   TransactionWithCategory(
                //     category: TransactionCategoryModel(
                //       categoryPk: 'C001',
                //       name: '运动',
                //       dateCreated: DateTime.now(),
                //       order: 1,
                //       income: false,
                //     ),
                //     transaction: TransactionModel(
                //       transactionPk: 'T001',
                //       name: '打球🏀',
                //       category: 'C001',
                //       transaction: '1000',
                //       amount: 3000,
                //       date: DateTime.now().microsecondsSinceEpoch.toString(),
                //       time: DateTime.now().microsecondsSinceEpoch.toString(),
                //       income: false,
                //     ),
                //   )
                // ],
                items: transcationItems,
                insertDuration: const Duration(microseconds: 500),
                updateDuration: const Duration(microseconds: 500),
                removeDuration: const Duration(microseconds: 500),
                itemBuilder: (context, animation, item, index) {
                  return SizeFadeTransition(
                    sizeFraction: 0.7,
                    curve: Curves.easeOut,
                    animation: animation,
                    child: _buildTransactionItem(
                      transcationItems,
                      item,
                      index,
                    ),
                  );
                },
              ),
            ),
          );
        }

        if (widget.sliverType ==
            TransactionEntriesRenderType.implicitlyAnimatedSlivers) {
          return MultiSliver(
            children: widgetOuts,
          );
        }

        return MultiSliver(
          children: widgetOuts,
        );
      },
    );
  }

  // 创建单个item
  _buildTransactionItem(items, TransactionWithCategory item, index) {
    // 使用组件
    return CaTranscationItem(
      listID: 'Transaction',
      openPage: Scaffold(
        appBar: AppBar(title: Text('Transcation Details')),
      ),
      transaction: item.transaction,
      category: item.category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTransactionList();
  }
}
