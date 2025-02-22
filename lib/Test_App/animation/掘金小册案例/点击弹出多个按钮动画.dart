import 'dart:math';

import 'package:flutter/material.dart';

class BurstMenusDemo extends StatelessWidget {
  BurstMenusDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: BurstMenu.topRight(
    //     curve: Curves.bounceOut,
    //     radius: 60,
    //     center: _buildMenu(),
    //     burstMenuItemClick: _burstMenuItemClick,
    //     menus: _buildMenuItems(),
    //   ),
    // );
    return Center(
      child: BurstMenu.topLeft(
        curve: Curves.bounceOut,
        radius: 60,
        center: _buildMenu(),
        burstMenuItemClick: _burstMenuItemClick,
        menus: _buildMenuItems(),
      ),
    );
  }
}

Widget _buildMenu() => Container(
      width: 36,
      height: 36,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          image:
              DecorationImage(image: AssetImage('assets/images/icon_head.jpg')),
        ),
      ),
    );

final List<Color> colors = [
  Colors.red,
  Colors.yellow,
  Colors.blue,
  Colors.green,
];

// 构建 菜单 item
List<Widget> _buildMenuItems() => colors
    .asMap()
    .keys
    .map((int index) => Container(
          alignment: Alignment.center,
          width: 15.0 * 2,
          height: 15.0 * 2,
          child: Text(
            '$index',
            style: TextStyle(color: Colors.white),
          ),
          decoration: BoxDecoration(
              color: colors[index],
              borderRadius: const BorderRadius.all(Radius.circular(15.0))),
        ))
    .toList();

bool _burstMenuItemClick(int index) {
  print("index:$index");
  if (index == 0) {
    return false;
  }
  return true;
}

enum BurstType {
  circle,
  topLeft,
  bottomLeft,
  topRight,
  bottomRight,
  halfCircle,
}

typedef BurstMenuItemClick = bool Function(int index);

class BurstMenu extends StatefulWidget {
  final List<Widget> menus;
  final Widget center;
  final double radius;
  final double startAngle;
  final double swapAngle;
  final double hideOpacity;
  final Duration duration;
  final BurstType burstType;
  final Curve curve;
  final BurstMenuItemClick? burstMenuItemClick;

  const BurstMenu({
    Key? key,
    required this.menus,
    required this.center,
    this.radius = 100,
    this.swapAngle = 120,
    this.startAngle = -60,
    this.hideOpacity = 0,
    this.curve = Curves.ease,
    this.duration = const Duration(milliseconds: 300),
    this.burstType = BurstType.circle,
    this.burstMenuItemClick,
  }) : super(key: key);

  BurstMenu.topLeft({
    required this.menus,
    this.radius = 100,
    required this.center,
    this.burstMenuItemClick,
    this.hideOpacity = 0,
    this.curve = Curves.ease,
    this.duration = const Duration(milliseconds: 300),
    this.burstType = BurstType.topLeft,
    this.swapAngle = 90,
    this.startAngle = 0,
  });

  BurstMenu.bottomLeft({
    required this.menus,
    this.radius = 100,
    required this.center,
    this.burstMenuItemClick,
    this.hideOpacity = 0,
    this.curve = Curves.ease,
    this.duration = const Duration(milliseconds: 300),
    this.burstType = BurstType.bottomLeft,
    this.swapAngle = 90,
    this.startAngle = -90,
  });

  BurstMenu.topRight({
    required this.menus,
    this.radius = 100,
    required this.center,
    this.burstMenuItemClick,
    this.hideOpacity = 0,
    this.curve = Curves.ease,
    this.duration = const Duration(milliseconds: 500),
    this.burstType = BurstType.topRight,
    this.swapAngle = -90,
    this.startAngle = 180,
  });

  BurstMenu.bottomRight({
    required this.menus,
    this.radius = 100,
    required this.center,
    this.burstMenuItemClick,
    this.hideOpacity = 0,
    this.curve = Curves.ease,
    this.duration = const Duration(milliseconds: 300),
    this.burstType = BurstType.bottomRight,
    this.swapAngle = 90,
    this.startAngle = 180,
  });

  @override
  BurstMenuState createState() => BurstMenuState();
}

