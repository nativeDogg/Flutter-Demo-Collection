import 'package:flutter/material.dart';

/// 跳转方法
Future<dynamic> pushRoute(BuildContext context, Widget page,
    {String? routeName}) async {
  // minimizeKeyboard(context);
  // if (appStateSettings["iOSNavigation"]) {
  //   return await Navigator.push(
  //     context,
  //     CustomMaterialPageRoute(builder: (context) => page),
  //   );
  // }

  return await Navigator.push(
    context,
    // MaterialPageRoute(builder: (context) => page)
    PageRouteBuilder(
      // opaque: false,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 125),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(0, 0.05), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
    ),
  );
}
