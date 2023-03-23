import 'package:flutter/material.dart';
import 'package:flutter_pay_android/flutter_pay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color.dart';
import 'common_button.dart';
import 'z_bind.dart';

class ZCheck extends StatefulWidget {
  const ZCheck({Key? key}) : super(key: key);

  @override
  State<ZCheck> createState() => _ZCheckState();
}

class _ZCheckState extends State<ZCheck> {
  _tomodify() {
    Navigator.pop(context);
    showBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return const ZBind();
            });
  }

  String aliName = FlutterPayAndroid.withDrawalMgr.aliName == ''
      ? ''
      : FlutterPayAndroid.withDrawalMgr.aliName
          .replaceRange(1, FlutterPayAndroid.withDrawalMgr.aliName.length - 1, '*');

  //提现
  _tofinish() async {
    await FlutterPayAndroid.withDrawalMgr.withdrawal(
        ALIP,
        FlutterPayAndroid.withDrawalMgr.selectAmount,
        FlutterPayAndroid.withDrawalMgr.aliName,
        FlutterPayAndroid.withDrawalMgr.aliAccount);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40.w,
            ),
            _userMeg(),
            SizedBox(
              height: 24.w,
            ),
            _text(),
            SizedBox(
              height: 60.w,
            ),
            _button(), //按钮
            SizedBox(
              height: 50.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _text() {
    return FlutterPayAndroid.localizationText(
      '即将提现至你的支付宝账号',
      style: TextStyle(
          color: color999999, fontSize: 14.sp, fontWeight: FontWeight.w400),
    );
  }

  Widget _button() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonButton.button('修改账号', () {},
              width: 167.w,
              height: 38.w,
              radius: 8.r,
              font: 14.sp,
              disabled: true,
              cancelTaps: _tomodify,
              disabledTextColor: colorE5454D,
              disabledColor: colorFFFFFF,
              border: Border.all(width: 1.w, color: colorE5454D)),
          CommonButton.button('确定', _tofinish,
              width: 167.w, height: 38.w, radius: 8.r, font: 14.sp)
        ],
      ),
    );
  }

  Widget _userMeg() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 52.w,
          height: 52.w,
          child: Image.asset('packages/flutter_pay_android/assets/images/mypage_new/zicon_square.png'),
        ),
        SizedBox(
          width: 12.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlutterPayAndroid.localizationText(
              aliName,
              style: TextStyle(color: color1A1A1A, fontSize: 16.sp),
            ),
            SizedBox(
              height: 6.w,
            ),
            FlutterPayAndroid.localizationText(
              FlutterPayAndroid.withDrawalMgr.aliAccount,
              style: TextStyle(color: color1A1A1A, fontSize: 16.sp),
            )
          ],
        )
      ],
    );
  }
}
