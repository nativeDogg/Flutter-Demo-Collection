import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_animate.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_function.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_tappable.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_text_font.dart';
import 'package:flutter_demo_collect/Cash_App/data/index.dart';
import 'package:flutter_demo_collect/Cash_App/model/index.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_transcation_item.dart';

class CaTransactionFilter extends StatefulWidget {
  const CaTransactionFilter({super.key});

  @override
  State<CaTransactionFilter> createState() => _CaTransactionFilterState();
}

class _CaTransactionFilterState extends State<CaTransactionFilter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 选择种类
        _buildSelectCategory(),

        /// 选择金额范围
        _buildSelectAmount(),
      ],
    );
  }

  /// 选择种类
  _buildSelectCategory() {
    return _SelectCategory(
      categoryList: categoryList,
      handleSelectMultiCategory: (p0) => {},
    );
  }

  _buildSelectAmount() {
    return _SelectAmountRangeSlider(
      rangeLimit: RangeValues(0, 10000),
      initialRange: RangeValues(0, 10000),
      onChange: (RangeValues rangeValues) {},
    );
  }

  _bulidSelectClip() {
    return _SelectClip();
  }
}

/// 选择交易种类
class _SelectCategory extends StatefulWidget {
  /// 横向列表高度
  double? horizontalListViewHeight;

  /// 选中种类的方法(多选)
  final Function(List<String>)? handleSelectMultiCategory;

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
          widget.handleSelectMultiCategory!([]);
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
  const _SelectClip({super.key});

  @override
  State<_SelectClip<T>> createState() => __SelectClipState<T>();
}

class __SelectClipState<T> extends State<_SelectClip<T>> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
