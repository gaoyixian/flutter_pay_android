// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pay_interface/color.dart';
import 'package:flutter_pay_interface/flutter_pay_interface.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// 支付类型
// const payTypeAlipay = 1;
// const payTypeWechat = 2;
// const payTypeIos = 3;
// const payTypeBankcard = 4;
const payTypeGooglePlay = 7;

class FlutterPayAndroid extends FlutterPayPlatform {
  /// Registers this class as the default instance of [PathProviderPlatform].
  static void registerWith() {
    print("@@@@@@@@@@@@@@@ FlutterPayPlatform.instance = FlutterPayAndroid()");
    FlutterPayPlatform.instance = FlutterPayAndroid();
  }

  static late LocalizationText localizationText;

  static late InAppPurchase _inAppPurchase;
  static late StreamSubscription<List<PurchaseDetails>> _subscription;
  static late VerifyReceipt _verifyReceipt;
  static late void Function() _onError;
  static late ShowBottomSheet showBottomSheet;

  @override
  Future<void> init({
    required VerifyReceipt verifyReceipt,
    required LocalizationText localizationText,
    required void Function() onError,
    required ShowBottomSheet showBottomSheet,
    required IWithDrawalMgr withDrawalMgr,
    String? payConfig, //pay插件配置
  }) async {
    FlutterPayAndroid.localizationText = localizationText;
    FlutterPayAndroid.showBottomSheet = showBottomSheet;
    _verifyReceipt = verifyReceipt;
    _onError = onError;
    _inAppPurchase = InAppPurchase.instance;
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
  }

  void _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        //进行中
        print('~~~~~进行中');
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _onError();
          print('~~~~~${purchaseDetails.error!}');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _verifyReceipt(
              purchaseDetails.purchaseID,
              purchaseDetails.verificationData.serverVerificationData,
              _id.toString());
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  @override
  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  int _id = 0;
  String _orderNumber = '';
  @override
  Future<dynamic> pay(dynamic rsp, int time) async {
    _id = getObjectKeyValueByPath(rsp, 'data.id');
    _orderNumber = getObjectKeyValueByPath(rsp, 'data.order_number');
    String productId = getObjectKeyValueByPath(rsp, 'data.ios_product_id');
    Set<String> set = {};
    set.add(productId);
    ProductDetailsResponse res = await _inAppPurchase.queryProductDetails(set);
    ProductDetails? productDetail;
    for (var item in res.productDetails) {
      if (item.id == productId) {
        productDetail = item;
      }
    }
    if (productDetail != null) {
      final purchaseParam = PurchaseParam(
          productDetails: productDetail, applicationUserName: "$time");
      // _inAppPurchase.buyConsumable(
      //     purchaseParam: purchaseParam, autoConsume: true);
      if (productDetail.id == 'com.gaoyx.aimagic30') {
        _inAppPurchase.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
      } else {
        _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
    }
  }

  @override
  Future<void> logout() async {
    _subscription.cancel();
  }

  @override
  getLxbysm() {
    return Container();
  }

  @override
  void paymethodBottom(
    BuildContext context, {
    required int id,
    required int gold,
    required double price,
    String? currencyCode,
    required void Function(int p1, int p2) toPay,
  }) {
    currencyCode ??= CurrencyCode.CNY;
    toPay(id, payTypeGooglePlay);
  }

  @override
  Widget getPlayButton(BuildContext context, double rate, int chooseIndex,
      void Function(int index, int typ) toPay) {
    return GestureDetector(
      onTap: () {
        toPay(chooseIndex, payTypeGooglePlay);
      },
      child: Container(
        alignment: Alignment.center,
        width: 180 * rate,
        color: Colors.transparent,
        child: FlutterPayAndroid.localizationText('立即开通支付',
            style: TextStyle(
              color: hexColor(0xFFFFFF),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            )),
      ),
    );
  }

  @override
  void vipPayBottom(BuildContext context,
      {required int index, required void Function(bool isShow) onchange}) {
    // TODO: implement vipPayBottom
  }

  @override
  int getTyp(bool isAli) {
    return payTypeGooglePlay;
  }

  @override
  String getPname(bool isAli) {
    return 'Google Play';
  }

  @override
  String getPnameByType(int type) {
    switch(type){
      case payTypeGooglePlay:
        return 'Google Play';
    }
    return '';
  }
}
