import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_function.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_text_font.dart';

class CaTextInput extends StatelessWidget {
  final String labelText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool obscureText;
  final IconData? icon;
  final EdgeInsetsDirectional padding;
  final bool autoFocus;
  final VoidCallback? onEditingComplete;
  final String? initialValue;
  final TextEditingController? controller;
  final bool? showCursor;
  final bool readOnly;
  final int? minLines;
  final int? maxLines;
  final bool numbersOnly;
  final String? prefix;
  final String? suffix;
  final double paddingRight;
  final FocusNode? focusNode;
  final ScrollController? scrollController;
  final bool? bubbly;
  final Color? backgroundColor;
  final TextInputType? keyboardType;
  final double? fontSize;
  final FontWeight fontWeight;
  final double? topContentPadding;
  final TextCapitalization? textCapitalization;
  final BorderRadius? borderRadius;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final bool autocorrect;
  final int? maxLength;

  const CaTextInput({
    super.key,
    required this.labelText,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.obscureText = false,
    this.icon,
    this.padding = const EdgeInsetsDirectional.only(start: 18.0, end: 18),
    this.autoFocus = false,
    this.onEditingComplete,
    this.initialValue,
    this.controller,
    this.showCursor,
    this.readOnly = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.numbersOnly = false,
    this.prefix,
    this.suffix,
    this.paddingRight = 12,
    this.focusNode,
    this.scrollController,
    this.bubbly = true,
    this.backgroundColor,
    this.keyboardType,
    this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.topContentPadding,
    this.textCapitalization,
    this.borderRadius,
    this.textInputAction,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.autocorrect = true,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      // 底色
      child: Container(
        decoration: BoxDecoration(
          color: bubbly == false
              ? Colors.transparent
              : Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: TextFormField(
            scrollController: scrollController,
            maxLength: maxLength,

            /// 用于定义一个或多个输入格式化器。这些格式化器可以控制用户输入的文本格式
            inputFormatters: inputFormatters,

            /// 用于定义当用户完成输入后按下软键盘上的“完成”按钮时的行为。
            /// 例如，TextInputAction.done 表示完成输入，TextInputAction.go 可以用于搜索框，用户按下按钮后执行搜索操作。
            textInputAction: textInputAction,

            /// 用于控制文本的首字母大写规则。
            ///例如，TextCapitalization.words 会使每个单词的首字母大写，TextCapitalization.sentences 会使每个句子的首字母大写。
            textCapitalization:
                textCapitalization ?? TextCapitalization.sentences,

            /// 用于控制文本在垂直方向上的对齐方式。
            /// 例如，TextAlignVertical.top 将文本顶部对齐，TextAlignVertical.center 将文本垂直居中。
            textAlignVertical: kIsWeb ? TextAlignVertical.bottom : null,

            ///bool 类型，默认值为 true。控制是否允许输入法（IME）基于用户的输入历史进行个性化学习，以提供更准确的预测文本和自动完成建议。
            enableIMEPersonalizedLearning: false,
            scrollPadding: EdgeInsets.only(bottom: 80),

            /// 用于控制输入字段的焦点状态。通过 FocusNode，你可以添加监听器来响应焦点的变化，或者手动请求焦点
            /// 例如，你可以使用 focusNode.requestFocus() 来将焦点设置到这个 TextFormField 上，或者使用 focusNode.addListener() 来监听焦点变化。
            focusNode: focusNode,

            /// 键盘类型
            keyboardType: keyboardType ??
                (numbersOnly ? TextInputType.number : TextInputType.text),
            maxLines: maxLines,
            minLines: minLines,

            /// bool 类型，默认值为 true。控制是否在文本字段中显示光标。
            showCursor: showCursor,

            /// Color 类型，用于设置光标的颜色。
            cursorColor: dynamicPastel(
              context,
              Theme.of(context).colorScheme.primary,
              amount: 0.2,
              inverse: false,
            ),
            readOnly: readOnly,
            controller: controller,
            initialValue: initialValue,
            autofocus: autoFocus,

            /// VoidCallback 类型，当用户完成编辑（例如，点击软键盘上的“完成”按钮）时调用。
            onEditingComplete: onEditingComplete,

            /// TextAlign 类型，用于设置文本在水平方向上的对齐方式，如 TextAlign.left、TextAlign.center、TextAlign.right 等。
            textAlign: textAlign,

            /// bool 类型，默认值为 true。控制是否启用自动更正功能。
            autocorrect: autocorrect,

            /// bool 类型，默认值为 false。如果设置为 true，则文本会被隐藏，适用于密码输入。
            obscureText: obscureText,

            /// GestureTapCallback 类型，当文本字段被点击时调用。
            onTap: onTap,

            /// ValueChanged<String> 类型，每当文本字段的内容发生变化时调用。
            onChanged: (text) {
              if (onChanged != null) {
                onChanged!(text);
              }
            },

            /// ValueChanged<String> 类型，当用户完成输入（例如，按下软键盘上的“完成”或“发送”按钮）时调用。
            onFieldSubmitted: (text) {
              if (onSubmitted != null) {
                onSubmitted!(text);
              }
            },
            style: TextStyle(
              fontSize: fontSize ?? (bubbly == false ? 18 : 15),
              height: kIsWeb
                  ? null
                  : bubbly == true
                      ? 1.7
                      : 1.3,
              fontWeight: fontWeight,
              // fontFamily: appStateSettings["font"],
              fontFamilyFallback: ['Inter'],
            ),

            decoration: InputDecoration(
              counterText: "",
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
              alignLabelWithHint: true,
              prefix: prefix != null ? TextFont(text: prefix ?? "") : null,
              suffix: suffix != null ? TextFont(text: suffix ?? "") : null,
              contentPadding: EdgeInsetsDirectional.only(
                start: bubbly == false ? (kIsWeb ? 8 + 5 : 8) : 18,
                end: (kIsWeb ? paddingRight + 5 : paddingRight),
                top: topContentPadding != null
                    ? topContentPadding ?? 0
                    : (bubbly == false ? 15 : 18),
                bottom: bubbly == false ? (kIsWeb ? 8 : 5) : (kIsWeb ? 15 : 0),
              ),
              hintText: labelText,
              filled: bubbly == false ? true : false,
              fillColor: Colors.transparent,
              isDense: true,
              suffixIconConstraints: BoxConstraints(maxHeight: 20),
              suffixIcon: bubbly == false || icon == null
                  ? null
                  : Padding(
                      padding:
                          const EdgeInsetsDirectional.only(end: 13.0, start: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            icon,
                            size: 20,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),
                    ),
              icon: bubbly == false
                  ? icon != null
                      ? Icon(
                          icon,
                          size: 30,
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      : null
                  : null,
              enabledBorder: bubbly == false
                  ? UnderlineInputBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                        width: 2,
                      ),
                    )
                  : null,
              hoverColor: bubbly == false
                  ? Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withAlpha(90)
                  : null,
              focusedBorder: bubbly == false
                  ? UnderlineInputBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5.0)),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2,
                      ),
                    )
                  : null,
              border: bubbly == false
                  ? null
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