class BurstMenuState extends State<BurstMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // 是否已关闭
  bool _closed = true;
  late Animation<double> curveAnim; // 1.定义曲线动画

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    curveAnim =
        CurvedAnimation(parent: _controller, curve: widget.curve); //<--2.创建曲线动画
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.radius * 2,
        height: widget.burstType == BurstType.halfCircle
            ? widget.radius
            : widget.radius * 2,
        alignment: Alignment.center,
        child: Flow(
          delegate: _CircleFlowDelegate(
            curveAnim,
            startAngle: widget.startAngle,
            hideOpacity: widget.hideOpacity,
            swapAngle: widget.swapAngle,
            burstType: widget.burstType,
          ),
          children: [
            ...widget.menus.asMap().keys.map((int index) => GestureDetector(
                  onTap: () => _handleItemClick(index),
                  child: widget.menus[index],
                )),
            GestureDetector(onTap: toggle, child: widget.center)
          ],
        ));
  }

  void _handleItemClick(int index) {
    if (widget.burstMenuItemClick == null) {
      toggle();
      return;
    }
    bool close = widget.burstMenuItemClick!.call(index);
    if (close) toggle();
  }

  @override
  void didUpdateWidget(BurstMenu oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _controller.dispose();
      _controller = AnimationController(duration: widget.duration, vsync: this);
    }
    if (widget.curve != oldWidget.curve ||
        widget.duration != oldWidget.duration) {
      curveAnim = CurvedAnimation(parent: _controller, curve: widget.curve);
    }
  }

  void toggle() {
    if (_closed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _closed = !_closed;
  }
}

class _CircleFlowDelegate extends FlowDelegate {
  // 菜单圆弧的扫描角度
  final double swapAngle;

  // 菜单圆弧的起始角度
  final double startAngle;
  final double hideOpacity;
  final BurstType burstType;

  final Animation<double> animation;

  /// CircleFlowDelegate接收一个可以监听的Listenable对象，用于在动画改变时重新绘制
  _CircleFlowDelegate(
    this.animation, {
    this.swapAngle = 120,
    this.hideOpacity = 0.3,
    this.startAngle = -60,
    this.burstType = BurstType.circle,
  }) : super(repaint: animation);

  //绘制孩子的方法
  @override
  void paintChildren(FlowPaintingContext context) {
    double radius = context.size.shortestSide / 2;
    final double halfCenterSize =
        context.getChildSize(context.childCount - 1)!.width / 2;

    switch (burstType) {
      case BurstType.circle:
        paintWithOffset(context, Offset.zero);
        break;
      case BurstType.topLeft:
        Offset centerOffset =
            Offset(-radius + halfCenterSize, -radius + halfCenterSize);
        paintWithOffset(context, centerOffset);
        break;
      case BurstType.bottomLeft:
        Offset centerOffset =
            Offset(-radius + halfCenterSize, radius - halfCenterSize);
        paintWithOffset(context, centerOffset);
        break;
      case BurstType.topRight:
        Offset centerOffset =
            Offset(radius - halfCenterSize, -radius + halfCenterSize);
        paintWithOffset(context, centerOffset);
        break;
      case BurstType.bottomRight:
        Offset centerOffset =
            Offset(radius - halfCenterSize, radius - halfCenterSize);
        paintWithOffset(context, centerOffset);
        break;
      case BurstType.halfCircle:
        Offset centerOffset = Offset(radius, radius - halfCenterSize);
        paintWithOffset(context, centerOffset);
        break;
    }
  }

  void paintWithOffset(FlowPaintingContext context, Offset centerOffset) {
    final double radius = context.size.shortestSide / 2;

    final int count = context.childCount - 1;
    final double perRad = swapAngle / 180 * pi / (count - 1);
    final double rotate = startAngle / 180 * pi;

    // 这里对除了中间按钮之外的其他按钮进行布局和绘制
    if (animation.value > hideOpacity) {
      for (int i = 0; i < count; i++) {
        final double cSizeX = context.getChildSize(i)!.width / 2;
        final double cSizeY = context.getChildSize(i)!.height / 2;

        final double beforeRadius = (radius - cSizeX);
        final double now = beforeRadius + centerOffset.dy.abs();
        final swapRadius = (radius - cSizeX) / beforeRadius * now;

        final double offsetX =
            animation.value * swapRadius * cos(i * perRad + rotate) +
                radius +
                centerOffset.dx;
        final double offsetY =
            animation.value * swapRadius * sin(i * perRad + rotate) +
                radius +
                centerOffset.dy;

        context.paintChild(
          i,
          transform: Matrix4.translationValues(
            offsetX - cSizeX,
            offsetY - cSizeY,
            0.0,
          ),
          opacity: animation.value,
        );
      }
    }

    context.paintChild(
      context.childCount - 1,
      transform: Matrix4.translationValues(
        radius -
            context.getChildSize(context.childCount - 1)!.width / 2 +
            centerOffset.dx,
        radius -
            context.getChildSize(context.childCount - 1)!.height / 2 +
            centerOffset.dy,
        0.0,
      ),
    );
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) => false;
}
