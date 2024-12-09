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
