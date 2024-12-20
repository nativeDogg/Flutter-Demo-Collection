// ignore_for_file: unnecessary_null_comparison

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

/// 根据手机系统获取月份
String getMonth(DateTime dateTime, BuildContext context,
    {bool includeYear = false}) {
  if (includeYear) {
    return DateFormat.yMMMM(Localizations.localeOf(context).toString())
        .format(dateTime);
  }
  return DateFormat.MMMM(Localizations.localeOf(context).toString())
      .format(dateTime);
}

/// 根据手机系统获取主题(亮色、暗色)
// Brightness determineBrightnessTheme(context) {
//   return getSettingConstants(appStateSettings)["theme"] == ThemeMode.system
//       ? MediaQuery.platformBrightnessOf(context)
//       : getSettingConstants(appStateSettings)["theme"] == ThemeMode.light
//           ? Brightness.light
//           : getSettingConstants(appStateSettings)["theme"] == ThemeMode.dark
//               ? Brightness.dark
//               : Brightness.light;
// }

// Map<String, dynamic> getSettingConstants(Map<String, dynamic> userSettings) {
//   Map<String, dynamic> themeSetting = {
//     "system": ThemeMode.system,
//     "light": ThemeMode.light,
//     "dark": ThemeMode.dark,
//     "black": ThemeMode.dark,
//   };

//   Map<String, dynamic> userSettingsNew = {...userSettings};
//   userSettingsNew["theme"] = themeSetting[userSettings["theme"]];
//   userSettingsNew["accentColor"] = HexColor(userSettings["accentColor"]);
//   return userSettingsNew;
// }

/// 将类似:'0xff2196f3'的字符串转为颜色
class HexColor extends Color {
  static int _getColorFromHex(String? hexColor, Color? defaultColor) {
    try {
      if (hexColor == null) {
        if (defaultColor == null) {
          return Colors.grey.value;
        } else {
          return defaultColor.value;
        }
      }
      hexColor = hexColor.replaceAll("#", "");
      hexColor = hexColor.replaceAll("0x", "");
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return int.parse(hexColor, radix: 16);
    } catch (e) {
      return Colors.grey.value;
    }
  }

  HexColor(final String? hexColor, {final Color? defaultColor})
      : super(_getColorFromHex(hexColor, defaultColor));
}

/// 用黑色根据amount比例混合
Color lightenPastel(Color color, {double amount = 0.1}) {
  return Color.alphaBlend(
    Colors.white.withOpacity(amount),
    color,
  );
}

/// 用白色根据amount比例混合
Color darkenPastel(Color color, {double amount = 0.1}) {
  return Color.alphaBlend(
    Colors.black.withOpacity(amount),
    color,
  );
}

/// 根据主题动态调整颜色
Color dynamicPastel(
  BuildContext context,
  Color color, {
  double amount = 0.1,
  bool inverse = false,
  double? amountLight,
  double? amountDark,
}) {
  amountLight ??= amount;
  amountDark ??= amount;

  if (amountLight > 1) {
    amountLight = 1;
  }
  if (amountDark > 1) {
    amountDark = 1;
  }
  if (amount > 1) {
    amount = 1;
  }
  if (inverse) {
    if (Theme.of(context).brightness == Brightness.light) {
      return darkenPastel(color, amount: amountDark);
    } else {
      return lightenPastel(color, amount: amountLight);
    }
  } else {
    if (Theme.of(context).brightness == Brightness.light) {
      return lightenPastel(color, amount: amountLight);
    } else {
      return darkenPastel(color, amount: amountDark);
    }
  }
}

double absoluteZero(double number) {
  if (number == -0) return number.abs();
  return number;
}

double? absoluteZeroNull(double? number) {
  if (number == null) return null;
  if (number == -0) return number.abs();
  return number;
}

String removeTrailingZeroes(String input) {
  if (!input.contains('.')) {
    return input;
  }
  int index = input.length - 1;
  while (input[index] == '0') {
    index--;
  }
  if (input[index] == '.') {
    index--;
  }
  return input.substring(0, index + 1);
}

