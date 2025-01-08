import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/generated/l10n.dart';
import 'package:intl/intl.dart';

class I10nApp extends StatefulWidget {
  const I10nApp({super.key});

  @override
  State<I10nApp> createState() => _I10nAppState();
}

class _I10nAppState extends State<I10nApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('我是第一个:${S.of(context).title}'),
            Localizations.override(
              context: context,
              locale: const Locale('zh', 'CN'),
              child: Builder(
                builder: (context) {
                  return Text('我是第二个:${Text(S.of(context).title)}');
                },
              ),
            ),
            Divider(),
            Text('单个占位符'),
            Text(S.of(context).title2('张三')),
            Localizations.override(
              context: context,
              locale: const Locale('zh', 'CN'),
              child: Builder(
                builder: (context) {
                  return Text('我是第二个:${S.of(context).title2('张三')}');
                },
              ),
            ),
            Divider(),
            Text('多个占位符'),
            Text(S.of(context).title3('zhangsan', '13 years old')),
            Localizations.override(
              context: context,
              locale: const Locale('zh', 'CN'),
              child: Builder(
                builder: (context) {
                  return Text('我是第二个:${S.of(context).title3('张三', '13岁')}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
