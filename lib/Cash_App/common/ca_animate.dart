import 'dart:math';

import 'package:flutter/material.dart';

// 透明伸缩动画组件
class AnimatedScaleOpacity extends StatelessWidget {
  const AnimatedScaleOpacity(
      {required this.child,
      required this.animateIn,
      this.duration = const Duration(milliseconds: 500),
      this.durationOpacity = const Duration(milliseconds: 100),
      this.alignment = AlignmentDirectional.center,
      this.curve = Curves.easeInOutCubicEmphasized,
      super.key});
  final Widget child;
  final bool animateIn;
  final Duration duration;
  final Duration durationOpacity;
  final AlignmentDirectional alignment;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: durationOpacity,
      // 0代表透明 1代表不透明
      opacity: animateIn ? 1 : 0,
      child: AnimatedScale(
        // scale 1代表原始大小 0代表消失
        scale: animateIn ? 1 : 0,
        duration: duration,
        curve: curve,
        child: child,
        // alignment: Alignment.center,
        // alignment: alignment.resolve(direction),
      ),
    );
  }
}

// 伸缩组件
class ScaleIn extends StatefulWidget {
  // 子组件
  final Widget child;
  // 动画执行时间
  final Duration? duration;
  // 动画曲线
  final Curve curve;
  // 动画延迟后执行
  final Duration delay;
  // 循环动画延迟
  final Duration loopDelay;
  // 是否循环
  final bool loop;
  const ScaleIn({
    super.key,
    required this.child,
    this.duration,
    this.curve = const ElasticInCurve(0.5),
    this.delay = Duration.zero,
    this.loopDelay = Duration.zero,
    this.loop = false,
  });

  @override
  State<ScaleIn> createState() => _ScaleInState();
}

class _ScaleInState extends State<ScaleIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    // 初始化动画 开始动画
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });

    // 判断是否循环 完成动画间隔loopDelay之后重新执行 如果是不是则执行一次
    if (widget.loop) {
      _controller.addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            Future.delayed(widget.loopDelay, () {
              _controller.reverse();
            });
          } else if (status == AnimationStatus.dismissed) {
            _controller.forward();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// 伸缩改变组件
class ScaledAnimatedSwitcher extends StatelessWidget {
  const ScaledAnimatedSwitcher({
    required this.keyToWatch,
    required this.child,
    this.duration = const Duration(milliseconds: 450),
    Key? key,
  }) : super(key: key);

  final String keyToWatch;
  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeOut,
      child: SizedBox(key: ValueKey(keyToWatch), child: child),
      transitionBuilder: (child, animation) {
        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.5, 1),
          ),
        );

        final scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0, 1.0),
          ),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
    );
  }
}

class AnimatedSizeSwitcher extends StatelessWidget {
  const AnimatedSizeSwitcher({
    required this.child,
    this.sizeCurve = Curves.easeInOutCubicEmphasized,
    this.sizeDuration = const Duration(milliseconds: 800),
    this.switcherDuration = const Duration(milliseconds: 250),
    this.sizeAlignment = AlignmentDirectional.center,
    this.clipBehavior = Clip.hardEdge,
    this.enabled = true,
    super.key,
  });
  final Widget child;
  final Curve sizeCurve;
  final Duration sizeDuration;
  final Duration switcherDuration;
  final AlignmentDirectional sizeAlignment;
  final Clip clipBehavior;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: sizeDuration,
      curve: sizeCurve,
      alignment: sizeAlignment,
      child: AnimatedSwitcher(
        duration: switcherDuration,
        child: child,
      ),
    );
  }
}

/// 动画进度条
class CaAnimateCircularProgress extends StatefulWidget {
  final double percent;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? overageColor;
  final Color? overageShadowColor;
  final double strokeWidth;
  final double valueStrokeWidth;
  final double rotationOffsetPercent;
  const CaAnimateCircularProgress({
    super.key,
    required this.percent,
    required this.backgroundColor,
    required this.foregroundColor,
    this.overageColor,
    this.overageShadowColor,
    this.strokeWidth = 3.5,
    this.valueStrokeWidth = 4,
    this.rotationOffsetPercent = 0,
  });

  @override
  State<CaAnimateCircularProgress> createState() =>
      _CaAnimateCircularProgressState();
}

class _CaAnimateCircularProgressState extends State<CaAnimateCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    // 初始化控制器
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    // 将控制器绑定到动画
    _animation = Tween<double>(begin: 0, end: widget.percent).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );
    // 通过控制器开始动画
    _animationController.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CaAnimateCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percent != widget.percent) {
      _animationController.forward(from: 0);
      _animation = Tween<double>(begin: 0, end: widget.percent).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOutCubicEmphasized,
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _CaAnimateCircularProgressPainter(
            value: _animation.value,
            backgroundColor: widget.backgroundColor,
            foregroundColor: widget.foregroundColor,
            overageColor: widget.overageColor ?? Colors.transparent,
            overageShadowColor: widget.overageShadowColor ?? Colors.transparent,
            strokeWidth: widget.strokeWidth,
            valueStrokeWidth: widget.valueStrokeWidth,
            cornerRadius: widget.valueStrokeWidth,
          ),
        );
      },
    );
  }
}

class _CaAnimateCircularProgressPainter extends CustomPainter {
  final double value;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color overageColor;
  final Color overageShadowColor;
  final double strokeWidth;
  final double valueStrokeWidth;
  final double cornerRadius;

  _CaAnimateCircularProgressPainter({
    required this.value,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.overageColor,
    required this.overageShadowColor,
    required this.strokeWidth,
    required this.valueStrokeWidth,
    required this.cornerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // size的大小为(250,250) 因为在外层的BoxConstraints和AspectRatio设置了250的最大宽度和比例为1
    final center = size.center(Offset.zero);
    final radius = min(size.width, size.height) / 2;
    // 从-90度开始绘制 即从12点（顶点）方向开始绘制
    final startAngle = -pi / 2;
    // 当前进度应该扫过的角度
    final progressSweepAngle = 2 * pi * value.clamp(0.0, 1.0);
    // 背景圆弧的样式 即360度
    final backgroundSweepAngle = 2 * pi;

    // final overageSweepAngle = 2 * pi * (value - 1);

    // 定义背景圆弧的样式
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    // 定义当前进度的样式
    final valuePaint = Paint()
      ..color = foregroundColor
      ..strokeWidth = valueStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    // final overagePaint = Paint()
    //   ..color = overageColor
    //   ..strokeWidth = valueStrokeWidth + 1
    //   ..style = PaintingStyle.stroke
    //   ..strokeCap = StrokeCap.round;
    // final overagePaintShadow = Paint()
    //   ..color = overageShadowColor
    //   ..strokeWidth = valueStrokeWidth
    //   ..style = PaintingStyle.stroke
    //   ..strokeCap = StrokeCap.round
    //   ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

    final startAngleRadians = startAngle;
    final rect = Rect.fromCircle(center: center, radius: radius);

    /// 绘制背景圆弧整个进度条
    canvas.drawArc(
        rect, startAngleRadians, backgroundSweepAngle, false, backgroundPaint);

    /// 绘制当前进度
    canvas.drawArc(
        rect, startAngleRadians, progressSweepAngle, false, valuePaint);

    // if (value > 1.0) {
    //   if (value < 2.0)
    //     canvas.drawArc(rect, progressSweepAngle - startAngleRadians * 3,
    //         overageSweepAngle, false, overagePaintShadow);
    //   canvas.drawArc(rect, progressSweepAngle - startAngleRadians * 3,
    //       overageSweepAngle, false, overagePaint);
    // }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
