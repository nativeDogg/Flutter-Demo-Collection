import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Test_App/animation/%E6%8E%98%E9%87%91%E5%B0%8F%E5%86%8C%E6%A1%88%E4%BE%8B/%E6%8E%98%E9%87%91%E5%B0%8F%E5%86%8C%E6%A1%88%E4%BE%8B.dart';
import 'package:flutter_demo_collect/Test_App/animation/%E6%8E%98%E9%87%91%E5%B0%8F%E5%86%8C%E6%A1%88%E4%BE%8B/%E7%82%B9%E5%87%BB%E5%BC%B9%E5%87%BA%E5%A4%9A%E4%B8%AA%E6%8C%89%E9%92%AE%E5%8A%A8%E7%94%BB.dart';
import 'package:flutter_demo_collect/Test_App/animation/%E6%8E%98%E9%87%91%E5%B0%8F%E5%86%8C%E6%A1%88%E4%BE%8B/Loading%E7%BB%98%E5%88%B6.dart';
import 'package:flutter_demo_collect/Test_App/animation/%E6%8E%98%E9%87%91%E5%B0%8F%E5%86%8C%E6%A1%88%E4%BE%8B/%E6%98%BE%E7%A4%BA%E5%8A%A8%E7%94%BB.dart';
import 'package:flutter_demo_collect/Test_App/animation/%E9%9A%90%E5%BC%8F%E5%8A%A8%E7%94%BB.dart';

class AnimationDemoApp extends StatefulWidget {
  const AnimationDemoApp({super.key});

  @override
  State<AnimationDemoApp> createState() => _AnimationDemoAppState();
}

class _AnimationDemoAppState extends State<AnimationDemoApp> {
  late double angle = 0.1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: AniDemo1(),
      // body: AniDemo2(),
      // body: AniDemo3(),
      // body: AniDemo4(),
      // body: AniDemo5(),
      // 显示动画
      // body: ShowAniDemo1(),
      // 隐式动画
      // body: CoverAniDemo1(),
      // body: CircleAnim(),
      // 掘金小册
      body: CircleShineImage(),
      // body: Center(
      //   child: Column(
      //     children: [
      //       Slider(
      //           value: angle,
      //           onChanged: (value) {
      //             setState(() {
      //               angle = value;
      //             });
      //           }),
      //       Text((angle * 90.0).toString()),
      //       ToggleRotate(
      //         endAngle: angle * 90.0,
      //         child: const Text('Hello World'),
      //         onEnd: (_) {},
      //         curve: Curves.bounceInOut,
      //         onTap: () {},
      //       ),
      //     ],
      //   ),
      // ),
      // body: BurstMenusDemo(),
      // body: RotateLoading(),
      // body: DecorBoxTranDemo(),
    );
  }
}

class AniDemo1 extends StatefulWidget {
  const AniDemo1({super.key});

  @override
  State<AniDemo1> createState() => _AniDemo1State();
}

// 无限循环
class _AniDemo1State extends State<AniDemo1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween(begin: 0.0, end: 100.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.reverse();
      }
      if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.orange,
        width: _animation.value,
        height: _animation.value,
      ),
    );
  }
}

// 无限循环
class AniDemo2 extends StatefulWidget {
  const AniDemo2({super.key});

  @override
  State<AniDemo2> createState() => _AniDemo2State();
}

class _AniDemo2State extends State<AniDemo2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween(begin: 0.0, end: 100.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    // _controller.forward();
    // _animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     // _controller.reset();
    //     _controller.reverse();
    //   }
    //   if (status == AnimationStatus.dismissed) {
    //     _controller.forward();
    //   }
    // });
    _controller.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.orange,
        width: _animation.value,
        height: _animation.value,
      ),
    );
  }
}

class AniDemo3 extends StatefulWidget {
  const AniDemo3({super.key});

  @override
  State<AniDemo3> createState() => _AniDemo3State();
}

// 无限循环(变大后变小) 修改动画曲线
class _AniDemo3State extends State<AniDemo3>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween(begin: 0.0, end: 100.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn))
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.orange,
        width: _animation.value,
        height: _animation.value,
      ),
    );
  }
}

// 自定义曲线
class DampingCurve extends Curve {
  @override
  double transform(double t) {
    // 💡 实现阻尼效果的曲线逻辑
    return (1 - (1 - t) * (1 - t));
  }
}

// 多个动画并用
class AniDemo4 extends StatefulWidget {
  const AniDemo4({super.key});

  @override
  State<AniDemo4> createState() => _AniDemo4State();
}

class _AniDemo4State extends State<AniDemo4>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _rorateAnimation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _sizeAnimation = Tween(begin: 0.0, end: 100.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: DampingCurve(),
      ),
    )..addListener(() {
        setState(() {});
      });
    _rorateAnimation = Tween(begin: 0.0, end: 2 * pi).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    // _rorateAnimation = Tween(begin: 0.0, end: 2 * pi).animate(
    //   CurveTween(curve: Curves.bounceIn).animate(_controller),
    // );

    _controller.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: _rorateAnimation.value,
        child: Container(
          width: _sizeAnimation.value,
          height: _sizeAnimation.value,
          color: Colors.orange,
        ),
      ),
    );
  }
}

/// 多个动画并用 使用animatedBuilder 可以在初始化animation的时候不使用addListener和setState()
class AniDemo5 extends StatefulWidget {
  const AniDemo5({super.key});

  @override
  State<AniDemo5> createState() => _AniDemo5State();
}

class _AniDemo5State extends State<AniDemo5>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _rorateAnimation;
  late Animation<Offset> _parabolicAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _sizeAnimation = Tween(begin: 0.0, end: 100.0)
        .animate(CurvedAnimation(parent: _controller, curve: DampingCurve()));
    _rorateAnimation = Tween(begin: 0.0, end: 2 * pi).animate(_controller);
    _parabolicAnimation = Tween<Offset>(
            begin: const Offset(0, 300), end: const Offset(0, -200))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _parabolicAnimation.value,
            child: Transform.rotate(
              angle: _rorateAnimation.value,
              child: Container(
                width: _sizeAnimation.value,
                height: _sizeAnimation.value,
                color: Colors.orange,
              ),
            ),
          );
        },
      ),
    );
  }
}