int countNonTrailingZeroes(String input) {
  int decimalIndex = input.indexOf('.');

  if (decimalIndex == -1) {
    return 0;
  }

  int count = 0;
  for (int i = decimalIndex + 1; i < input.length; i++) {
    if (input[i] != '0') {
      count++;
    } else if (count > 0) {
      break;
    }
  }

  return count;
}

String absoluteZeroString(String number) {
  if (number == "-0") return "0";
  return number;
}

/// 将amount 变成百分比
String convertToPercent(double amount,
    {double? finalNumber,
    int? numberDecimals,
    bool useLessThanZero = false,
    bool shouldRemoveTrailingZeroes = false}) {
  amount = absoluteZero(amount);
  finalNumber = absoluteZeroNull(finalNumber);

  if (amount.isNaN || amount == 0 || finalNumber == 0) return "0%";

  int numberDecimalsGet = numberDecimals ?? 0;

  String roundedAmount = amount.toStringAsFixed(numberDecimalsGet);

  // 去除尾随零
  if (shouldRemoveTrailingZeroes) {
    if (finalNumber != null) {
      int finalTrailingZeroes = countNonTrailingZeroes(
          finalNumber.toStringAsFixed(numberDecimalsGet));
      roundedAmount = finalNumber
          .toStringAsFixed(max(finalTrailingZeroes, numberDecimalsGet));
    } else {
      roundedAmount = removeTrailingZeroes(roundedAmount);
    }
  }

  // 小于0的情况
  if (useLessThanZero &&
      roundedAmount == "0" &&
      (finalNumber == null && amount.abs() != 0 ||
          finalNumber != null && finalNumber.abs() != 0)) {
    if (numberDecimalsGet == 0) {
      if (finalNumber == null && amount < 0 || finalNumber! < 0.0) {
        roundedAmount = "< -1";
      } else {
        roundedAmount = "< 1";
      }
    } else if (numberDecimalsGet == 1) {
      if (finalNumber == null && amount < 0.1 ||
          finalNumber != null && finalNumber < 0.1) {
        roundedAmount = "< -0.1";
      } else {
        roundedAmount = "< 0.1";
      }
    } else if (numberDecimalsGet == 2) {
      if (finalNumber == null && amount < 0.01 ||
          finalNumber != null && finalNumber < 0.01) {
        roundedAmount = "< -0.01";
      } else {
        roundedAmount = "< 0.01";
      }
    }
  }

  return absoluteZeroString(roundedAmount) + "%";
}

/// 将数字转成金额的格式

