import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_collect/Cash_App/ca_home_page.dart';
import 'package:flutter_demo_collect/Constrain_App/index.dart';
import 'package:flutter_demo_collect/Food_App/model/recipe_model.dart';
import 'package:flutter_demo_collect/I10n_App/index.dart';
import 'package:flutter_demo_collect/Painter_App/main.dart';
import 'package:flutter_demo_collect/Test_App/animation/index.dart';
import 'package:flutter_demo_collect/Test_App/constraint.dart';
import 'package:flutter_demo_collect/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized(); // 确定初始化
  // SystemChrome.setPreferredOrientations(// 使设备横屏显示
  //     [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  // // SystemChrome.setEnabledSystemUIOverlays([]); // 全屏显示
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
  //     overlays: []); // 全屏显示
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final RecipeItems recipeItem = recipeItems.first;
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportLocales) {
        print("当前系统语言：------>${deviceLocale!.countryCode}");
        return deviceLocale;
      },
      supportedLocales: [
        const Locale('en', 'US'), // 美国英语
        const Locale('zh', 'CN'), // 中文简体
        //其他Locales
      ],
      // 电影
      // home: MovieAppHomePage(),
      // 食物
      // home: FoodAppHomePage(recipeItems: recipeItem),
      // 记账
      // home: CaHomePage(),

      // 测试
      // home: ConstraintApp(),
      // 动画demo
      // home: AnimationDemoApp(),
      // 绘制
      // home: Paper(),
      // home: RotateExample(),
      // 国际化
      // home: I10nApp(),
      // 约束布局APP
      home: ConstrainDemoApp(),
    );
  }
}

/// Align的宽高因子
class AlignDemo extends StatelessWidget {
  const AlignDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 100,
      child: UnconstrainedBox(
        child: ColoredBox(
          color: Colors.blue,
          child: Align(
            heightFactor: 1.5,
            widthFactor: 2,
            alignment: Alignment.centerLeft,
            child: Container(
              height: 60,
              width: 60,
              color: Colors.orangeAccent,
            ),
          ),
        ),
      ),
    );
  }
}
