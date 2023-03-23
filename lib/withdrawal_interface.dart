import 'package:events_widget/event_dispatcher.dart';
import 'package:flutter/material.dart';

abstract class IWithDrawalMgr with EventDispatcher {
  static const String eventUpdateWithDrawList = 'updateWithDrawList';
  static const String eventUpdateListLastId = 'updateListLastId';
  static const String updateListUserCash = 'updateListUserCash';
  int get selectAmount;
  set selectAmount(int v);
  //获取支付宝账户
  String get aliName;
  String get aliAccount;
  Future<bool> setAli(String aplipayId);
  getAli(int userId);

  dynamic get userId;
  bool get userHasrealName;
  double get userCash;
  List<IWithDrawalModel> get withdrawalActivityList; //活动提现
  List<IWithDrawalModel> get withdrawalDailyList; //日常提现
  //提现明细列表
  List<IWithDrawDetail> get withDrawList;
  
  String? get listLastId;
  set listLastId(String? v);
  Future withdrawal(
      int accountType, int id, String accountName, String account);
  Future queryWithdrawList(int pageCount);

  exchangeGold(int id);
  void toUserCertification(BuildContext context);
  void showToast(String tips);
    void navigatorPushTo(BuildContext context, Widget widget);
  Widget getListNodataView(String tips, Function? requestCallback);
}

abstract class IWithDrawalModel {
  int get id;
  double get amount;
  int get dayTime;
  int get weekTime;
  int get auto;
  int get type;
  int get totalCount;
  int get activeType;
}

abstract class IWithDrawDetail {
  // int id = 0;
  String get orderNumber; //订单号
  int get status; //订单状态 默认0 待付款1 付款失败2 已完成3
  double get amount; //提现金额
  // int userId = 0; //提现用户
  int get accountType; //提现账户类型 默认0 支付宝1 微信2 银行卡3
  // String accountName = ''; //提现账户名
  // String account = ''; //提现账户
  int get transferTime; //提现转账时间
  int get createTime; //创建时间
  // int updateTime = 0; //更新时间
  // int type = 0; //提现类型
  applyJson(Map<String, dynamic> json);
}
