import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_animate.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_enum.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_function.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_tappable.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_text_font.dart';
import 'package:flutter_demo_collect/Cash_App/data/index.dart';
import 'package:flutter_demo_collect/Cash_App/model/index.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_transcation_item.dart';
import 'package:flutter_demo_collect/Cash_App/widgets_common/widget_size.dart';

class CaTransactionFilter extends StatefulWidget {
  /// 过滤参数
  final SearchFilters searchFilters;

  /// 设置过滤参数方法
  final Function(SearchFilters searchFilters) setSearchFilters;

  /// 清空过滤参数
  final Function() clearSearchFilters;
  const CaTransactionFilter({
    super.key,
    required this.searchFilters,
    required this.setSearchFilters,
    required this.clearSearchFilters,
  });

  @override
  State<CaTransactionFilter> createState() => _CaTransactionFilterState();
}

class _CaTransactionFilterState extends State<CaTransactionFilter> {
  late SearchFilters selectedFilters = widget.searchFilters;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 选择种类
        _buildSelectCategory(),

        /// 选择金额范围
        _buildSelectAmount(),

        /// 选择标签(支出或者收入)
        _buildSelectClipForExpenseIncome(),

        /// 选择标签(其他类型)
        _buildSelectClipForOther(),

        /// 包含关键字
        // _buildSelectTitleContain(),
      ],
    );
  }

  /// 选择种类
  _buildSelectCategory() {
    return _SelectCategory(
      categoryList: categoryList,
      handleSelectMultiCategory: (p0) => {print('选中种类:$p0')},
    );
  }

  _buildSelectAmount() {
    final RangeValues rangeLimit = RangeValues(0, 10000);
    return _SelectAmountRangeSlider(
      rangeLimit: rangeLimit,
      initialRange: RangeValues(0, 10000),
      onChange: (RangeValues rangeValue) {
        if (rangeLimit == rangeValue)
          selectedFilters.amountRange = null;
        else
          selectedFilters.amountRange = rangeValue;
      },
    );
  }

  _buildSelectClipForExpenseIncome() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: _SelectClip(
        items: ExpenseIncome.values,
        getLabel: (ExpenseIncome item) {
          return item == ExpenseIncome.expense
              ? "支出"
              : item == ExpenseIncome.income
                  ? "收入"
                  : "";
        },
        getCustomBorderColor: (ExpenseIncome item) {
          Color? customBorderColor;
          if (item == ExpenseIncome.expense) {
            customBorderColor = Colors.red;
          } else if (item == ExpenseIncome.income) {
            customBorderColor = Colors.green;
          }
          if (customBorderColor == null) return null;
          return dynamicPastel(
            context,
            lightenPastel(customBorderColor, amount: 0.3),
            amount: 0.4,
          );
        },
        onSelected: (ExpenseIncome item) {
          if (selectedFilters.expenseIncome.contains(item)) {
            selectedFilters.expenseIncome.remove(item);
          } else {
            selectedFilters.expenseIncome.add(item);
          }
          // setSearchFilters();
          widget.setSearchFilters(selectedFilters);
          setState(() {});
        },
        getSelected: (ExpenseIncome item) {
          return selectedFilters.expenseIncome.contains(item);
        },
      ),
    );
  }

  _buildSelectClipForOther() {
    dynamic transactionTypeDisplayToEnum = {
      "默认": null,
      "即将到来": TransactionSpecialType.upcoming,
      "订阅": TransactionSpecialType.subscription,
      "重复": TransactionSpecialType.repetitive,
      "债务": TransactionSpecialType.debt,
      "贷款": TransactionSpecialType.credit,
      null: "默认", // Default
      TransactionSpecialType.upcoming: "即将到来", // Upcoming
      TransactionSpecialType.subscription: "订阅", // Subscription
      TransactionSpecialType.repetitive: "重复", // Repetitive
      TransactionSpecialType.debt: "债务", // Borrowed
      TransactionSpecialType.credit: "贷款", // Lent
    };

    return Container(
      margin: EdgeInsets.only(top: 5),
      child: _SelectClip(
        items: [null, ...TransactionSpecialType.values],
        getLabel: (TransactionSpecialType? item) {
          // print('我是item:$item');
          return transactionTypeDisplayToEnum[item]?.toString().toLowerCase() ??
              "";
        },
        getCustomBorderColor: (TransactionSpecialType? item) {
          Color? customBorderColor;
          if (item == TransactionSpecialType.credit) {
            customBorderColor = const Color(0xFF58A4C2);
          } else if (item == TransactionSpecialType.debt) {
            customBorderColor = const Color(0xFF6577E0);
          }
          if (customBorderColor == null) return null;
          return dynamicPastel(
            context,
            lightenPastel(customBorderColor, amount: 0.3),
            amount: 0.4,
          );
        },
        onSelected: (TransactionSpecialType? item) {
          if (selectedFilters.transactionTypes.contains(item)) {
            selectedFilters.transactionTypes.remove(item);
          } else {
            if (item != null) selectedFilters.transactionTypes.add(item);
          }

          print('我是过滤参数:$SearchFilters');
          // setSearchFilters();
          widget.setSearchFilters(selectedFilters);
          setState(() {});
        },
        getSelected: (TransactionSpecialType? item) {
          return selectedFilters.transactionTypes.contains(item);
        },
      ),
    );
  }
}

