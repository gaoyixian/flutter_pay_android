import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_pay_interface/flutter_pay_interface.dart';

/// 支付类型
const payTypeAlipay = 1;
const payTypeWechat = 2;
const payTypeIos = 3;
const payTypeBankcard = 4;

class FlutterPayAndroid implements FlutterPayInterface {
  static const MethodChannel _channel = MethodChannel('flutter_pay');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

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

  @override
  Future<void> init(
      Future<bool> Function(String?, String, String) verifyReceipt) async {}

  @override
  Future<void> restorePurchases() async {}

  @override
  Future<void> logout() async {}
}
