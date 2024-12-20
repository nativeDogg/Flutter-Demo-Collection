import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_animate.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_enum.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_tappable.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_function.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_text_font.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_widgets.dart';
import 'package:flutter_demo_collect/Cash_App/model/index.dart';
import 'package:flutter_demo_collect/Cash_App/router/index.dart';
import 'package:flutter_demo_collect/Cash_App/struct/listenableSelector.dart';
import 'package:flutter_demo_collect/Cash_App/widgets_common/objective_page.dart';

/// 全局所有选中项的ID
ValueNotifier<Map<String, List<String>>> globalSelectedID =
    ValueNotifier<Map<String, List<String>>>({});

class CaTranscationItem extends StatelessWidget {
  /// 用于在GlobalSelectedID中的key 通过此key来获取对应的selectedID集合
  final String? listID;

  /// 点击单个item打开的页面
  final Widget openPage;

  /// 交易信息
  final TransactionModel transaction;

  /// 交易类型
  final TransactionCategoryModel category;

  /// 是否允许选中
  final bool? allowSelect;

  final TransactionModel? transactionBefore;
  final TransactionModel? transactionAfter;
  final Function(TransactionModel transaction, bool selected)? onSelected;

  const CaTranscationItem({
    super.key,
    required this.openPage,
    required this.transaction,
    required this.category,
    this.allowSelect,
    this.listID,
    this.transactionBefore,
    this.transactionAfter,
    this.onSelected,
  });

  // 交易项的内容
  Widget _buildTransactionContents(
    context, {
    required VoidCallback openContainer,
    required bool selected,
    required bool? areTransactionsBeingSelected,
  }) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 7),
        child: Row(
          children: [
            // 选中按钮
            _buildTransactionCheck(
              selected: selected,
              areTransactionsBeingSelected: areTransactionsBeingSelected,
              openContainer: openContainer,
            ),
            // 类型图标
            _buildCategoryIcon(),
            // 处理按钮 撤销操作等
            _buildActionBtn(
                context,
                const EdgeInsetsDirectional.only(
                  start: 3,
                  top: 5,
                  bottom: 5,
                  end: 0,
                )),
            // 交易名称以及各种预算类型tag
            _buildCategoryName(),

            const Spacer(),
            _buildCategoryAmount(),
          ],
        ),
      ),
    );
  }

  // 选中按钮
  Widget _buildTransactionCheck({
    required VoidCallback openContainer,
    required bool selected,
    required bool? areTransactionsBeingSelected,
  }) {
    return _TransactionSelectionCheck(
      areTransactionsBeingSelected: areTransactionsBeingSelected,
      selected: selected,
      transaction: transaction,
      listID: listID,
      selectTransaction: selectTransaction,
    );
  }

  // 类型图标
  Widget _buildCategoryIcon() {
    return SizedBox(
      child: TransactionCategoryIcon(
        category: category,
        size: 27,
        sizePadding: 20,
        margin: EdgeInsetsDirectional.zero,
        borderRadius: 100,
        onTap: () {},
        // tintColor: categoryTintColor,
      ),
    );
  }

  // 处理按钮 撤销操作等
  Widget _buildActionBtn(BuildContext context, EdgeInsetsDirectional padding) {
    return _TransactionActionButton(
      category: category,
      padding: padding,
      transaction: transaction,
      iconColor: dynamicPastel(
        context,
        Theme.of(context).colorScheme.primary,
        amount: 0.3,
      ),
      containerColor: Theme.of(context).canvasColor,
      // allowOpenIntoObjectiveLoanPage: allowOpenIntoObjectiveLoanPage,
      allowOpenIntoObjectiveLoanPage: false,
    );
  }

  /// 交易名称以及各种预算类型tag
  Widget _buildCategoryName() {
    // 交易名称
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: _TransactionTitleName(
        transaction: transaction,
        fontSize: 16,
      ),
    );
  }

  /// 交易金额
  Widget _buildCategoryAmount() {
    return _TransactionEntryAmount(
      transaction: transaction,
      showOtherCurrency: true,
      unsetCustomCurrency: true,
    );
  }

  /// 长按选中交易
  selectTransaction(

      /// 交易item
      TransactionModel transaction,

      /// 是否被选中
      bool selected,

      /// 是否激活选中状态
      bool isSwiping) {
    if (allowSelect == false) return;
    // 之前没有被选中则选中
    if (!selected) {
      globalSelectedID.value[listID ?? "0"]!.add(transaction.transactionPk);
      // if (isSwiping) selectingTransactionsActive = 1;
    }
    // 之前被选中则取消选中
    else {
      globalSelectedID.value[listID ?? "0"]!.remove(transaction.transactionPk);
    }
    globalSelectedID.notifyListeners();

    if (onSelected != null) onSelected!(transaction, selected);
  }

  @override
  Widget build(BuildContext context) {
    bool enableSelectionCheckMark = Platform.isIOS;
    if (globalSelectedID.value[listID ?? "0"] == null) {
      globalSelectedID.value[listID ?? "0"] = [];
    }

    return ValueListenableBuilder(
      /// 下面的逻辑控制选中状态
      valueListenable: enableSelectionCheckMark
          ? globalSelectedID.select(
              (controller) => (controller.value[listID ?? "0"] ?? []).length)
          : globalSelectedID.select(
              (controller) =>
                  (transactionBefore != null &&
                          controller.value[listID ?? "0"]!
                              .contains(transactionBefore?.transactionPk))
                      .toString() +
                  (controller.value[listID ?? "0"]!
                          .contains(transaction.transactionPk))
                      .toString() +
                  (transactionAfter != null &&
                          controller.value[listID ?? "0"]!
                              .contains(transactionAfter?.transactionPk))
                      .toString(),
            ),
      builder: (context, _, __) {
        // print(globalSelectedID.value['Transaction']);
        bool selected = globalSelectedID.value[listID ?? "0"]!
            .contains(transaction.transactionPk);
        bool? areTransactionsBeingSelected =
            globalSelectedID.value[listID ?? "0"]?.isNotEmpty;
        return Tappable(
          // onTap: () => openPage,
          onLongPress: () => selectTransaction(transaction, selected, false),
          // 长按选中交易
          child: _buildTransactionContents(
            context,
            openContainer: () => openPage,
            selected: selected,
            areTransactionsBeingSelected: areTransactionsBeingSelected,
          ),
        );
      },
    );
  }
}