/// 选择交易种类
class _SelectCategory extends StatefulWidget {
  /// 横向列表高度
  double? horizontalListViewHeight;

  /// 选中种类的方法(多选)
  final Function(List<String>?)? handleSelectMultiCategory;

  /// 选中的种类(多选)
  final List<String>? selectMultiCategory;

  /// 种类数据
  List<TransactionCategoryModel> categoryList = [];
  _SelectCategory({
    super.key,
    this.horizontalListViewHeight = 110,
    this.handleSelectMultiCategory,
    this.selectMultiCategory,
    required this.categoryList,
  });

  @override
  State<_SelectCategory> createState() => __SelectCategoryState();
}

class __SelectCategoryState extends State<_SelectCategory> {
  /// 选中的种类
  List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(milliseconds: 0), () {
    //   setInitialCategory();
    // });
    setInitialCategories();
    // _scrollController = ScrollController();
  }

  setInitialCategories() {
    // 多选初始化
    if (widget.selectMultiCategory != null) {
      setState(() {
        selectedCategories = widget.selectMultiCategory ?? [];
      });
    }
    // 单选初始化
    // else if (widget.selectedCategory != null) {
    //   setState(() {
    //     selectedCategories.add("-1");
    //   });
    // }
  }

  Widget _buildAllButton() {
    return SelectedCategoryHorizontalExtraButton(
      label: "全部",
      onTap: () {
        if (widget.handleSelectMultiCategory != null) {
          widget.handleSelectMultiCategory!(null);
        }
        setState(() {
          selectedCategories = [];
        });
      },
      isOutlined: selectedCategories.isEmpty,
      icon: Icons.category_outlined,
    );
  }

