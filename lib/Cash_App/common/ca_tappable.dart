// 点击组件
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_enum.dart';

class Tappable extends StatelessWidget {
  Tappable({
    Key? key,
    this.onTap,
    this.onHighlightChanged,
    this.borderRadius = 0,
    this.customBorderRadius,
    this.color,
    this.type = MaterialType.canvas,
    required this.child,
    this.onLongPress,
    this.hasOpacity = true,
    this.disable = false,
  }) : super(key: key);

  final double borderRadius;
  final BorderRadius? customBorderRadius;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onHighlightChanged;
  final Color? color;
  final Widget child;
  final MaterialType type;
  final VoidCallback? onLongPress;
  final bool hasOpacity;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      // IOS直接返回
      return FadedButton(
        child: child,
        onTap: onTap,
        borderRadius: customBorderRadius ?? BorderRadius.circular(borderRadius),
        // color: color ?? Theme.of(context).canvasColor,
        color: color ?? Colors.white,
        onLongPress: onLongPress != null
            ? () {
                if (Platform.isIOS) {
                  HapticFeedback.heavyImpact();
                }
                onLongPress!();
              }
            : null,
        pressedOpacity: hasOpacity ? 0.5 : 1,
      );
    }

    Widget tappable = Material(
      color: color ?? Theme.of(context).canvasColor,
      type: type,
      borderRadius:
          customBorderRadius ?? BorderRadiusDirectional.circular(borderRadius),
      child: InkWell(
        splashFactory: kIsWeb
            ? InkRipple.splashFactory
            : InkSparkle.constantTurbulenceSeedSplashFactory,
        borderRadius: customBorderRadius ?? BorderRadius.circular(borderRadius),
        onTap: onTap,
        onHighlightChanged: onHighlightChanged,
        child: child,
        onLongPress: onLongPress,
      ),
    );
    if (!kIsWeb && onLongPress != null) {
      return tappable;
    }

    Future<void> _onPointerDown(PointerDownEvent event) async {
      // 如果是鼠标操作 监听鼠标右键
      if (event.kind == PointerDeviceKind.mouse &&
          event.buttons == kSecondaryMouseButton) {
        if (onLongPress != null) onLongPress!();
      }
    }

    return Listener(
      child: tappable,
      onPointerDown: _onPointerDown,
    );
  }
}

class FadedButton extends StatefulWidget {
  const FadedButton({
    super.key,
    required this.child,
    this.pressedOpacity = 0.5,
    required this.onTap,
    required this.onLongPress,
    required this.borderRadius,
    required this.color,
  });

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double pressedOpacity;
  final Widget child;
  final BorderRadius borderRadius;
  final Color color;

  @override
  State<FadedButton> createState() => _FadedButtonState();
}

class _FadedButtonState extends State<FadedButton>
    with SingleTickerProviderStateMixin {
  static const Duration kFadeOutDuration = Duration(milliseconds: 150);
  static const Duration kFadeInDuration = Duration(milliseconds: 230);
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation = _animationController
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(_opacityTween);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = widget.pressedOpacity;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _buttonHeldDown = false;

  // 当用户的手指首次接触到屏幕时触发。
  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  // 当用户抬起手指，结束触摸操作时触发。
  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
    }
    // 当动画已经完成了情况下 重置状态
    if (_animationController.value >= 1) {
      _animationController.animateTo(0.0,
          duration: kFadeInDuration, curve: Curves.easeOutCubic);
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  // 这里应该是一个字体样式改变的动画
  // 如果是按下的状态 那么动画从0到1
  // 如果是抬起的动画 那么动画从1到0
  void _animate() {
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(1.0,
            duration: kFadeOutDuration, curve: Curves.easeInOutCubicEmphasized)
        : _animationController.animateTo(0.0,
            duration: kFadeInDuration, curve: Curves.easeOutCubic);
    // 如果是结束了动画 重新走一遍相反动画
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) {
        _animate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget tappable = MouseRegion(
      cursor: kIsWeb ? SystemMouseCursors.click : MouseCursor.defer,
      child: IgnorePointer(
        ignoring: widget.onLongPress == null && widget.onTap == null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          // 当用户的手指首次接触到屏幕时触发。
          onTapDown: _handleTapDown,
          // 当用户抬起手指，结束触摸操作时触发。
          onTapUp: _handleTapUp,
          // 当一个触摸事件被中断，即在 onTapDown 之后，如果没有顺利执行 onTapUp 和 onTap，则会触发 onTapCancel
          onTapCancel: _handleTapCancel,
          onTap: widget.onTap,
          // Use null so other long press actions can be captured
          onLongPress: widget.onLongPress == null
              ? null
              : () {
                  _animate();
                  widget.onLongPress!();
                },
          child: Semantics(
            button: true,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius,
                  color: widget.color,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );

    if (!kIsWeb && widget.onLongPress != null) {
      return tappable;
    }

    Future<void> _onPointerDown(PointerDownEvent event) async {
      // Check if right mouse button clicked
      if (event.kind == PointerDeviceKind.mouse &&
          event.buttons == kSecondaryMouseButton) {
        if (widget.onLongPress != null) widget.onLongPress!();
      }
    }

    return Listener(
      child: tappable,
      onPointerDown: _onPointerDown,
    );
  }
}
