import 'package:flutter/material.dart';
import 'package:flutter_pay_interface/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'common_button.dart';
import 'custom_text_field.dart';
import 'flutter_pay.dart';
import 'z_check.dart';

class ZBind extends StatefulWidget {
  const ZBind({Key? key}) : super(key: key);
  @override
  State<ZBind> createState() => _ZBindState();
}

class _ZBindState extends State<ZBind> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isnull = true;

  _finish() async {
    var res = await FlutterPayAndroid.withDrawalMgr.setAli(_controller.text);
    if (res) {
      if (mounted) {
        Navigator.pop(context);
        FlutterPayAndroid.showBottomSheet(
            context: context,
            container: const ZCheck(),);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _aliList(),
        ),
      ),
    );
  }

  List<Widget> _aliList() {
    List<Widget> list = [];
    list.add(
      _title(),
    );
    if (FlutterPayAndroid.withDrawalMgr.aliName != '') {
      list.add(_realName());
    }
    list.add(
      _input(),
    );
    list.add(
      _tip(),
    );
    //完成按钮
    list.add(_nextStep());
    return list;
  }

  _title() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 12.w),
          height: 4.w,
          width: 31.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            color: colorCCCCCC,
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: FlutterPayAndroid.localizationText('绑定支付宝账号',
              style: TextStyle(
                  color: color1A1A1A,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 1)),
        )
      ],
    );
  }

  Widget _realName() {
    return Container(
      padding: EdgeInsets.only(left: 16.w, top: 40.w, bottom: 22.w),
      child: FlutterPayAndroid.localizationText('实名人：${FlutterPayAndroid.withDrawalMgr.aliName}',
          style: TextStyle(
              color: hexColor(0x3A3A3A),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 1)),
    );
  }

  _input() {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      child: CustomTextField(
        controller: _controller,
        focusNode: _focusNode,
        style: TextStyle(fontSize: 14.sp, color: color1A1A1A),
        textAlignVertical: TextAlignVertical.top,
        cursorColor: color1A1A1A,
        decoration: InputDecoration(
            hintText: '请输入新的支付宝账号',
            hintStyle: TextStyle(fontSize: 14.sp, color: colorCCCCCC),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorF2F2F2, width: 0.5.w)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorF2F2F2, width: 0.5.w)),
            prefixIcon: Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Image.asset(
                'packages/flutter_pay_android/assets/images/zicon_square.png',
                width: 26.w,
              ),
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 24.w)),
        onChanged: (v) {
          if (_controller.text.isEmpty) {
            isnull = true;
          } else {
            isnull = false;
          }
          setState(() {});
        },
      ),
    );
  }

  _tip() {
    return Container(
      padding: EdgeInsets.only(left: 16.w, top: 19.w),
      child: FlutterPayAndroid.localizationText(
          '1.请填写实名认证的支付宝账号，否则无法到账\n2.请确保支付宝账号准确无误，填写错误将导致提现无法到账',
          style: TextStyle(
              color: color999999,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 20 / 12)),
    );
  }

  _nextStep() {
    return Padding(
        padding: EdgeInsets.only(top: 28.w, bottom: 45.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonButton.button('下一步', _finish,
                disabled: isnull,
                disabledTextColor: colorFFFFFF,
                disabledColor: hexColor(0xD3D3D3),
                radius: 8.r,
                width: MediaQuery.of(context).size.width - 32.w)
          ],
        ));
  }
}