  /// 构建种类列表
  List<Widget> _buildCategoryList() {
    return List.generate(
      widget.categoryList.length,
      (index) {
        final categoryItem = widget.categoryList[index];
        // 如果选中的情况下给一个缩放效果
        return AnimatedScale(
          scale: selectedCategories.contains(categoryItem) ? 1 : 0.86,
          duration: const Duration(milliseconds: 500),
          child: AnimatedOpacity(
            opacity: 1,
            // opacity:
            //     selectedCategories.contains(categoryItem.categoryPk) ? 0.3 : 1,
            duration: const Duration(milliseconds: 500),
            child: Column(
              children: [
                TransactionCategoryIcon(
                  // label: category.categoryName,
                  size: 50,
                  sizePadding: 20,
                  category: categoryItem,
                  borderRadius: 10,
                  margin: const EdgeInsetsDirectional.only(end: 5, top: 20),
                  onTap: () {
                    if (widget.handleSelectMultiCategory != null) {
                      if (selectedCategories
                          .contains(categoryItem.categoryPk)) {
                        setState(() {
                          selectedCategories.remove(categoryItem.categoryPk);
                        });
                      } else {
                        setState(() {
                          selectedCategories.add(categoryItem.categoryPk);
                        });
                      }
                      widget.handleSelectMultiCategory!(selectedCategories);
                    }
                  },
                  outline: selectedCategories.contains(categoryItem.categoryPk),
                ),
                Container(
                  margin: const EdgeInsetsDirectional.only(top: 4),
                  width: 60,
                  child: Center(
                    child: TextFont(
                      textAlign: TextAlign.center,
                      text: categoryItem.name,
                      fontSize: 10,
                      maxLines: 1,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSizeSwitcher(
      child: SizedBox(
        height:
            widget.categoryList.isEmpty ? 0 : widget.horizontalListViewHeight,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildAllButton(),
            ..._buildCategoryList(),
          ],
        ),
      ),
    );
  }
}

RangeValues orderAndBoundRangeValues(
    double start, double end, double min, double max) {
  double orderedStart = start < end ? start : end;
  double orderedEnd = start < end ? end : start;

  orderedStart = orderedStart.clamp(min, max);
  orderedEnd = orderedEnd.clamp(min, max);

  return RangeValues(orderedStart, orderedEnd);
}

/// 选择金额范围
class _SelectAmountRangeSlider extends StatefulWidget {
  const _SelectAmountRangeSlider({
    super.key,
    required this.rangeLimit,
    required this.onChange,
    required this.initialRange,
  });

  /// 范围限制
  final RangeValues rangeLimit;

  /// 初始范围
  final RangeValues? initialRange;

  /// 改变范围
  final Function(RangeValues) onChange;

  @override
  State<_SelectAmountRangeSlider> createState() =>
      __SelectAmountRangeSliderState();
}

class __SelectAmountRangeSliderState extends State<_SelectAmountRangeSlider> {
  late RangeValues _currentRangeValues;
  @override
  void initState() {
    _currentRangeValues = widget.initialRange ??
        RangeValues(widget.rangeLimit.start, widget.rangeLimit.end);
    super.initState();
  }

  updateRange(RangeValues range) {
    widget.onChange(range);
    setState(() {
      _currentRangeValues = range;
    });
  }

  void resetRange() {
    updateRange(orderAndBoundRangeValues(
      widget.rangeLimit.start,
      widget.rangeLimit.end,
      widget.rangeLimit.start,
      widget.rangeLimit.end,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 5),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: RangeSlider(
              activeColor: Theme.of(context).colorScheme.primary,
              values: _currentRangeValues,
              max: widget.rangeLimit.end,
              min: widget.rangeLimit.start,
              onChanged: updateRange,
            ),
          ),
          // 最低最高价格标签
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 20, end: 20, top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Tappable(
                    onLongPress: resetRange,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: 7,
                    // onTap: setLowerRangePopup,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 8, vertical: 6),
                      child: TextFont(
                        // text: convertToMoney(Provider.of<AllWallets>(context),
                        //     _currentRangeValues.start),
                        text: 'RM${convertToMoney(_currentRangeValues.start)}',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Tappable(
                    onLongPress: resetRange,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: 7,
                    // onTap: setUpperRangePopup,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 8, vertical: 6),
                      child: TextFont(
                        // text: convertToMoney(Provider.of<AllWallets>(context),
                        //     _currentRangeValues.end),
                        text: 'RM${convertToMoney(_currentRangeValues.end)}',
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// 选择标签 使用泛型T
class _SelectClip<T> extends StatefulWidget {
  /// 标签列表
  final List<T> items;

  /// 初始化选中
  final bool Function(T) getSelected;

  /// 选择函数
  final Function(T) onSelected;

  /// 获取标签名称
  final String Function(T) getLabel;

  /// 自定义边框颜色
  final Color? Function(T)? getCustomBorderColor;

  const _SelectClip({
    super.key,
    required this.items,
    required this.getSelected,
    required this.onSelected,
    required this.getLabel,
    this.getCustomBorderColor,
  });

  @override
  State<_SelectClip<T>> createState() => __SelectClipState<T>();
}

class __SelectClipState<T> extends State<_SelectClip<T>> {
  List<Widget> children = [];

  // 每个标签的高度
  double heightOfScroll = 0;

  List<Widget> _generateClips() {
    return List.generate(
      widget.items.length,
      (index) {
        T item = widget.items[index];
        String label = widget.getLabel(item);
        bool selected = widget.getSelected(item);
        return Opacity(
          opacity: 1,
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
            child: Material(
              color: Colors.transparent,
              child: Theme(
                data:
                    Theme.of(context).copyWith(canvasColor: Colors.transparent),
                child: ChoiceChip(
                  side: widget.getCustomBorderColor == null ||
                          widget.getCustomBorderColor!(item) == null ||
                          widget.getCustomBorderColor!(item) == null
                      ? null
                      : BorderSide(
                          color: widget.getCustomBorderColor!(item)!,
                        ),
                  avatar: null,
                  labelPadding: EdgeInsetsDirectional.only(
                      start: 5, end: 10, top: 1, bottom: 1),
                  padding: EdgeInsetsDirectional.only(
                    start: 10,
                    top: 7,
                    bottom: 7,
                  ),
                  label: TextFont(
                    text: label,
                    fontSize: 15,
                  ),
                  selectedColor: Colors.black.withOpacity(0.05),
                  selected: selected,
                  onSelected: (value) {
                    print('我是选中:$value ==== $item');
                    widget.onSelected(item);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    children = _generateClips();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Stack(
        children: [
          /// 获取标签高度 这个区域不渲染
          if (children.isNotEmpty)
            IgnorePointer(
              child: Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Opacity(
                  opacity: 0,
                  child: WidgetSize(
                    onChange: (Size size) {
                      heightOfScroll = size.height;
                      setState(() {});
                    },
                    child: children.first,
                  ),
                ),
              ),
            ),

          /// 这里才是渲染区域
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: heightOfScroll),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 12),
                      child: Wrap(
                        // runSpacing: ,
                        children: [
                          for (Widget child in children)
                            SizedBox(height: heightOfScroll, child: child)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SelectedCategoryHorizontalExtraButton extends StatelessWidget {
  const SelectedCategoryHorizontalExtraButton(
      {required this.label,
      required this.onTap,
      required this.isOutlined,
      required this.icon,
      super.key});
  final String label;
  final VoidCallback onTap;
  final bool isOutlined;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: ValueKey(1),
      padding: EdgeInsetsDirectional.only(
        top: 18,
        start: 8,
        end: 8,
        // bottom: 8,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Tappable(
            color: Theme.of(context).colorScheme.secondaryContainer,
            onTap: onTap,
            borderRadius: 10,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              decoration: isOutlined
                  ? BoxDecoration(
                      border: Border.all(
                        color: dynamicPastel(
                            context, Theme.of(context).colorScheme.primary,
                            amountLight: 0.5, amountDark: 0.4, inverse: true),
                        width: 3,
                      ),
                      borderRadius:
                          BorderRadiusDirectional.all(Radius.circular(10)),
                    )
                  : BoxDecoration(
                      border: Border.all(
                        color: Colors.transparent,
                        width: 0,
                      ),
                      borderRadius: const BorderRadiusDirectional.all(
                          Radius.circular(10)),
                    ),
              width: 60,
              height: 60,
              child: Center(
                child: Icon(
                  icon,
                  size: 35,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(top: 4),
            width: 60,
            child: Center(
              child: TextFont(
                textAlign: TextAlign.center,
                text: label,
                fontSize: 10,
                maxLines: 1,
              ),
            ),
          )
        ],
      ),
    );
  }
}
