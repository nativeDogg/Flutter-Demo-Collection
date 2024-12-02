// 交易model
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

// 交易种类model
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
  const TransactionCategoryModel(
      {required this.categoryPk,
      required this.name,
      this.colour,
      this.iconName,
      this.emojiIconName,
      required this.dateCreated,
      this.dateTimeModified,
      required this.order,
      required this.income,
      // this.methodAdded,
      this.mainCategoryPk});
}

/// 交易种类Model和交易Model合在一起的Model

class TransactionWithCategory {
  final TransactionCategoryModel category;
  final TransactionModel transaction;
  // final TransactionWallet? wallet;
  // final Budget? budget;
  // final Objective? objective;
  // final TransactionCategory? subCategory;
  TransactionWithCategory({
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
