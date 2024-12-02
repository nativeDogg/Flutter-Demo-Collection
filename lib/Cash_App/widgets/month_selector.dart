// 月份选择器
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_animate.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_function.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_tappable.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_multi_direction_infinite_scroll.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_text_font.dart';

class MonthSelector extends StatefulWidget {
  const MonthSelector({Key? key, required this.setSelectedDateStart})
      : super(key: key);
  // 选择月份后自动跳转页面
  final Function(DateTime, int) setSelectedDateStart;

  @override
  State<MonthSelector> createState() => MonthSelectorState();
}

class MonthSelectorState extends State<MonthSelector> {
  GlobalKey<MultiDirectionInfiniteScrollState>
      multiDirectionInfiniteScrollStateKey =
      GlobalKey<MultiDirectionInfiniteScrollState>();
  // 开始默认选中 当前月份
  DateTime selectedDateStart = DateTime.now();
  // 一个月份text的宽度
  double monthWidth = 100;
  // 是否显示返回左边箭头
  bool showLeftArrow = false;
  // 是否显示返回右边箭头
  bool showRightArrow = false;

  scrollTo(double position) {
    multiDirectionInfiniteScrollStateKey.currentState!.scrollTo(
      const Duration(milliseconds: 500),
      position: position,
    );
  }

  // 先执行外面的setSelectedDateStart方法，再执行内部的setSelectedDateStart方法
  setSelectedDateStart(DateTime dateTime, int offset) {
    setState(() {
      // selectedDateStart判断是否被选中 同时通过setState更新ui 产生动画效果
      selectedDateStart = dateTime;
      // pageOffset = offset;
    });
  }

  // 根据index 获取 月份
  getDateFromIndex(int index) {
    return DateTime(DateTime.now().year, DateTime.now().month + index);
  }

  judgeIsToday(DateTime currentDateTime) {
    return currentDateTime.month == DateTime.now().month &&
        currentDateTime.year == DateTime.now().year;
  }

  judgeIsSelected(DateTime currentDateTime) {
    return selectedDateStart.month == currentDateTime.month &&
        selectedDateStart.year == currentDateTime.year;
  }

  // scrollController.offset(position) > 0 代表向右滑动
  // scrollController.offset(position) < 0 代表向左滑动
  _onScroll(position) {
    // 向右滑动边界 代表超出了这个边界就会显示返回左边的箭头
    const rightScrollBound = 200;
    // 向左滑动边界 代表超出了这个边界就会显示返回右边的箭头
    final leftScrollBound = -200 - MediaQuery.sizeOf(context).width / 2 - 100;

    // 如果滑动距离大于右边界
    if (position > rightScrollBound) {
      !showLeftArrow ? setState(() => showLeftArrow = true) : null;
    }
    // 如果滑动距离小于左边界
    else if (position < leftScrollBound) {
      !showRightArrow ? setState(() => showRightArrow = true) : null;
    }

    // 如果滑动距离在左右边界之间
    if (position > leftScrollBound && position < rightScrollBound) {
      if (showLeftArrow) {
        setState(() => showLeftArrow = false);
      }
      if (showRightArrow) {
        setState(() => showRightArrow = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 无限滚动组建
        MultiDirectionInfiniteScroll(
          key: multiDirectionInfiniteScrollStateKey,
          onScroll: (position) => _onScroll(position),
          startingScrollPosition:
              -(MediaQuery.sizeOf(context).width) / 2 + monthWidth / 2,
          initialItems: 10,
          itemBuilder: (index, isFirst, isLast) {
            // 根据index 获取 月份
            DateTime currentDateTime = getDateFromIndex(index);
            // 是否被选中
            bool isSelected = judgeIsSelected(currentDateTime);
            // 是否是今天
            bool isToday = judgeIsToday(currentDateTime);

            return Container(
              color: Theme.of(context).canvasColor,
              padding: const EdgeInsetsDirectional.only(start: 0, end: 0),
              child: Container(
                width: monthWidth,
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
                child: Stack(
                  children: [
                    // 年份/月份文本以及tabbar指示器
                    Tappable(
                      onTap: () =>
                          widget.setSelectedDateStart(currentDateTime, index),
                      child: Column(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: isSelected
                                ? TextFont(
                                    key: const ValueKey(1),
                                    fontSize: 14,
                                    text: getMonth(currentDateTime, context),
                                    textColor: Colors.black,
                                    fontWeight: isToday
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                  )
                                : TextFont(
                                    key: const ValueKey(2),
                                    fontSize: 14,
                                    text: getMonth(currentDateTime, context),
                                    textColor: Colors.black.withOpacity(0.3),
                                    fontWeight: isToday
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                          // 年份文本
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: isSelected
                                ? TextFont(
                                    key: const ValueKey(1),
                                    fontSize: 9,
                                    text: currentDateTime.year.toString(),
                                    textColor: Colors.black,
                                  )
                                : TextFont(
                                    key: const ValueKey(2),
                                    fontSize: 9,
                                    text: currentDateTime.year.toString(),
                                    textColor: Colors.black.withOpacity(0.3),
                                  ),
                          ),
                          // tabbar指示器
                          Align(
                            alignment: AlignmentDirectional.bottomCenter,
                            child: AnimatedScaleOpacity(
                              duration: const Duration(milliseconds: 500),
                              durationOpacity:
                                  const Duration(milliseconds: 300),
                              animateIn: isSelected,
                              curve: isSelected
                                  ? Curves.decelerate
                                  : Curves.easeOutQuart,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.only(
                                    topEnd: Radius.circular(40),
                                    topStart: Radius.circular(40),
                                  ),
                                  color: Colors.black,
                                ),
                                width: 100,
                                height: 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // 返回左边箭头
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: AnimatedScaleOpacity(
            animateIn: showLeftArrow,
            duration: const Duration(milliseconds: 400),
            durationOpacity: const Duration(milliseconds: 200),
            // alignment: AlignmentDirectional.centerStart,
            curve: Curves.fastOutSlowIn,
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.only(top: 8, bottom: 8, start: 2),
              child: Tappable(
                borderRadius: 10,
                color: Theme.of(context).colorScheme.primary,
                onTap: () {
                  multiDirectionInfiniteScrollStateKey.currentState!
                      .scrollTo(const Duration(milliseconds: 700));
                  widget.setSelectedDateStart(
                      DateTime(DateTime.now().year, DateTime.now().month), 0);
                },
                child: SizedBox(
                  width: 44,
                  height: 34,
                  child: Transform.scale(
                    scale: 1.5,
                    child: Icon(
                      Icons.arrow_left_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // 右边箭头

        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: AnimatedScaleOpacity(
            animateIn: showRightArrow,
            duration: const Duration(milliseconds: 400),
            durationOpacity: const Duration(milliseconds: 200),
            alignment: AlignmentDirectional.centerEnd,
            curve: Curves.fastOutSlowIn,
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.only(top: 8, bottom: 8, end: 2),
              child: Tappable(
                borderRadius: 10,
                color: Theme.of(context).colorScheme.primary,
                onTap: () {
                  multiDirectionInfiniteScrollStateKey.currentState!
                      .scrollTo(const Duration(milliseconds: 700));
                  widget.setSelectedDateStart(
                      DateTime(DateTime.now().year, DateTime.now().month), 0);
                },
                child: Container(
                  width: 44,
                  height: 34,
                  child: Transform.scale(
                    scale: 1.5,
                    child: Icon(Icons.arrow_right_rounded,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
