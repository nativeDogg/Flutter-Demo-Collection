import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_function.dart';

class CustomColorTheme extends StatelessWidget {
  final Widget child;
  final Color accentColor;
  const CustomColorTheme({
    super.key,
    required this.child,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = ColorScheme.fromSeed(
        seedColor: accentColor, brightness: Brightness.light);
    return Theme(
      data: generateThemeDataWithExtension(
        accentColor: accentColor,
        brightness: Theme.of(context).brightness,
        themeData: Theme.of(context).copyWith(
          colorScheme: colorScheme,
        ),
      ),
      child: child,
    );
  }
}

ThemeData generateThemeDataWithExtension(
    {required ThemeData themeData,
    required Brightness brightness,
    required Color accentColor}) {
  AppColors colors = getAppColors(
    accentColor: accentColor,
    brightness: brightness,
    themeData: themeData,
  );

  return themeData.copyWith(
    extensions: <ThemeExtension<dynamic>>[colors],
    appBarTheme: AppBarTheme(
      systemOverlayStyle: getSystemUiOverlayStyle(colors, brightness),
    ),
  );
}

SystemUiOverlayStyle getSystemUiOverlayStyle(
    AppColors? colors, Brightness brightness) {
  if (brightness == Brightness.light) {
    return SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      systemStatusBarContrastEnforced: false,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: kIsWeb ? Colors.black : Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: getBottomNavbarBackgroundColor(
        colorScheme: getColorScheme(brightness),
        brightness: Brightness.light,
        lightDarkAccent: colors?.colors["lightDarkAccent"] ?? Colors.white,
      ),
    );
  } else {
    return SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      systemStatusBarContrastEnforced: false,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: kIsWeb ? Colors.black : Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: getBottomNavbarBackgroundColor(
        colorScheme: getColorScheme(brightness),
        brightness: Brightness.dark,
        lightDarkAccent: colors?.colors["lightDarkAccent"] ?? Colors.black,
      ),
    );
  }
}

ColorScheme getColorScheme(Brightness brightness) {
  if (brightness == Brightness.light) {
    return ColorScheme.fromSeed(
      seedColor: Colors.blue,
      // seedColor: getSettingConstants(appStateSettings)["accentColor"],
      brightness: Brightness.light,
      background: Colors.white,
    );
  } else {
    return ColorScheme.fromSeed(
      seedColor: Colors.blue,
      // seedColor: getSettingConstants(appStateSettings)["accentColor"],
      brightness: Brightness.dark,
      background: Colors.black,
    );
  }
}

Color getBottomNavbarBackgroundColor({
  required ColorScheme colorScheme,
  required Brightness brightness,
  required Color lightDarkAccent,
}) {
  if (Platform.isIOS) {
    return brightness == Brightness.light
        ? lightenPastel(colorScheme.secondaryContainer, amount: 0.55)
        : darkenPastel(colorScheme.secondaryContainer, amount: 0.55);
  } else {
    if (brightness == Brightness.light) {
      return lightenPastel(
        colorScheme.secondaryContainer,
        amount: 0.4,
      );
    } else {
      return darkenPastel(
        colorScheme.secondaryContainer,
        amount: 0.45,
      );
    }
  }
  // else if (appStateSettings["materialYou"] == true) {
  //   if (brightness == Brightness.light) {
  //     return lightenPastel(
  //       colorScheme.secondaryContainer,
  //       amount: 0.4,
  //     );
  //   } else {
  //     return darkenPastel(
  //       colorScheme.secondaryContainer,
  //       amount: 0.45,
  //     );
  //   }
  // } else {
  //   return lightDarkAccent;
  // }
}

