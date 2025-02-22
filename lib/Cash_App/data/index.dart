import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_enum.dart';
import 'package:flutter_demo_collect/Cash_App/model/index.dart';

/// 只有收入交易数据的list
final List<TransactionWithCategoryModel> onlyIncomeTranList = [
  TransactionWithCategoryModel(
    category: TransactionCategoryModel(
      categoryPk: 'C001',
      name: '收入-睡觉',
      dateCreated: DateTime.now(),
      order: 1,
      income: true,
      iconName: 'sports.png',
      colour: '#f8d295',
    ),
    transaction: TransactionModel(
      transactionPk: 'T001',
      name: '收入-运动',
      category: 'C001',
      type: TransactionSpecialType.credit,
      transaction: '1000',
      amount: 3000,
      date: DateTime.now().microsecondsSinceEpoch.toString(),
      time: DateTime.now().microsecondsSinceEpoch.toString(),
      income: true,
    ),
  ),
  TransactionWithCategoryModel(
    category: TransactionCategoryModel(
      categoryPk: 'C002',
      name: '收入-护肤',
      dateCreated: DateTime.now(),
      order: 1,
      income: true,
      iconName: 'skincare.png',
      colour: '#00FFFF',
    ),
    transaction: TransactionModel(
      transactionPk: 'T002',
      name: '收入-打球🏀',
      category: 'C002',
      type: TransactionSpecialType.credit,
      transaction: '1000',
      amount: 3940,
      date: DateTime.now().microsecondsSinceEpoch.toString(),
      time: DateTime.now().microsecondsSinceEpoch.toString(),
      income: true,
    ),
  ),
  TransactionWithCategoryModel(
    category: TransactionCategoryModel(
      categoryPk: 'C003',
      name: '收入-娱乐',
      dateCreated: DateTime.now(),
      order: 2,
      income: true,
      colour: '#f5bec0',
      iconName: 'orange-juice.png',
    ),
    transaction: TransactionModel(
      transactionPk: 'T003',
      name: '收入-玩电脑💻',
      category: 'C003',
      transaction: '1000',
      amount: 3900,
      date: DateTime.now().microsecondsSinceEpoch.toString(),
      time: DateTime.now().microsecondsSinceEpoch.toString(),
      income: true,
    ),
  )
];

/// 只有收入交易数据的list
final List<TransactionWithCategoryModel> onlyExpenseTranList = [
  TransactionWithCategoryModel(
    category: TransactionCategoryModel(
      categoryPk: 'C001',
      name: '支出-睡觉',
      dateCreated: DateTime.now(),
      order: 1,
      income: false,
      iconName: 'sports.png',
      colour: '#f8d295',
    ),
    transaction: TransactionModel(
      transactionPk: 'T001',
      name: '支出-运动',
      category: 'C001',
      type: TransactionSpecialType.credit,
      transaction: '1000',
      amount: 3000,
      date: DateTime.now().microsecondsSinceEpoch.toString(),
      time: DateTime.now().microsecondsSinceEpoch.toString(),
      income: false,
    ),
  ),
  TransactionWithCategoryModel(
    category: TransactionCategoryModel(
      categoryPk: 'C002',
      name: '支出-护肤',
      dateCreated: DateTime.now(),
      order: 1,
      income: false,
      iconName: 'skincare.png',
      colour: '#00FFFF',
    ),
    transaction: TransactionModel(
      transactionPk: 'T002',
      name: '支出-打球🏀',
      category: 'C002',
      type: TransactionSpecialType.credit,
      transaction: '1000',
      amount: 3940,
      date: DateTime.now().microsecondsSinceEpoch.toString(),
      time: DateTime.now().microsecondsSinceEpoch.toString(),
      income: false,
    ),
  ),
  TransactionWithCategoryModel(
    category: TransactionCategoryModel(
      categoryPk: 'C003',
      name: '支出-娱乐',
      dateCreated: DateTime.now(),
      order: 2,
      income: false,
      colour: '#f5bec0',
      iconName: 'orange-juice.png',
    ),
    transaction: TransactionModel(
      transactionPk: 'T003',
      name: '支出-玩电脑💻',
      category: 'C003',
      transaction: '1000',
      amount: 3900,
      date: DateTime.now().microsecondsSinceEpoch.toString(),
      time: DateTime.now().microsecondsSinceEpoch.toString(),
      income: false,
    ),
  ),
  TransactionWithCategoryModel(
    category: TransactionCategoryModel(
      categoryPk: 'C003',
      name: '支出-打牌',
      dateCreated: DateTime.now(),
      order: 2,
      income: false,
      colour: '##b7d9b4',
      iconName: 'atm-machine(2).png',
    ),
    transaction: TransactionModel(
      transactionPk: 'T003',
      name: '支出-打牌',
      category: 'C003',
      transaction: '1000',
      amount: 3900,
      date: DateTime.now().microsecondsSinceEpoch.toString(),
      time: DateTime.now().microsecondsSinceEpoch.toString(),
      income: false,
    ),
  )
];

