/// 字符串扩展
extension CapExtension on String {
  /// 首字母大写
  String get capitalizeFirst =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get allCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.capitalizeFirst)
      .join(" ");
}

enum PlatformOS {
  isIOS,
  isAndroid,
  web,
}

// 交易特殊类型
enum TransactionSpecialType {
  /// 即将到来
  upcoming,

  /// 订阅
  subscription,

  /// 重复
  repetitive,

  /// 贷款
  credit,

  /// 债务
  debt
}

/// 收入支出枚举
enum ExpenseIncome {
  income,
  expense,
}

enum BudgetReoccurence { custom, daily, weekly, monthly, yearly }
