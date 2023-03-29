// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pay_interface/flutter_pay_interface.dart';

import 'android_widgets.dart';
import 'vip_pay_bottom.dart';
import 'withdrawal.dart';
import 'withdrawal_details.dart';

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

class FlutterPayAndroid extends FlutterPayPlatform {
  static const MethodChannel _channel = MethodChannel('flutter_pay');

  /// Registers this class as the default instance of [PathProviderPlatform].
  static void registerWith() {
    print("@@@@@@@@@@@@@@@ FlutterPayPlatform.instance = FlutterPayAndroid()");
    FlutterPayPlatform.instance = FlutterPayAndroid();
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static late IWithDrawalMgr withDrawalMgr;
  static late ShowBottomSheet showBottomSheet;

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
  Future<void> restorePurchases() async {}

  @override
  Future<void> logout() async {}

  @override
  getLxbysm() {
    return getLxbysm();
  }

  @override
  Widget getPlayButton(BuildContext context, double rate, int chooseIndex,
      void Function(int index, int typ) toPay) {
    return AndroidPlayButton(
        rate: rate,
        toPayFunc: (typ) {
          toPay(chooseIndex + 3, typ);
        });
  }

  @override
  void paymethodBottom(BuildContext context,
      {required int id,
      required int gold,
      required int rmb,
      required void Function(int p1, int p2) toPay}) {
    // Navigator.of(context).pop();
    FlutterPayAndroid.showBottomSheet(
        context: context,
        container: RechargePopup(id: id, gold: gold, rmb: rmb, toPay: toPay));
  }

  @override
  void vipPayBottom(BuildContext context,
      {required int index, required void Function(bool isShow) onchange}) {
    FlutterPayAndroid.showBottomSheet(
        context: context,
        container: VipPayBottom(
          index: index,
          onchange: onchange,
        ));
  }

  @override
  int getTyp(bool isAli) {
    return isAli ? payTypeAlipay : payTypeWechat;
  }

  @override
  String getPname(bool isAli) {
    return isAli ? '支付宝支付' : '微信支付';
  }

  @override
  Future<void> init(
      {required VerifyReceipt verifyReceipt,
      required LocalizationText localizationText,
      required void Function() onError,
      required ShowBottomSheet showBottomSheet,
      required IWithDrawalMgr withDrawalMgr}) async {
    FlutterPayAndroid.localizationText = localizationText;
    FlutterPayAndroid.showBottomSheet = showBottomSheet;
    FlutterPayAndroid.withDrawalMgr = withDrawalMgr;
    withDrawalMgr.setMakeEarningsFunc(() => const Earnings());
    withDrawalMgr.setMakeCashFunc(() => const Withdrawal());
    withDrawalMgr.setMakeCashDetailsFunc(() => const Withdrawaldetails());
    withDrawalMgr.setPageDef(Withdrawal, Withdrawaldetails, Earnings);
  }
}
