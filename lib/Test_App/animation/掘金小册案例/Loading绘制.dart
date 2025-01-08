import 'dart:math';

import 'package:flutter/material.dart';

class RotateLoading extends StatefulWidget {
  final double size;

  const RotateLoading({Key? key, this.size = 100}) : super(key: key);

  @override
  _RotateLoadingState createState() => _RotateLoadingState();
}

class _RotateLoadingState extends State<RotateLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _controller.repeat();
        },
        child: CustomPaint(
          size: Size(widget.size, widget.size),
          painter: RotateLoadingPainter(_controller),
        ),
      ),
    );
  }
}

class RotateLoadingPainter extends CustomPainter {
  final Animation<double> animation;
  final Animatable<double> rotateTween = Tween<double>(begin: pi, end: -pi)
      .chain(CurveTween(curve: Curves.easeIn));
  RotateLoadingPainter(this.animation, {this.itemWidth = 33})
      : super(repaint: animation);
  // 颜色
  final List<Color> colors = const [
    Color(0xffF44336),
    Color(0xff5C6BC0),
    Color(0xffFFB74D),
    Color(0xff8BC34A)
  ];
  final double itemWidth; //色块宽
  final Paint _paint = Paint(); //画板
  final double span = 16; //色块间隔

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    // canvas.rotate(animation.value * pi + 2);
    final double len = itemWidth / 2 + span / 2;

    // 绘制红色(左上)
    Offset centerA = Offset(-len, -len);
    drawItem(canvas, centerA, colors[0]);

    // 绘制蓝色(右下角)
    Offset centerB = Offset(len, len);
    drawItem(canvas, centerB, colors[1]);

    // 绘制橙色 右上角
    Offset centerC = Offset(len, -len);
    drawItem(canvas, centerC, colors[2]);

    // 绘制绿色 左下角
    Offset centerD = Offset(-len, len);
    drawItem(canvas, centerD, colors[3]);
  }

  // void drawItem(
  //   Canvas canvas,
  //   Offset center,
  //   Color color,
  // ) {
  //   Rect rect =
  //       Rect.fromCenter(center: center, width: itemWidth, height: itemWidth);
  //   canvas.drawRRect(
  //     RRect.fromRectAndRadius(rect, const Radius.circular(5)),
  //     _paint..color = color,
  //   );
  // }
  void drawItem(Canvas canvas, Offset center, Color color) {
    Rect rect = Rect.fromCenter(
      center: center,
      width: itemWidth,
      height: itemWidth,
    );
    canvas.save();
    // canvas.translate(center.dx, center.dy); //<--- tag1
    // canvas.rotate(rotateTween.evaluate(animation)); //<--- tag2
    // canvas.translate(-center.dx, -center.dy); //<--- tag3
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(5)),
      _paint..color = color,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RotateLoadingPainter oldDelegate) =>
      oldDelegate.itemWidth != itemWidth;
}