AppColors getAppColors(
    {required Brightness brightness,
    required ThemeData themeData,
    required Color accentColor}) {
  Color lightDarkAccentHeavyLight = brightness == Brightness.light
      ? lightenPastel(
          themeData.colorScheme.primary,
          amount: 0.96,
        )
      : darkenPastel(accentColor, amount: 0.8);

  return brightness == Brightness.light
      ? AppColors(
          colors: {
            "white": Colors.white,
            "black": Colors.black,
            // "textLight": appStateSettings["increaseTextContrast"]
            //     ? Colors.black.withOpacity(0.7)
            //     : appStateSettings["materialYou"]
            //         ? Colors.black.withOpacity(0.4)
            //         : Color(0xFF888888),
            "textLight": Colors.black.withOpacity(0.7),
            // "lightDarkAccent": appStateSettings["materialYou"]
            //     ? lightenPastel(accentColor, amount: 0.6)
            //     : Color(0xFFF7F7F7),
            "lightDarkAccent": lightenPastel(accentColor, amount: 0.6),
            "lightDarkAccentHeavyLight": lightDarkAccentHeavyLight,
            "canvasContainer": const Color(0xFFEBEBEB),
            "lightDarkAccentHeavy": Color(0xFFEBEBEB),
            "shadowColor": const Color(0x655A5A5A),
            "shadowColorLight": const Color(0x2D5A5A5A),
            "unPaidUpcoming": Color(0xFF58A4C2),
            "unPaidOverdue": Color(0xFF6577E0),
            "incomeAmount": Color(0xFF59A849),
            "expenseAmount": Color(0xFFCA5A5A),
            "warningOrange": Color(0xFFCA995A),
            "starYellow": Color(0xFFFFD723),
            // "dividerColor": appStateSettings["materialYou"]
            //     ? Color(0x0F000000)
            //     : Color(0xFFF0F0F0),
            // "standardContainerColor": getPlatform() == PlatformOS.isIOS
            //     ? themeData.canvasColor
            //     : appStateSettings["materialYou"]
            //         ? lightenPastel(
            //             themeData.colorScheme.secondaryContainer,
            //             amount: 0.3,
            //           )
            //         : lightDarkAccentHeavyLight,
            "dividerColor": const Color(0xFFF0F0F0),
            "standardContainerColor": Platform.isIOS
                ? themeData.canvasColor
                : lightenPastel(
                    themeData.colorScheme.secondaryContainer,
                    amount: 0.3,
                  ),
          },
        )
      : AppColors(
          colors: {
            "white": Colors.black,
            "black": Colors.white,
            // "textLight": appStateSettings["increaseTextContrast"]
            //     ? Colors.white.withOpacity(0.65)
            //     : appStateSettings["materialYou"]
            //         ? Colors.white.withOpacity(0.25)
            //         : Color(0xFF494949),
            "textLight": Colors.white.withOpacity(0.65),

            "lightDarkAccent": const Color(0xFF161616),
            // "lightDarkAccent": appStateSettings["materialYou"]
            //     ? darkenPastel(accentColor, amount: 0.83)
            //     : Color(0xFF161616),
            "lightDarkAccentHeavyLight": lightDarkAccentHeavyLight,
            "canvasContainer": const Color(0xFF242424),
            "lightDarkAccentHeavy": const Color(0xFF444444),
            "shadowColor": const Color(0x69BDBDBD),
            // "shadowColorLight": appStateSettings["materialYou"]
            //     ? Colors.transparent
            //     : Color(0x28747474),
            "shadowColorLight": Colors.transparent,
            "unPaidUpcoming": const Color(0xFF7DB6CC),
            "unPaidOverdue": const Color(0xFF8395FF),
            "incomeAmount": const Color(0xFF62CA77),
            "expenseAmount": const Color(0xFFDA7272),
            "warningOrange": const Color(0xFFDA9C72),
            "starYellow": Colors.yellow,
            // "dividerColor": appStateSettings["materialYou"]
            //     ? Color(0x13FFFFFF)
            //     : Color(0xFF161616),
            "dividerColor": const Color(0x13FFFFFF),
            "standardContainerColor": Platform.isIOS
                ? themeData.canvasColor
                : darkenPastel(
                    themeData.colorScheme.secondaryContainer,
                    amount: 0.6,
                  )
          },
        );
}

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.colors,
  });

  final Map<String, Color?> colors;

  @override
  AppColors copyWith({Map<String, Color?>? colors}) {
    return AppColors(
      colors: colors ?? this.colors,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    final Map<String, Color?> lerpColors = {};
    colors.forEach((key, value) {
      lerpColors[key] = Color.lerp(colors[key], other.colors[key], t);
    });

    return AppColors(
      colors: lerpColors,
    );
  }
}
