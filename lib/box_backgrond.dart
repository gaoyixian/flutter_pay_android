import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color.dart';

class BoxBackground extends StatelessWidget {
  final Widget box;
  const BoxBackground({ Key? key,required this.box}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child:Container(
      width: 343.w,
      height: 170.w,
      margin: EdgeInsets.only(top: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        gradient: LinearGradient(
          colors: [hexColor(0xE23FA1),hexColor(0xE85555)]
        )
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Image.asset('packages/flutter_pay_android/assets/images/mypage_new/background_element.png'),
          box
        ],
      ),
    )
    );
  }
}