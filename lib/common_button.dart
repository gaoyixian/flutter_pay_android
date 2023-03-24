import 'package:flutter/material.dart';
import 'package:flutter_pay_android/flutter_pay.dart';
import 'package:flutter_pay_interface/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:universal_platform/universal_platform.dart';


class CommonButton {
  //渐变按钮
  static Widget longButton(String text, VoidCallback onTaps,
      {bool disabled = false,
      double? width,
      double? height,
      double? font,
      double? radius,
      String? iconUrl,
      double? iconSize,
      Color? disabledColor,
      Color? disabledTextColor,
      Color? textColor,
      BoxBorder? border,
      FontWeight? fontWeight,
      VoidCallback? cancelTaps}) {
    return GestureDetector(
      onTap: disabled ? cancelTaps ?? () {} : onTaps,
      child: Container(
        alignment: Alignment.center,
        width: width ?? 307.w,
        height: height ?? 44.w,
        decoration: disabled
            ? BoxDecoration(
                border: border ?? const Border(),
                borderRadius: BorderRadius.circular(radius ?? 8.r),
                color: disabledColor ?? colorF2F2F2)
            : BoxDecoration(
                borderRadius: BorderRadius.circular(radius ?? 8.r),
                gradient: const LinearGradient(
                  colors: [Color(0xffE5454D), Color(0xffE5454D)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconUrl == null
                ? Container()
                : Image.asset(iconUrl, width: iconSize ?? 12.w),
            SizedBox(width: iconUrl == null ? 0 : 4.w),
            FlutterPayAndroid.localizationText(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: font ?? 16.sp,
                  color: disabled
                      ? (disabledTextColor ?? color999999)
                      : (textColor ?? colorFFFFFF),
                  fontWeight: fontWeight ?? FontWeight.w400,
                  decoration: TextDecoration.none,
                ))
          ],
        ),
      ),
    );
  }

  static Widget button(String text, VoidCallback onTaps,
      {bool disabled = false,
      double? width,
      double? height,
      double? font,
      double? radius,
      String? iconUrl,
      double? iconSize,
      Color? disabledColor,
      Color? disabledTextColor,
      Color? textColor,
      Color? buttonColor,
      BoxBorder? border,
      FontWeight? textFontWeight,
      VoidCallback? cancelTaps}) {
    return GestureDetector(
      onTap: disabled ? cancelTaps ?? () {} : onTaps,
      child: Container(
        alignment: Alignment.center,
        width: width ?? 215.w,
        height: height ?? 44.w,
        decoration: disabled
            ? BoxDecoration(
                border: border ?? const Border(),
                borderRadius: BorderRadius.circular(radius ?? 97.r),
                color: disabledColor ?? colorF2F2F2)
            : BoxDecoration(
                borderRadius: BorderRadius.circular(radius ?? 97.r),
                color: buttonColor ?? colorE5454D),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconUrl == null
                ? Container()
                : Image.asset(iconUrl, width: iconSize ?? 12.w),
            SizedBox(width: iconUrl == null ? 0 : 4.w),
            FlutterPayAndroid.localizationText(text,
                style: TextStyle(
                    fontSize: font ?? 16.sp,
                    color: disabled
                        ? (disabledTextColor ?? color999999)
                        : (textColor ?? colorFFFFFF),
                    fontWeight: textFontWeight ?? FontWeight.w400,
                    fontFamily:
                        UniversalPlatform.isAndroid ? 'Roboto' : 'PingFang SC',
                    decoration: TextDecoration.none))
          ],
        ),
      ),
    );
  }

  //普通按钮
  static Widget commonButton(
    VoidCallback onPress,
    VoidCallback onCancelPress,
    String text, {
    double? width,
    double? height,
    Color? bgColor,
    double? radius,
    bool enable = true,
    double? fontSize,
    Color? textColor,
    FontWeight? fontWeight,
  }) {
    return GestureDetector(
        onTap: enable ? onPress : onCancelPress,
        child: Container(
          alignment: Alignment.center,
          width: width ?? 149.w,
          height: height ?? 44.w,
          decoration: BoxDecoration(
              color: enable ? bgColor ?? hexColor(0xE5F9FF) : colorB3B3B3,
              borderRadius: BorderRadius.circular(radius ?? 8.r)),
          child: FlutterPayAndroid.localizationText(text,
              style: TextStyle(
                  fontSize: fontSize ?? 14.sp,
                  color: textColor ?? colorFFFFFF,
                  fontWeight: fontWeight ?? FontWeight.w500)),
        ));
  }

  static Widget iconbutton(String text, VoidCallback onTaps,
      {bool disabled = false,
      double? width,
      double? height,
      double? font,
      double? radius,
      String? iconUrl,
      double? iconSize,
      Color? color,
      Color? disabledColor,
      Color? disabledTextColor,
      Color? textColor,
      BoxBorder? border,
      VoidCallback? cancelTaps}) {
    return GestureDetector(
      onTap: disabled ? cancelTaps ?? () {} : onTaps,
      child: Container(
        alignment: Alignment.center,
        width: width ?? 215.w,
        height: height ?? 44.w,
        decoration: disabled
            ? BoxDecoration(
                border: border ?? const Border(),
                borderRadius: BorderRadius.circular(radius ?? 97.r),
                color: color)
            : BoxDecoration(
                borderRadius: BorderRadius.circular(radius ?? 97.r),
                color: color),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconUrl == null
                ? Container()
                : Image.asset(iconUrl, width: iconSize ?? 12.w),
            SizedBox(width: iconUrl == null ? 0 : 4.w),
            FlutterPayAndroid.localizationText(text,
                style: TextStyle(
                    fontSize: font ?? 16.sp,
                    color: disabled
                        ? (disabledTextColor ?? color999999)
                        : (textColor ?? colorFFFFFF),
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none))
          ],
        ),
      ),
    );
  }
}
