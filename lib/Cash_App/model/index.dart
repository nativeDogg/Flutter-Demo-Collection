/// 交易model
import 'package:flutter_demo_collect/Cash_App/common/ca_enum.dart';

class TransactionModel {
  /// 交易主键（ID）
  final String transactionPk;

  /// 交易名称
  final String name;

  /// 交易种类
  final String? category;

  /// 交易
  final String? transaction;

  /// 交易金额
  final double amount;

  /// 交易日期
  final String? date;

  /// 交易时间
  final String? time;

  /// 是属于收入还是支出
  final bool income;

  /// 交易类型(即将到来\订阅\重复\贷款\债务)
  final TransactionSpecialType? type;
  TransactionModel({
    required this.transactionPk,
    required this.name,
    required this.category,
    required this.transaction,
    required this.amount,
    required this.date,
    required this.time,
    required this.income,
    this.type,
  });

  Map toMap() {
    return {
      'category': category,
      'transaction': transaction,
    };
  }
}

/// 交易种类model
class TransactionCategoryModel {
  /// 种类ID
  final String categoryPk;

  /// 种类名称
  final String name;

  /// 种类颜色
  final String? colour;

  /// 种类图标
  final String? iconName;

  /// 种类emoji图标
  final String? emojiIconName;

  /// 种类创建日期
  final DateTime dateCreated;

  /// 种类修改日期
  final DateTime? dateTimeModified;

  /// 种类排序
  final int order;

  /// 是否是收入
  final bool income;

  // final MethodAdded? methodAdded;
  final String? mainCategoryPk;
  const TransactionCategoryModel({
    required this.categoryPk,
    required this.name,
    this.colour,
    this.iconName,
    this.emojiIconName,
    required this.dateCreated,
    this.dateTimeModified,
    required this.order,
    required this.income,
    // this.methodAdded,
    this.mainCategoryPk,
  });
}

/// 交易种类Model和交易Model合在一起的Model
class TransactionWithCategoryModel {
  final TransactionCategoryModel category;
  final TransactionModel transaction;
  // final TransactionWallet? wallet;
  // final Budget? budget;
  // final Objective? objective;
  // final TransactionCategory? subCategory;
  TransactionWithCategoryModel({
    required this.category,
    required this.transaction,
    // this.wallet,
    // this.budget,
    // this.objective,
    // this.subCategory,
  });

  Map toMap() {
    return {
      // 'category': category.toJson(),
      // 'transaction': transaction.toJson(),
      // 'wallet': wallet,
      // 'budget': budget,
      // 'objective': objective,
      // 'subCategory': subCategory
    };
  }
}

// /// 搜索过滤条件
// class SearchFilter {
//   List<ExpenseIncome> expenseIncome;
//   bool? positiveCashFlow;
//   SearchFilter({
//     this.expenseIncome = const [],
//     this.positiveCashFlow, // 与 isIncome 类似，但包括任何正数（贷款）。
//   }) {
//     expenseIncome = expenseIncome.isEmpty ? [] : expenseIncome;
//     positiveCashFlow = positiveCashFlow;
//   }
// }

/// home页面 饼图数据类型

class CategoryWithTotalModel {
  final TransactionCategoryModel category;
  // final CategoryBudgetLimitModel? categoryBudgetLimit;
  final double total;
  final int transactionCount;

  CategoryWithTotalModel({
    required this.category,
    required this.total,
    this.transactionCount = 0,
    // this.categoryBudgetLimit,
  });

  @override
  String toString() {
    return 'CategoryWithTotal {'
        'category: ${category.name}, '
        'total: $total, '
        '}';
  }

  CategoryWithTotalModel copyWith({
    TransactionCategoryModel? category,
    // CategoryBudgetLimitModel? categoryBudgetLimit,
    double? total,
    int? transactionCount,
  }) {
    return CategoryWithTotalModel(
      category: category ?? this.category,
      // categoryBudgetLimit: categoryBudgetLimit ?? this.categoryBudgetLimit,
      total: total ?? this.total,
      transactionCount: transactionCount ?? this.transactionCount,
    );
  }
}

class CaBudgetModel {
  /// 预算id
  final String budgetPk;

  /// 预算名称
  final String name;

  /// 预算金额
  final double amount;

  /// 预算颜色
  final String? colour;

  /// 预算开始时间
  final DateTime startDate;

  /// 预算结束时间
  final DateTime endDate;

  /// 是否是收入
  final bool income;

  // /// 钱包id
  // final List<String>? walletFks;

  // /// 类别id
  // final List<String>? categoryFks;
  // final List<String>? categoryFksExclude;

  CaBudgetModel({
    required this.budgetPk,
    required this.name,
    required this.amount,
    this.colour,
    required this.startDate,
    required this.endDate,
    this.income = false,
    // this.walletFks,
    // this.categoryFks,
    // this.categoryFksExclude,
  }) {}
}

class Pair {
  Pair(this.x, this.y, {this.dateTime});

  double x;
  double y;
  DateTime? dateTime;

  @override
  String toString() {
    return 'x: $x, y: $y, dateTime: $dateTime';
  }
}