/// 种类列表
List<TransactionCategoryModel> categoryList = [
  TransactionCategoryModel(
    categoryPk: '10',
    name: '旅行',
    dateCreated: DateTime.now(),
    colour: '#f4ba61',
    order: 10,
    income: false,
    iconName: 'plane.png',
  ),
  TransactionCategoryModel(
    categoryPk: '6',
    name: '定期账单与费用',
    dateCreated: DateTime.now(),
    order: 0,
    colour: '#91c58a',
    income: false,
    iconName: 'bills.png',
  ),
  TransactionCategoryModel(
    categoryPk: '1',
    name: '三餐',
    dateCreated: DateTime.now(),
    order: 8,
    income: false,
    colour: '#94a3ad',
    iconName: 'cutlery.png',
  ),
  TransactionCategoryModel(
    categoryPk: '5',
    name: '娱乐',
    dateCreated: DateTime.now(),
    order: 4,
    income: false,
    colour: '#78b3f0',
    iconName: 'popcorn.png',
  ),
  TransactionCategoryModel(
    categoryPk: '9',
    name: '交通',
    dateCreated: DateTime.now(),
    order: 4,
    income: false,
    colour: '#fdf288',
    iconName: 'sports.png',
  ),
  TransactionCategoryModel(
    categoryPk: '14',
    name: '礼物',
    dateCreated: DateTime.now(),
    order: 4,
    income: false,
    colour: '#e78277',
    iconName: 'envelope.png',
  ),
  TransactionCategoryModel(
    categoryPk: '12',
    name: '美妆',
    dateCreated: DateTime.now(),
    order: 4,
    income: false,
    colour: '#ae6cc2',
    iconName: 'shopping.png',
  )
];

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
  CategoryWithTotalModel(
    category: TransactionCategoryModel(
      categoryPk: '14',
      name: '礼物',
      dateCreated: DateTime.now(),
      order: 4,
      income: false,
      colour: '#e78277',
      iconName: 'envelope.png',
    ),
    total: 388.00,
  ),
  CategoryWithTotalModel(
    category: TransactionCategoryModel(
      categoryPk: '12',
      name: '美妆',
      dateCreated: DateTime.now(),
      order: 4,
      income: false,
      colour: '#ae6cc2',
      iconName: 'shopping.png',
    ),
    total: 666.00,
  ),
];

// 搜索条件
class SearchFilters {
  // 是收入还是支出
  List<ExpenseIncome> expenseIncome;
  // 是否为正数（贷款）
  bool? positiveCashFlow;
  // 交易类型
  List<TransactionSpecialType> transactionTypes;
  // 交易金额范围
  RangeValues? amountRange;
  SearchFilters({
    this.expenseIncome = const [],
    this.positiveCashFlow, // 与 isIncome 类似，但包括任何正数（贷款）。
    this.transactionTypes = const [],
    this.amountRange = const RangeValues(0, 1000000),
  }) {
    expenseIncome = expenseIncome.isEmpty ? [] : expenseIncome;
    positiveCashFlow = positiveCashFlow;
    transactionTypes = transactionTypes.isEmpty ? [] : transactionTypes;
  }

  /// 清空参数
  void clearSearchFilters() {}
}
