import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 布局APP
class ConstrainDemoApp extends StatefulWidget {
  const ConstrainDemoApp({super.key});

  @override
  State<ConstrainDemoApp> createState() => _ConstrainDemoAppState();
}

class _ConstrainDemoAppState extends State<ConstrainDemoApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // return ConstrainedBox1();
      // return ConstrainBox2();
      // body: ConstrainBox3(),
      // body: ConstrainBox4(),
      // body: ConstrainBox6(),
      // body: ConstrainBox7(),
      body: ConstrainBox8(),
    );
  }
}

class ConstrainedBox1 extends StatelessWidget {
  const ConstrainedBox1({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrain) {
        print('根结点将约束变成紧约束:${constrain}');
        return Container(
          width: 50,
          height: 50,
          color: Colors.orange,
          child: Center(
            child: LayoutBuilder(
              builder: (context, constrain) {
                print('Center组件将约束变成松约束:${constrain}');
                return Container(
                  color: Colors.yellow,
                  width: 300,
                  height: 300,
                  child: LayoutBuilder(
                    builder: (context, constrain) {
                      print('Container组件将约束变成紧约束:${constrain}');
                      return FlutterLogo();
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// 打破约束限制
class ConstrainBox2 extends StatelessWidget {
  const ConstrainBox2({super.key});

  @override
  Widget build(BuildContext context) {
    /// 使用UnconstrainedBox将紧约束解除
    // return UnconstrainedBox(
    //   child: Container(
    //     color: Colors.cyan.shade200,
    //     width: 50,
    //     height: 50,
    //     child: FlutterLogo(size: 1000),
    //   ),
    // );

    /// 使用Align、Center等组件变成松约束
    // return Align(
    //   alignment: Alignment.bottomCenter,
    //   child: FlutterLogo(size: 1000),
    // );

    /// 使用Align、Center等组件变成松约束
    return Center(
      child: FlutterLogo(size: 1000),
    );
  }
}

class ConstrainBox3 extends StatelessWidget {
  const ConstrainBox3({super.key});

  @override
  Widget build(BuildContext context) {
    /// IntrinsicWidth 会根据子组件的宽度来调整自己的宽度 取最长的作为宽度
    return const Center(
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          // stretch：拉伸子组件的宽度到最大
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton(onPressed: null, child: Text('b')),
            OutlinedButton(onPressed: null, child: Text('b2')),
            OutlinedButton(onPressed: null, child: Text('btn11111111')),
          ],
        ),
      ),
    );
  }
}

class ConstrainBox4 extends StatelessWidget {
  const ConstrainBox4({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 70,
          minHeight: 70,
          maxWidth: 150,
          maxHeight: 150,
        ),
        child: Container(color: Colors.red, width: 10, height: 10),
      ),
    );
  }
}

/// LimitedBox和ConstrainBox的区别
class ConstrainBox5 extends StatelessWidget {
  const ConstrainBox5({super.key});

  @override
  Widget build(BuildContext context) {
    /// 如果没有约束的前提下 LimitedBox会限制子组件的最大宽度
    // return UnconstrainedBox(
    //   child: LimitedBox(
    //     maxWidth: 100,
    //     child: Container(
    //       color: Colors.red,
    //       width: double.infinity,
    //       height: 100,
    //     ),
    //   ),
    // );

    /// 如果有约束的情况下 LimitedBox不会生效 Center将Root禁约束变成松约束
    return Center(
      child: LimitedBox(
        maxWidth: 100,
        child: Container(
          color: Colors.red,
          width: double.infinity,
          height: 100,
        ),
      ),
    );
  }
}

class ConstrainBox6 extends StatelessWidget {
  const ConstrainBox6({super.key});

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: FittedBox(
    //     child: Text('Some Example Text.'),
    //   ),
    // );
    return Center(
      child: FittedBox(
        child: Container(
          height: 20.0,
          width: 30.0,
          child: Text('Some Example Text.'),
        ),
      ),
    );
  }
}

class ConstrainBox7 extends StatelessWidget {
  const ConstrainBox7({super.key});

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: Row(
    //     children: [
    //       Expanded(
    //         child: Container(
    //           color: Colors.red,
    //           child: Text('This is a very long text that won’t fit the line.'),
    //         ),
    //       ),
    //       Container(color: Colors.green, child: Text('Goodbye!')),
    //     ],
    //   ),
    // );
    return Center(
      child: Container(
        color: Colors.yellow,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 200,
            minWidth: 50,
            minHeight: 50,
            maxHeight: 200,
          ),
          child: Container(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

class ConstrainBox8 extends StatelessWidget {
  const ConstrainBox8({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.red,
            width: double.infinity,
            // height: 100,
            height: double.infinity,
          )
        ],
      ),
    );
  }
}
