// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_pay_android/withdrawal_interface.dart';
import 'package:flutter_pay_interface/flutter_pay_interface.dart';

/// 支付类型
const payTypeAlipay = 1;
const payTypeWechat = 2;
const payTypeIos = 3;
const payTypeBankcard = 4;

//提现账户类型
const int DEFAULT = 0;
const int ALIP = 1;
const int WECHAT = 2;
const int BANDCARD = 3;

class FlutterPayAndroid implements FlutterPayInterface {
  
  static const MethodChannel _channel = MethodChannel('flutter_pay');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static late IWithDrawalMgr withDrawalMgr;

  /// 微信
  static Future<bool> wechatPay(String appId, String partnerId, String prepayId,
      String nonceStr, String timeStamp, String sign) async {
    var result = await _channel.invokeMethod('wechatPay', <String, dynamic>{
      'appId': appId,
      'partnerId': partnerId,
      'prepayId': prepayId,
      'nonceStr': nonceStr,
      'timeStamp': timeStamp,
      'sign': sign,
    });
    return result == 'true';
  }

  /// 支付宝
  static Future<bool> aliPay(String orderInfo) async {
    var result = await _channel.invokeMethod('aliPay', <String, dynamic>{
      'orderInfo': orderInfo,
    });
    return result == 'true';
  }

  @override
  Future<void> pay(dynamic rsp, int time) async {
    if (getObjectKeyValueByPath(rsp, 'data.pay_type') == payTypeWechat) {
      await wechatPay(
        getObjectKeyValueByPath(rsp, 'data.appId'),
        getObjectKeyValueByPath(rsp, 'data.partnerId'),
        getObjectKeyValueByPath(rsp, 'data.prepayId'),
        getObjectKeyValueByPath(rsp, 'data.nonceStr'),
        getObjectKeyValueByPath(rsp, 'data.timeStamp'),
        getObjectKeyValueByPath(rsp, 'data.sign'),
      );
    } else if (getObjectKeyValueByPath(rsp, 'data.pay_type') == payTypeAlipay) {
      await aliPay(getObjectKeyValueByPath(rsp, 'data.info'));
    }
  }

  static late LocalizationText localizationText;

  @override
  Future<void> init(
      {required VerifyReceipt verifyReceipt,
      required LocalizationText localizationText,
      required void Function() onError}) async {
    FlutterPayAndroid.localizationText = localizationText;
  }

  @override
  Future<void> restorePurchases() async {}

  @override
  Future<void> logout() async {}
}

// /*底部弹出框*/
// Future<T?> showBottomSheet<T>({
//   required BuildContext context,
//   required Widget container,
//   bool? isDismissible,
//   enableDrag = true,
//   Color? colors,
//   RouteSettings? setting,
// }) {
//   return showModalBottomSheet<T>(
//     context: context,
//     backgroundColor: Colors.transparent,
//     barrierColor: colors ?? Colors.black.withAlpha(80),
//     isScrollControlled: true,
//     isDismissible: isDismissible ?? true,
//     enableDrag: enableDrag,
//     routeSettings: setting,
//     builder: (context) {
//       return container;
//     },
//   );
// }
