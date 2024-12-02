import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/ca_home.dart';
import 'package:flutter_demo_collect/Food_App/model/recipe_model.dart';
import 'package:flutter_demo_collect/Food_App/pages/home.dart';
import 'package:flutter_demo_collect/Movie_App/pages/home.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final RecipeItems recipeItem = recipeItems.first;
    return MaterialApp(
      // 电影
      // home: MovieAppHomePage(),
      // 食物
      // home: FoodAppHomePage(recipeItems: recipeItem),
      // 记账
      home: CashAppHomePage(),
    );
  }
}
