import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// 通过包裹整个widget 获取其尺寸
class WidgetSize extends StatefulWidget {
  final Widget child;
  final Function(Size size) onChange;

  const WidgetSize({
    Key? key,
    required this.onChange,
    required this.child,
  }) : super(key: key);

  @override
  _WidgetSizeState createState() => _WidgetSizeState();
}

class _WidgetSizeState extends State<WidgetSize> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.hasBoundedWidth || constraints.hasBoundedHeight) {
          // 我們需要第二次呼叫，因為第一次呼叫可能會導致這個錯誤：
          // 這個渲染物件的大小尚未確定，因為這個渲染物件尚未經過佈局，這通常表示在佈局期間框架尚未確定渲染物件的大小和位置之前，在管道中過早 (例如在建立階段) 呼叫 size getter。
          // 第二次呼叫會在繪圖完成後，以有界線的測量方式更新 Widget
          // 如果尺寸不同，UI 也會相應更新。
          WidgetsBinding.instance.addPostFrameCallback(postFrameCallback);
        }
        return widget.child;
      }),
    );
  }

  var widgetKey = GlobalKey();
  var oldSize;

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    try {
      Size newSize = context.size ?? Size(0, 0);
      if (oldSize == newSize) return;

      oldSize = newSize;
      widget.onChange(newSize);
    } catch (e) {
      print(e.toString());
    }
  }
}
