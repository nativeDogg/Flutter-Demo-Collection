import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_function.dart';

class CaScrollbarWrap extends StatelessWidget {
  const CaScrollbarWrap({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // disable in debug mode because of scroll controller warnings
    if (kIsWeb || kDebugMode) {
      return child;
    }
    return MediaQuery.removePadding(
      context: context,
      removeLeft: true,
      removeRight: true,
      child: RawScrollbar(
        thumbColor: dynamicPastel(
          context,
          Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.3),
          amountDark: 0.3,
        ),
        radius: const Radius.circular(20),
        thickness: 3,
        child: child,
      ),
    );
  }
}
