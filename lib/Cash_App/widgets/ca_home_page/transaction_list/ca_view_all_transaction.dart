import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_tappable.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_text_font.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_month_transaction/ca_view_month_transcation.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CaViewAllTransaction extends StatelessWidget {
  const CaViewAllTransaction({this.onPress, super.key});
  final Function? onPress;

  @override
  Widget build(BuildContext context) {
    return LowKeyButton(
      onTap: () {
        if (onPress != null) {
          onPress!();
        } else {
          showMaterialModalBottomSheet(
            context: context,
            builder: (context) {
              return const CaViewMonthTranscation();
            },
          );
        }
      },
      text: "查看所有交易",
    );
  }
}

class LowKeyButton extends StatelessWidget {
  const LowKeyButton({
    super.key,
    required this.onTap,
    required this.text,
    this.extraWidget,
    this.extraWidgetAtBeginning = false,
    this.color,
    this.textColor,
  });
  final VoidCallback onTap;
  final String text;
  final Widget? extraWidget;
  final bool extraWidgetAtBeginning;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
      child: Tappable(
        color: color ?? Colors.black.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 15, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (extraWidgetAtBeginning)
                extraWidget ?? const SizedBox.shrink(),
              Expanded(
                child: TextFont(
                  text: text,
                  textAlign: TextAlign.center,
                  fontSize: 14,
                  textColor: textColor ?? Colors.black.withOpacity(0.5),
                  maxLines: 5,
                ),
              ),

              /// 文字后面加上额外组件
              if (extraWidgetAtBeginning == false)
                extraWidget ?? SizedBox.shrink(),
            ],
          ),
        ),
        onTap: onTap,
        borderRadius: Platform.isIOS ? 8 : 13,
      ),
    );
  }
}
