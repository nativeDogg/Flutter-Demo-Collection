import 'package:flutter/material.dart';

/// 隐式动画都是用AnimatedWidget包裹的，AnimatedWidget会监听Animation对象的变化，当Animation对象发生变化时，会调用AnimatedWidget的build方法，重新构建Widget树。

/// 隐式动画（平移）
class AnimatedTranslate extends ImplicitlyAnimatedWidget {
  const AnimatedTranslate({
    super.key,
    required this.offset,
    required super.duration,
    this.child,
  });

  final Offset offset;
  final Widget? child;

  @override
  AnimatedWidgetBaseState createState() => _AnimatedTranslateState();
}

class _AnimatedTranslateState
    extends AnimatedWidgetBaseState<AnimatedTranslate> {
  // 💡 用于平移的补间动画
  Tween<Offset>? _offsetTween;

  // 💡 重写此方法，遍历当前补间动画，检查是否需要创建新的补间动画或更新现有的补间动画，返回新的补间动画
  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _offsetTween = visitor(
      _offsetTween,
      widget.offset,
      (dynamic value) => Tween<Offset>(begin: value as Offset),
    ) as Tween<Offset>?;
  }

  @override
  Widget build(BuildContext context) {
    // 💡 根据 Animation<double> 对象的当前值，计算出对应的插值结果
    return Transform.translate(
      offset: _offsetTween?.evaluate(animation) ?? Offset.zero,
      child: widget.child,
    );
  }
}

class CoverAniDemo1 extends StatefulWidget {
  const CoverAniDemo1({super.key});

  @override
  State<CoverAniDemo1> createState() => _CoverAniDemo1State();
}

class _CoverAniDemo1State extends State<CoverAniDemo1> {
  final Duration _animationDuration = const Duration(seconds: 2);
  double _animationValue = 0.0;
  Offset _offset = const Offset(0, 300);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _animationValue = _animationValue == 0.0 ? 1.0 : 0.0;
              _offset = _offset == const Offset(0, 300)
                  ? const Offset(0, 0)
                  : const Offset(0, 300);
            });
          },
          child: const Text('开始动画'),
        ),
        const SizedBox(height: 20),
        AnimatedTranslate(
          offset: _offset,
          duration: _animationDuration,
          child: AnimatedScale(
            scale: _animationValue,
            duration: _animationDuration,
            child: AnimatedRotation(
              turns: _animationValue,
              duration: _animationDuration,
              child: Container(
                width: 300,
                height: 300,
                color: Colors.blue,
              ),
            ),
          ),
        )
      ],
    );
  }
}
