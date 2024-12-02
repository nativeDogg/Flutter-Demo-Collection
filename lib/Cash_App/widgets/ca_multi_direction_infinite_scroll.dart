import 'package:flutter/material.dart';

class MultiDirectionInfiniteScroll extends StatefulWidget {
  final Function(int index, bool isFirst, bool isLast) itemBuilder;
  final double height;
  final ScrollPhysics? physics;
  // 默认开始滚动的位置
  final double startingScrollPosition;
  final Duration duration;
  // 初始化数量 默认10 实际上加载20个
  final int? initialItems;
  // 在滑动期间的监听
  final Function? onScroll;
  // 移动到最左侧是否加载
  final Function? onLeftLoaded;
  // 移动到最右侧是否加载
  final Function? onRightLoaded;
  // 可以滑动超出范围
  final double overBoundsDetection;

  const MultiDirectionInfiniteScroll({
    super.key,
    required this.itemBuilder,
    this.height = 40,
    this.startingScrollPosition = 0,
    this.duration = const Duration(milliseconds: 100),
    this.physics,
    this.onScroll,
    this.onLeftLoaded,
    this.onRightLoaded,
    this.overBoundsDetection = 50,
    this.initialItems = 10,
  });

  @override
  State<MultiDirectionInfiniteScroll> createState() =>
      MultiDirectionInfiniteScrollState();
}

class MultiDirectionInfiniteScrollState
    extends State<MultiDirectionInfiniteScroll> {
  late ScrollController _scrollController;
  List<int> firstHalf = [1];
  List<int> secondHalf = [-1, 0];

  scrollTo(duration, {double? position}) {
    double positionToScroll = position ?? widget.startingScrollPosition;
    double clampedPosition = positionToScroll.clamp(
        _scrollController.position.minScrollExtent,
        _scrollController.position.maxScrollExtent);

    _scrollController.animateTo(
      clampedPosition,
      duration: duration,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    if (widget.initialItems != null) {
      firstHalf = [];
      secondHalf = [0];
      for (int i = 1; i < widget.initialItems!; i++) {
        firstHalf.insert(0, -(widget.initialItems! - i));
        secondHalf.add(i);
      }
    }
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    // 默认将当前月份的位置移动到中间
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        widget.startingScrollPosition,
        duration: widget.duration,
        curve: const ElasticOutCurve(0.7),
      );
    });
    super.initState();
  }

  // 监听方法
  // 监听到最左侧和最右侧
  // 以及监听在滑动时候是否弹出左右箭头

  // scrollController.offset > 0 代表向右滑动
  // scrollController.offset < 0 代表向左滑动
  _scrollListener() {
    // print('我是滚动offset:${_scrollController.offset}');
    // 滚动到达最大滚动范围
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent -
            widget.overBoundsDetection) {
      _onEndReached();
      if (widget.onLeftLoaded != null) {
        widget.onLeftLoaded!();
      }
    }
    // 滚动到达最小滚动范围
    if (_scrollController.offset <=
        _scrollController.position.minScrollExtent +
            widget.overBoundsDetection) {
      _onStartReached();
      if (widget.onRightLoaded != null) {
        widget.onRightLoaded!();
      }
    }

    // 如果滑动监听函数不为空
    if (widget.onScroll != null) {
      widget.onScroll!(_scrollController.offset);
    }
  }

  _onStartReached() {}

  _onEndReached() {}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: CustomScrollView(
        physics: widget.physics,
        // 横向
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        // 用于将某一个子项定位在中间
        center: const ValueKey('second-sliver-list'),
        slivers: [
          // 前排月份
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return widget.itemBuilder(
                    firstHalf[index], index == firstHalf.length - 1, false);
              },
              childCount: firstHalf.length,
            ),
          ),
          // 后排月份
          SliverList(
            key: const ValueKey('second-sliver-list'),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return widget.itemBuilder(
                    secondHalf[index], false, index == secondHalf.length - 1);
              },
              childCount: secondHalf.length,
            ),
          )
        ],
      ),
    );
  }
}
