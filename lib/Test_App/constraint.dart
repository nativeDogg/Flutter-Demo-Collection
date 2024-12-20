import 'package:flutter/material.dart';

class ConstraintApp extends StatelessWidget {
  const ConstraintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextField(
          decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffF3F6F9),
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              hintText: "输入 0~99 数字",
              hintStyle: TextStyle(fontSize: 14)),
        ),
      ),
    );
  }
}