/// 交易选中按钮
class _TransactionSelectionCheck extends StatelessWidget {
  final bool selected;
  final bool? areTransactionsBeingSelected;
  final String? listID;
  final dynamic transaction;
  final Function(TransactionModel transaction, bool selected, bool isSwiping)
      selectTransaction;
  const _TransactionSelectionCheck({
    super.key,
    required this.selected,
    required this.areTransactionsBeingSelected,
    this.listID,
    required this.transaction,
    required this.selectTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOutCubicEmphasized,
      // 选中的时候出现
      child: selected || areTransactionsBeingSelected == true
          // 缩放出现
          ? ScaleIn(
              key: ValueKey(areTransactionsBeingSelected),
              curve: Curves.easeInOutCubicEmphasized,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 10,
                ),
                child: GestureDetector(
                  // 拖动选中
                  onVerticalDragStart: (_) {},
                  child: Tappable(
                    borderRadius: 100,
                    // 选中
                    onTap: () {
                      selectTransaction(transaction, selected, false);
                    },
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 0, vertical: 12),
                      child: ScaledAnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        keyToWatch: selected.toString(),
                        child: Transform.scale(
                          scale: selected ? 1 : 0.95,
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  selected ? Colors.blue : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: selected
                                    ? Colors.transparent
                                    : Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.8),
                              ),
                            ),
                            padding: const EdgeInsetsDirectional.all(2),
                            child: Icon(
                              Icons.check,
                              size: 14,
                              color: selected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}

/// 交易类型图标
class TransactionCategoryIcon extends StatelessWidget {
  const TransactionCategoryIcon({
    super.key,
    required this.size,
    required this.category,
    this.label = false,
    this.labelSize = 10,
    this.margin,
    this.sizePadding = 20,
    this.outline = false,
    this.noBackground = false,
    this.borderRadius = 18,
    this.onLongPress,
    this.onTap,
  });

  /// 交易类型
  final TransactionCategoryModel category;

  /// 尺寸
  final double size;

  /// 是否有类型label
  final bool label;

  /// label的尺寸
  final double labelSize;

  /// 外边距
  final EdgeInsetsDirectional? margin;

  /// 内边距
  final double sizePadding;
  final bool outline;

  /// 是否无背景
  final bool noBackground;

  /// 圆角
  final double borderRadius;

  /// 长按事件
  final VoidCallback? onLongPress;

  /// 点击事件
  final VoidCallback? onTap;

  /// 边距
  // final EdgeInsetsDirectional? margin;

  Widget _buildContent(context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: margin ??
              EdgeInsetsDirectional.only(
                start: 12,
                end: 8,
                top: 8,
                bottom: label ? 2 : 8,
              ),
          height: size + sizePadding,
          width: size + sizePadding,
          decoration: outline
              ? BoxDecoration(
                  border: Border.all(
                    color: dynamicPastel(
                        context,
                        HexColor(category.colour,
                            defaultColor:
                                Theme.of(context).colorScheme.primary),
                        amountLight: 0.5,
                        amountDark: 0.4,
                        inverse: true),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                )
              : BoxDecoration(
                  border: Border.all(
                    color: Colors.transparent,
                    width: 0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            child: Tappable(
              onTap: onTap,
              color: noBackground
                  ? Colors.transparent
                  : dynamicPastel(
                      context,
                      HexColor(category.colour,
                          defaultColor: Theme.of(context).colorScheme.primary),
                      amountLight: 0.55,
                      amountDark: 0.35,
                    ),
              // emoji图标
              child: Center(
                child:
                    (category.emojiIconName == null && category.iconName != null
                        ? CacheCategoryIcon(
                            iconName: category.iconName ?? "",
                            size: size,
                          )
                        : const SizedBox()),
              ),
            ),
          ),
        )
        // Stack(
        //   alignment: AlignmentDirectional.center,
        //   children: [
        //     ClipRRect(
        //       borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        //       child: AnimatedContainer(
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(borderRadius),
        //         ),
        //         duration: const Duration(milliseconds: 1000),
        //         margin: EdgeInsetsDirectional.only(
        //           start: 12,
        //           end: 12,
        //           top: 12,
        //           bottom: label ? 2 : 12,
        //         ),
        //         height: size + sizePadding,
        //         width: size + sizePadding,
        //         child: Tappable(
        //           color: noBackground
        //               ? Colors.transparent
        //               : dynamicPastel(
        //                   context,
        //                   HexColor(category.colour,
        //                       defaultColor:
        //                           Theme.of(context).colorScheme.primary),
        //                   amountLight: 0.55,
        //                   amountDark: 0.35,
        //                 ),
        //           // emoji图标
        //           // child: SizedBox(),
        //           child: Center(
        //             child: (category.emojiIconName == null &&
        //                     category.iconName != null
        //                 ? CacheCategoryIcon(
        //                     iconName: category.iconName ?? "",
        //                     size: size,
        //                   )
        //                 : const SizedBox()),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: Colors.white,
      clipBehavior: Clip.none,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOutCubicEmphasized,
      child: _buildContent(context),
    );
  }
}

/// 处理按钮 撤销操作
class _TransactionActionButton extends StatelessWidget {
  const _TransactionActionButton({
    super.key,
    required this.category,
    required this.transaction,
    required this.iconColor,
    required this.allowOpenIntoObjectiveLoanPage,
    this.containerColor,
    required this.padding,
  });

  final TransactionModel transaction;
  final TransactionCategoryModel category;
  final Color iconColor;
  final Color? containerColor;
  final bool allowOpenIntoObjectiveLoanPage;
  final EdgeInsetsDirectional padding;

  IconData getTransactionTypeIcon(TransactionSpecialType? selectedType) {
    if (selectedType == null) {
      return Icons.payments_rounded;
    } else if (selectedType == TransactionSpecialType.upcoming) {
      return Icons.event_rounded;
    } else if (selectedType == TransactionSpecialType.subscription) {
      return Icons.event_repeat_rounded;
    } else if (selectedType == TransactionSpecialType.repetitive) {
      return Icons.repeat_rounded;
    } else if (selectedType == TransactionSpecialType.debt) {
      return Icons.archive_rounded;
    } else if (selectedType == TransactionSpecialType.credit) {
      return Icons.unarchive_rounded;
    }
    return Icons.event_repeat_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (transaction.type != null)
          _ActionButton(
            padding: padding,

            /// 是否已经处理此交易
            dealtWith: false,

            /// tooltip的message
            message: '收款/付款',
            // onTap: () => {},
            onTap: () => pushRoute(
              context,
              ObjectivePage(
                category: category,
              ),
            ),
            containerColor: containerColor,
            iconColor: iconColor,

            iconData: getTransactionTypeIcon(transaction.type),
          ),
        // const SizedBox(width: 5),
        _ActionButton(
          padding: padding,
          dealtWith: false,
          message: '贷款/债务',
          onTap: () {},
          containerColor: containerColor,
          iconColor: iconColor,
          iconData: getTransactionTypeIcon(TransactionSpecialType.upcoming),
        ),
      ],
    );
  }
}

