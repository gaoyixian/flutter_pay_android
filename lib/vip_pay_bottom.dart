import 'package:flutter/material.dart';
import 'package:flutter_pay_interface/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'flutter_pay.dart';

class VipPayBottom extends StatefulWidget {
  const VipPayBottom({Key? key, this.onchange, required this.index})
      : super(key: key);
  final Function(bool isShow)? onchange;
  final int index;

  @override
  State<VipPayBottom> createState() => _VipPayBottomState();
}

class _VipPayBottomState extends State<VipPayBottom> {
  int isSelect = 0;

  @override
  void initState() {
    super.initState();
    isSelect = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r))),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 20.w,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32.w,
            height: 4.w,
            margin: EdgeInsets.symmetric(vertical: 12.w),
            decoration: BoxDecoration(
              color: colorF2F2F2,
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          _item('packages/flutter_pay_android/assets/images/zicon.png', '支付宝支付',
              true, payTypeAlipay),
          _item('packages/flutter_pay_android/assets/images/wcicon.png', '微信支付',
              false, payTypeWechat),
        ],
      ),
    );
  }

  Widget _item(String url, String title, bool isAlipay, int index) {
    return GestureDetector(
      onTap: () {
        isSelect = index;
        widget.onchange!(isAlipay);
        if (mounted) setState(() {});
      },
      child: Container(
        padding:
            EdgeInsets.only(bottom: 12.w, top: 11.w, left: 16.w, right: 16.w),
        color: Colors.transparent,
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
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'HarmonyOS_Sans_Regular',
                  // leadingDistribution: TextLeadingDistribution.even,
                  color: color1A1A1A,
                  height: 1,
                  decoration: TextDecoration.none,
                )),
            Expanded(child: Container()),
            Image.asset(
              isSelect == index
                  ? 'assets/images/users/circle.png'
                  : 'assets/images/square_new/unchecked_black.png',
              width: 20.w,
              height: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
