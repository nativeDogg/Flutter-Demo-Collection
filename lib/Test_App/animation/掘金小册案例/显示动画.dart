import 'package:flutter/material.dart';

class ShowAniDemo1 extends StatefulWidget {
  const ShowAniDemo1({super.key});

  @override
  State<ShowAniDemo1> createState() => _ShowAniDemo1State();
}

class _ShowAniDemo1State extends State<ShowAniDemo1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _animation = Tween(begin: 0.0, end: 100.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _animation,
        child: RotationTransition(
          turns: _animation,
          child: Container(
            color: Colors.orange,
            width: _animation.value,
            height: _animation.value,
          ),
        ),
      ),
    );
  }
}

/// 显示动画DecoratedBoxTransition
class DecorBoxTranDemo extends StatefulWidget {
  const DecorBoxTranDemo({super.key});

  @override
  State<DecorBoxTranDemo> createState() => _DecorBoxTranDemoState();
}

class _DecorBoxTranDemoState extends State<DecorBoxTranDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Decoration> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _animation = DecorationTween(
      begin: const BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(
              offset: Offset(1, 1),
              color: Colors.purple,
              blurRadius: 5,
              spreadRadius: 2)
        ],
      ),
      end: const BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(
              offset: Offset(1, 5),
              color: Colors.orange,
              blurRadius: 10,
              spreadRadius: 1)
        ],
      ),
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: _animation.value,
      ),
    );
    // return AnimatedBuilder(animation: animation, builder: builder)
    // return AlignTransition(alignment: alignment, child: child)
  }
}
