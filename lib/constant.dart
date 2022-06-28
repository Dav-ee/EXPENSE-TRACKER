import 'package:flutter/material.dart';

const kBackgroundColor = Color(0XFFF3F4F6);
const kGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomLeft,
  colors: [
    Color(0xffda1cb6),
    Color(0xffda3e3e),
    Color(0xffdea9de),
    Color(0xffe5bdbd),
    Color(0xffF6917B),
    Color(0xffefef15),
  ],
  stops: [0.01, 0.2, 0.4, 0.5, 0.6, 0.8],
);

const kActiveTextStyle = TextStyle(
  color: Colors.deepOrangeAccent,
  fontSize: 25.0,
  fontWeight: FontWeight.w600,
);
const kInactiveTextStyle = TextStyle(
  color: Colors.grey,
  fontSize: 16.0,
);