/// 操作按钮 用于_TransactionActionButton中
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.dealtWith,
    required this.message,
    required this.onTap,
    required this.containerColor,
    required this.iconColor,
    required this.iconData,
    required this.padding,
  });

  /// 是否已处理
  final bool dealtWith;

  /// tooltip信息
  final String message;

  /// 点击事件
  final VoidCallback onTap;

  /// 完成状态的的颜色
  final Color? containerColor;

  /// 未完成状态的颜色
  final Color iconColor;

  /// icon
  final IconData iconData;

  /// 内边距
  final EdgeInsetsDirectional padding;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: padding,

          /// 统一缩放比例，不然会显得不协调
          child: Transform.scale(
            scale: dealtWith ? 0.92 : 1,
            child: Tappable(
              color: !dealtWith
                  ? Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.6)
                  : iconColor.withOpacity(0.7),
              onTap: onTap,
              borderRadius: 100,
              child: Padding(
                padding: const EdgeInsetsDirectional.all(6),
                child: Icon(
                  iconData,
                  color: dealtWith
                      ? (containerColor ?? Theme.of(context).canvasColor)
                      : iconColor.withOpacity(0.8),
                  size: 23,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 交易item名称
class _TransactionTitleName extends StatelessWidget {
  const _TransactionTitleName(
      {required this.transaction, required this.fontSize, super.key});
  final TransactionModel transaction;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextFont(
      text: transaction.name.capitalizeFirst,
      fontSize: fontSize,
      maxLines: 1,
      overflow: TextOverflow.fade,
      softWrap: false,
    );
  }
}

/// 交易item金额
class _TransactionEntryAmount extends StatelessWidget {
  const _TransactionEntryAmount({
    super.key,
    required this.transaction,
    required this.showOtherCurrency,
    required this.unsetCustomCurrency,
  });

  final TransactionModel transaction;
  final bool showOtherCurrency;
  final bool unsetCustomCurrency;

  @override
  Widget build(BuildContext context) {
    // print('我是是否收入:${transaction.income}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// 最终金额
        Row(
          children: [
            CountNumber(
              count: transaction.amount,
              textBuilder: (amount) {
                return Row(
                  children: [
                    AnimatedSizeSwitcher(
                      child: InOutComeArrow(
                        isIncome: transaction.income,
                      ),
                    ),
                    TextFont(
                      text: 'RMB${transaction.amount.toString()}',
                      fontSize: 19 - (showOtherCurrency ? 1 : 0),
                      fontWeight: FontWeight.bold,
                      textColor: transaction.income
                          ? const Color(0xFF59A849)
                          : const Color(0xFFCA5A5A),
                    ),
                  ],
                );
              },
            )
          ],
        ),

        /// 原本价格
      ],
    );
  }
}

class InOutComeArrow extends StatelessWidget {
  const InOutComeArrow({
    super.key,
    required this.isIncome,
    this.color,
    this.iconSize,
    this.width,
    this.height,
  });

  /// 是否是收入
  final bool isIncome;

  /// 颜色
  final Color? color;

  /// 箭头大小
  final double? iconSize;

  /// 箭头宽度
  final double? width;

  /// 箭头高度
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: isIncome ? 0.5 : 0,
      duration: const Duration(milliseconds: 800),
      curve: const ElasticInCurve(0.5),
      child: SizedBox(
        width: width,
        height: height,
        child: UnconstrainedBox(
          clipBehavior: Clip.hardEdge,
          alignment: AlignmentDirectional.center,
          child: Icon(
            Icons.arrow_drop_down_outlined,
            color: color ??
                (isIncome ? const Color(0xFF59A849) : const Color(0xFFCA5A5A)),
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
