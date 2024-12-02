import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_page_frame_work_sliver_appbar.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_scroll_wrap.dart';

class CaPageFramework extends StatefulWidget {
  const CaPageFramework({
    super.key,
    this.resizeToAvoidBottomInset = true,
    this.slivers = const [],
    this.horizontalPadding = 0,
    this.sliversBefore = true,
    this.backgroundColor,
    this.bodyBuilder,
    this.customScrollViewBuilder,
    this.scrollPhysics,
    this.scrollController,
    this.listWidgets,
    this.appBarBackgroundColor,
  });

  /// 是否避免底部被键盘遮挡
  final bool resizeToAvoidBottomInset;

  /// 背景颜色
  final Color? backgroundColor;

  /// 应该是自定义整个body内容
  final Widget Function(ScrollController scrollController,
      ScrollPhysics? scrollPhysics, Widget sliverAppBar)? bodyBuilder;

  /// 自定义ScrollView的内容
  final Widget Function(
      ScrollController scrollController,
      ScrollPhysics? scrollPhysics,
      Widget sliverAppBar)? customScrollViewBuilder;

  /// scrollPhysics
  final ScrollPhysics? scrollPhysics;

  /// 滚动控制器
  final ScrollController? scrollController;

  /// sliver组件列表
  final List<Widget> slivers;

  /// list组件列表
  final List<Widget>? listWidgets;

  /// 水平方向内边距
  final double horizontalPadding;

  /// 是否sliver在前面
  final bool sliversBefore;

  /// AppBar背景颜色
  final Color? appBarBackgroundColor;

  @override
  State<CaPageFramework> createState() => _CaPageFrameworkState();
}

class _CaPageFrameworkState extends State<CaPageFramework> {
  late ScrollController _scrollController;
  late Widget _sliverAppBar;
  late List<Widget> _slivers;
  late List<Widget> _listWidgets;
  late List<Widget> _allSliverContent;

  @override
  void initState() {
    _scrollController = widget.scrollController ?? ScrollController();

    super.initState();
  }

  Widget _buildScaffold() {
    _sliverAppBar = _buildPageFrameworkAppBar();
    _slivers = [
      for (Widget sliver in widget.slivers)
        widget.horizontalPadding == 0
            ? sliver
            : SliverPadding(
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: widget.horizontalPadding),
                sliver: sliver,
              )
    ];
    _listWidgets = [
      widget.listWidgets != null
          ? SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.horizontalPadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ...widget.listWidgets!,
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 15,
                    )
                  ],
                ),
              ),
            )
          : SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).padding.bottom + 15,
              ),
            )
    ];
    _allSliverContent = widget.sliversBefore
        ? [..._slivers, ..._listWidgets]
        : [..._listWidgets, ..._slivers];

    return Scaffold(
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      backgroundColor: widget.backgroundColor,
      body: widget.bodyBuilder != null
          ? widget.bodyBuilder!(
              _scrollController,
              widget.scrollPhysics,
              _sliverAppBar,
            )
          : Stack(
              children: [
                /// 如果有自定义的ScrollView，则使用自定义的ScrollView
                if (widget.customScrollViewBuilder != null)
                  CaScrollbarWrap(
                    child: widget.customScrollViewBuilder!(
                      _scrollController,
                      widget.scrollPhysics,
                      _sliverAppBar,
                    ),
                  )
                else
                  CustomScrollView(
                    physics: widget.scrollPhysics,
                    controller: _scrollController,
                    slivers: [
                      _sliverAppBar,
                      ..._allSliverContent,
                    ],
                  )
              ],
            ),
    );
  }

  Widget _buildPageFrameworkAppBar() {
    return CaPageFrameWorkSliverAppbar(
      appBarBackgroundColor: widget.appBarBackgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }
}
