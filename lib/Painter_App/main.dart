import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

class RotateExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Canvas.rotate 示例'),
      ),
      body: Center(
        child: CustomPaint(
          size: Size(300, 300), // 指定画布大小
          painter: RotatePainter(),
        ),
      ),
    );
  }
}

class RotatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 定义画笔
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // 保存当前状态
    canvas.save();

    // 平移画布到 (150, 150)
    canvas.translate(150, 200);

    // 旋转画布 45 度
    double degrees = 45;
    double radians = degrees * (3.141592653589793 / 180);
    canvas.rotate(radians);

    // 绘制矩形
    canvas.drawRect(
      Rect.fromLTWH(-50, -50, 100, 100),
      paint,
    );

    // 恢复之前保存的状态
    canvas.restore();

    // 再次绘制一个未旋转的矩形作为对比
    paint.color = Colors.red;
    canvas.drawRect(
      Rect.fromLTWH(100, 100, 100, 100),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Paper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Container(
          color: Colors.white,
          child: CustomPaint(
            // 使用CustomPaint
            painter: PaperPainter(),
          ),
        );
      },
    );
  }
}

class PaperPainter extends CustomPainter {
  // 绘制点
  // @override
  // void paint(Canvas canvas, Size size) {
  //   // 创建画笔
  //   final Paint paint = Paint();
  //   final Path path = Path();
  //   // 绘制圆
  //   canvas.drawCircle(Offset(100, 100), 10, paint);
  // }

  // 绘制圆形 线宽
  // @override
  // void paint(Canvas canvas, _) {
  //   Paint paint = Paint()..color = Colors.red;
  //   canvas.drawCircle(
  //     Offset(180, 180),
  //     150,
  //     paint..style = PaintingStyle.fill,
  //   );
  //   canvas.drawCircle(
  //     Offset(500, 180),
  //     150,
  //     paint
  //       ..style = PaintingStyle.stroke
  //       ..strokeWidth = 10,
  //   );
  // }

  // // 绘制直线
  // @override
  // void paint(Canvas canvas, _) {
  //   final Paint paint = Paint();

  //   /// 绘制圆头直线
  //   canvas.drawLine(
  //     Offset(50, 50),
  //     Offset(200, 200),
  //     paint
  //       ..strokeCap = StrokeCap.round
  //       ..strokeWidth = 50,
  //   );

  //   /// 绘制方头直线 出头
  //   canvas.drawLine(
  //     Offset(100, 150),
  //     Offset(200, 200),
  //     paint
  //       ..strokeCap = StrokeCap.square
  //       ..strokeWidth = 50
  //       ..color = Colors.blue,
  //   );

  //   /// 绘制方头直线 不出头
  //   canvas.drawLine(
  //     Offset(120, 200),
  //     Offset(200, 200),
  //     paint
  //       ..strokeCap = StrokeCap.butt
  //       ..strokeWidth = 50
  //       ..color = Colors.red,
  //   );
  // }

  // invertColors反色
  // @override
  // void paint(Canvas canvas, Size size) {
  //   final Paint _paint = Paint();
  //   // 绿色
  //   _paint..color = Color(0xff009A44);
  //   canvas.drawCircle(Offset(100, 100), 50, _paint..invertColors = false);
  //   canvas.drawCircle(
  //       Offset(100 + 120.0, 100), 50, _paint..invertColors = true);
  // }

  // late Paint _gridPint; // 画笔
  // final double step = 20; // 小格边长
  // final double strokeWidth = .5; // 线宽
  // final Color color = Colors.grey; // 线颜色

  // PaperPainter() {
  //   _gridPint = Paint()
  //     ..style = PaintingStyle.stroke
  //     ..strokeWidth = strokeWidth
  //     ..color = color;
  // }

  // void drawBottom(Canvas canvas, Size size) {
  //   canvas.save();
  //   for (int i = 0; i < size.height / 2 / step; i++) {
  //     canvas.drawLine(Offset(0, 0), Offset(size.width / 2, 0), _gridPint);
  //     canvas.translate(0, step);
  //   }
  //   canvas.restore();

  //   canvas.save();
  //   for (int i = 0; i < size.width / 2 / step; i++) {
  //     canvas.drawLine(Offset(0, 0), Offset(0, size.height / 2), _gridPint);
  //     canvas.translate(step, 0);
  //   }
  //   canvas.restore();
  // }

  // @override
  // void paint(Canvas canvas, Size size) {
  //   drawBottom(canvas, size);
  //   canvas.save();
  //   canvas.scale(1, -1); //沿x轴镜像
  //   drawBottom(canvas, size);
  //   canvas.restore();

  //   canvas.save();
  //   canvas.scale(-1, 1); //沿y轴镜像
  //   drawBottom(canvas, size);
  //   canvas.restore();

  //   canvas.save();
  //   canvas.scale(-1, -1); //沿原点镜像
  //   drawBottom(canvas, size);
  //   canvas.restore();
  // }

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 1.5;
    // canvas.translate(size.width / 2, size.height / 2);
    canvas.drawLine(Offset(0, 10), Offset(100, 10), _paint);
    // canvas.drawLine(
    //     Offset(0, -size.height / 2), Offset(0, size.height / 2), _paint);
    // canvas.drawLine(Offset(0, size.height / 2),
    //     Offset(0 - 7.0, size.height / 2 - 10), _paint);
    // canvas.drawLine(Offset(0, size.height / 2),
    //     Offset(0 + 7.0, size.height / 2 - 10), _paint);
    // canvas.drawLine(
    //     Offset(size.width / 2, 0), Offset(size.width / 2 - 10, 7), _paint);
    // canvas.drawLine(
    //     Offset(size.width / 2, 0), Offset(size.width / 2 - 10, -7), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
