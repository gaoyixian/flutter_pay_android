import 'package:flutter/material.dart';
import 'package:flutter_pay_android/flutter_pay_android.dart';
import 'package:flutter_pay_interface/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChoosePay extends StatefulWidget {
  final Function(bool isShow)? onchange;
  const ChoosePay({Key? key, this.onchange}) : super(key: key);

  @override
  State<ChoosePay> createState() => _ChoosePayState();
}

class _ChoosePayState extends State<ChoosePay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexColor(0x000000, alpha: 0),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: hexColor(0x000000, alpha: 0.4),
          child: Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12.r))),
                  width: 274.w,
                  height: 216.w,
                  child: Column(
                    children: [
                      SizedBox(height: 32.w),
                      FlutterPayAndroid.localizationText('选择支付方式',
                          style: TextStyle(
                              color: hexColor(0x1A1A1A),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: 21.w),
                      _item('packages/flutter_pay_android/assets/images/zicon.png',
                          '支付宝支付', true),
                      _item('packages/flutter_pay_android/assets/images/wcicon.png',
                          '微信支付', false),
                    ],
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  Widget _item(String url, String title, bool isAli) {
    return GestureDetector(
      onTap: () {
        widget.onchange!(isAli);
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 16.w, top: 15.w),
        margin: EdgeInsets.only(left: 20.w, right: 20.w),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.5.w, color: hexColor(0xF2F2F2)))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              url,
              width: 24.w,
              height: 24.w,
            ),
            SizedBox(width: 12.w),
            FlutterPayAndroid.localizationText(title,
                style: TextStyle(
                    color: hexColor(0x1A1A1A),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400)),
            Expanded(child: Container()),
            Image.asset(
              'packages/flutter_pay_android/assets/images/task_arrow.png',
              width: 20.w,
              height: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
