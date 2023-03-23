import 'dart:math';

import 'package:flutter/material.dart';

//w文本键盘颜色
const Brightness txtBrightness = Brightness.light;

//颜色
Color colorCCCCCC = hexColor(0xCCCCCC);
Color color000000 = hexColor(0x000000);
Color color1A1A1A = hexColor(0x1A1A1A);
Color color4C84F6 = hexColor(0x4C84F6);
Color color333333 = hexColor(0x333333);
Color color666666 = hexColor(0x666666);
Color color999999 = hexColor(0x999999);
Color colorB3B3B3 = hexColor(0xB3B3B3);
Color colorE5454D = hexColor(0xE5454D);
Color colorE6E6E6 = hexColor(0xE6E6E6);
Color colorED7D82 = hexColor(0xED7D82);
Color colorF2F2F2 = hexColor(0xF2F2F2);
Color colorF6F6F9 = hexColor(0xF6F6F9);
Color colorF7F7F7 = hexColor(0xF7F7F7);
Color colorFFFFFF = hexColor(0xFFFFFF);
Color colorFFD25B = hexColor(0xFFD25B);
Color colorFFE7BA = hexColor(0xFFE7BA);
Color color73747A = hexColor(0x73747A);
Color color4C4C4C = hexColor(0x4C4C4C);
Color color1B1B1B = hexColor(0x1B1B1B);
Color colorFFF5F5 = hexColor(0xFFF5F5);
Color color232327 = hexColor(0x232327);
Color color313136 = hexColor(0x313136);
Color color2B2B2E = hexColor(0x2B2B2E);
Color color272729 = hexColor(0x272729);
Color colorF5F5F5 = hexColor(0xF5F5F5);
Color color26C895 = hexColor(0x26C895);
Color color9772F8 = hexColor(0x9772F8);
Color colorF53357 = hexColor(0xF53357);
Color color575857 = hexColor(0x575857);
Color color373737 = hexColor(0x373737);
Color colorA6A6A6 = hexColor(0xA6A6A6);
Color colorEBEBEB = hexColor(0xEBEBEB);
Color colorFFCE07 = hexColor(0xFFCE07);
Color colorAAE3FF = hexColor(0xAAE3FF);
Color color407DF7 = hexColor(0x407DF7);


/*创建MaterialColor*/
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;
  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

/*hex值获取颜色*/
Color hexColor(int hex, {double alpha = 1}) {
  if (alpha < 0) {
    alpha = 0;
  } else if (alpha > 1) {
    alpha = 1;
  }
  return Color.fromRGBO((hex & 0xFF0000) >> 16, (hex & 0x00FF00) >> 8,
      (hex & 0x0000FF) >> 0, alpha);
}

///设置颜色纯度
///
///value 0-1
Color setColorValue(Color color, double value) {
  int value255 = (value * 0xFF).toInt();
  int maxValue = max(max(color.red, color.green), color.blue);
  if (maxValue < value255) return color;
  double times = value255 / maxValue;
  return Color.fromARGB(
    color.alpha,
    (color.red * times).toInt(),
    (color.green * times).toInt(),
    (color.blue * times).toInt(),
  );
}