String convertToMoney(double amount,
    {String? currencyKey,
    double? finalNumber,
    int? decimals,
    bool? allDecimals,
    bool? addCurrencyName,
    bool forceHideCurrencyName = false,
    bool forceAllDecimals = false,
    bool forceNonCustomNumberFormat = false,
    bool forceCustomNumberFormat = false,
    String? customSymbol,
    String Function(String)? editFormattedOutput,
    bool forceCompactNumberFormatter = false,
    bool forceDefaultNumberFormatter = false,
    bool forceAbsoluteZero = true,
    NumberFormat Function(int? decimalDigits, String? locale, String? symbol)?
        getCustomNumberFormat}) {
  int numberDecimals = decimals ?? 2;
  numberDecimals = numberDecimals > 2 &&
          (finalNumber ?? amount).toString().split('.').length > 1
      ? (finalNumber ?? amount).toString().split('.')[1].length < numberDecimals
          ? (finalNumber ?? amount).toString().split('.')[1].length
          : numberDecimals
      : numberDecimals;

  if (amount == double.infinity || amount == double.negativeInfinity) {
    return "Infinity";
  }
  amount = double.parse(amount.toStringAsFixed(numberDecimals));
  if (forceAbsoluteZero) amount = absoluteZero(amount);
  if (finalNumber != null) {
    finalNumber = double.parse(finalNumber.toStringAsFixed(numberDecimals));
    if (forceAbsoluteZero) finalNumber = absoluteZero(finalNumber);
  }

  int? decimalDigits = forceAllDecimals
      ? decimals
      // : allDecimals == true ||
      //         hasDecimalPoints(finalNumber) ||
      //         hasDecimalPoints(amount)
      //     ? numberDecimals
      //     : 0;
      : 0;
  String? locale = "en-US";

  String? symbol = customSymbol ?? '';

  bool useCustomNumberFormat =
      forceCustomNumberFormat || (forceNonCustomNumberFormat == false);

  final NumberFormat formatter;
  if (getCustomNumberFormat != null) {
    formatter = getCustomNumberFormat(
        decimalDigits, locale, useCustomNumberFormat ? "" : symbol);
  } else if (forceDefaultNumberFormatter == false &&
      (forceCompactNumberFormatter)) {
    formatter = NumberFormat.compactCurrency(
      locale: locale,
      decimalDigits: decimalDigits,
      symbol: useCustomNumberFormat ? "" : symbol,
    );
    formatter.significantDigitsInUse = false;
  } else {
    /// 主要是使用NumberFormat.currency来格式化数字
    formatter = NumberFormat.currency(
      decimalDigits: decimalDigits,
      locale: locale,
      symbol: useCustomNumberFormat ? "" : symbol,
    );
  }
  String formatOutput = formatter.format(amount).trim();

  // View the entire dictionary of locale formats, through NumberFormat.currency definition
  // numberFormatSymbols[locale] as NumberSymbols

  // If there is no currency symbol, use the currency code
  // if (forceHideCurrencyName == false &&
  //     getCurrencyString(allWallets, currencyKey: currencyKey) == "") {
  //   addCurrencyName = true;
  // }
  // String formatOutput = formatter.format(amount).trim();
  // String? currencyName;
  // if (addCurrencyName == true && currencyKey != null) {
  //   currencyName = " " + currencyKey.toUpperCase();
  // } else if (addCurrencyName == true) {
  //   currencyName = " " +
  //       (allWallets.indexedByPk[appStateSettings["selectedWalletPk"]]
  //                   ?.currency ??
  //               "")
  //           .toUpperCase();
  // }

  // if (useCustomNumberFormat) {
  //   formatOutput = formatOutputWithNewDelimiterAndDecimal(
  //     amount: finalNumber ?? amount,
  //     currencyName: currencyName,
  //     input: formatOutput,
  //     delimiter: appStateSettings["numberFormatDelimiter"],
  //     decimal: appStateSettings["numberFormatDecimal"],
  //     symbol: symbol,
  //   );
  // } else if (useCustomNumberFormat == false && currencyName != null) {
  //   formatOutput = formatOutput + currencyName;
  // }

  // if (editFormattedOutput != null) {
  //   return editFormattedOutput(formatOutput);
  // }

  return formatOutput;
}

String getWordedDateShort(
  DateTime date,
  BuildContext context, {
  includeYear = false,
  showTodayTomorrow = true,
  lowerCaseTodayTomorrow = false,
}) {
  if (showTodayTomorrow && checkYesterdayTodayTomorrow(date) != false) {
    String todayTomorrowOut = checkYesterdayTodayTomorrow(date);
    return lowerCaseTodayTomorrow
        ? todayTomorrowOut.toLowerCase()
        : todayTomorrowOut;
  }

  // final locale = navigatorKey.currentContext?.locale.toString();

  final locale = Localizations.localeOf(context).toString();

  if (includeYear) {
    return DateFormat.yMMMd(locale).format(date);
  } else {
    return DateFormat.MMMd(locale).format(date);
  }
}

checkYesterdayTodayTomorrow(DateTime date) {
  DateTime now = DateTime.now();
  if (date.day == now.day && date.month == now.month && date.year == now.year) {
    return "today";
  }
  DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
  if (date.day == tomorrow.day &&
      date.month == tomorrow.month &&
      date.year == tomorrow.year) {
    return "tomorrow";
  }
  DateTime yesterday = now.subtract(Duration(days: 1));
  if (date.day == yesterday.day &&
      date.month == yesterday.month &&
      date.year == yesterday.year) {
    return "yesterday";
  }

  return false;
}
