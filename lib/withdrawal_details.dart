// ignore_for_file: constant_identifier_names
import 'package:events_widget/events_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pay_android/flutter_pay.dart';
import 'package:flutter_pay_interface/color.dart';
import 'package:flutter_pay_interface/flutter_pay_interface.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'android_widgets.dart';
import 'my_separatoe.dart';

//01-01 23:00
String getCashTime(int startime) {
  String time = '';
  DateTime cdate = DateTime.fromMillisecondsSinceEpoch(startime * 1000);
  time =
      '${cdate.month.toString().padLeft(2, '0')}-${cdate.day.toString().padLeft(2, '0')} ${cdate.hour.toString().padLeft(2, '0')}:${cdate.minute.toString().padLeft(2, '0')}';
  return time;
}

//提现账户类型
const int DEFAULT = 0;
const int ALIP = 1;
const int WECHAT = 2;
const int BANDCARD = 3;

class Withdrawaldetails extends StatefulWidget {
  const Withdrawaldetails({Key? key}) : super(key: key);

  @override
  State<Withdrawaldetails> createState() => _WithdrawaldetailsState();
}

class _WithdrawaldetailsState extends State<Withdrawaldetails> {
  final RefreshController _refreshController = RefreshController();
  int pageCount = 20;

  @override
  void initState() {
    super.initState();
    _query();
  }

  _query() async {
    var res =
        await FlutterPayAndroid.withDrawalMgr.queryWithdrawList(pageCount);
    if (FlutterPayAndroid.withDrawalMgr.listLastId == null) {
      _refreshController.refreshCompleted(resetFooterState: true);
    }
    if (res == 20) {
      _refreshController.loadComplete();
    } else {
      if (FlutterPayAndroid.withDrawalMgr.withDrawList.isNotEmpty) {
        _refreshController.loadNoData();
      } else {
        _refreshController.footerMode!.value = LoadStatus.canLoading;
      }
    }
  }

  //上拉刷新
  void _onRefresh() {
    FlutterPayAndroid.withDrawalMgr.listLastId = null;
    _refreshController.refreshCompleted(resetFooterState: true);
    _query();
  }

  //下拉加载更多
  void _onLoading() {
    _query();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorF7F7F7,
        appBar: AppBar(
          toolbarHeight: 44.w,
          leadingWidth: 35,
          leading: GestureDetector(
            child: returnBackBlackBtn(),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          centerTitle: true,
          title: Container(
            margin: EdgeInsets.only(right: 15.w),
            child: FlutterPayAndroid.localizationText(
              '提现明细',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: color1A1A1A),
            ),
          ),
        ),
        body: EventsWidget(
          eventTypes: const [IWithDrawalMgr.eventUpdateWithDrawList],
          data: FlutterPayAndroid.withDrawalMgr,
          builder: (context) {
            return SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: FlutterPayAndroid.withDrawalMgr.withDrawList.isEmpty
                  ? FlutterPayAndroid.withDrawalMgr
                      .getListNodataView('暂无提现记录', _onRefresh)
                  : ListView.builder(
                      itemCount:
                          FlutterPayAndroid.withDrawalMgr.withDrawList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _item(FlutterPayAndroid
                            .withDrawalMgr.withDrawList[index]);
                      },
                    ),
            );
          },
        ));
  }

  Widget _item(IWithDrawDetail e) {
    return Container(
      margin: EdgeInsets.only(top: 20.w, left: 16.w, right: 14.w),
      padding: EdgeInsets.only(left: 0.w, top: 24.w, bottom: 24.w, right: 0.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: colorFFFFFF,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //提现到账
          arrival(e),
          SizedBox(
            height: 8.w,
          ),
          //提现金额
          amount(e),
          Container(
            margin: EdgeInsets.only(top: 63.w, left: 29.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //发起提现流程图标
                initiate(e),
                //发起提现文字
                step(e),
                //提现时间
                time(e),
              ],
            ),
          ),
          //流水号
          serialnumber(e),
        ],
      ),
    );
  }

  Widget serialnumber(IWithDrawDetail e) {
    return Container(
      margin: EdgeInsets.only(top: 16.w, left: 24.w),
      child: FlutterPayAndroid.localizationText(
        '流水号：${e.orderNumber}',
        style: TextStyle(fontSize: 14.sp, height: 1, color: color999999),
      ),
    );
  }

  Widget time(IWithDrawDetail e) {
    return Container(
      margin: EdgeInsets.only(left: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.w),
            child: FlutterPayAndroid.localizationText(
              getCashTime(e.createTime),
              style: TextStyle(fontSize: 14.sp, height: 1, color: color1A1A1A),
            ),
          ),
          SizedBox(
            height: 17.w,
          ),
          FlutterPayAndroid.localizationText(
              e.transferTime == 0 ? '' : getCashTime(e.transferTime),
              style: TextStyle(fontSize: 14.sp, height: 1, color: color1A1A1A)),
          SizedBox(
            height: 18.w,
          ),
          FlutterPayAndroid.localizationText(
              e.transferTime == 0 ? '' : getCashTime(e.transferTime),
              style: TextStyle(fontSize: 14.sp, height: 1, color: color1A1A1A)),
        ],
      ),
    );
  }

  Widget step(IWithDrawDetail e) {
    return Container(
      margin: EdgeInsets.only(left: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlutterPayAndroid.localizationText(
            '发起提现',
            style: TextStyle(
              fontSize: 14.sp,
              height: 1,
              color: color999999,
            ),
          ),
          SizedBox(
            height: 21.w,
          ),
          FlutterPayAndroid.localizationText(
            '提现中',
            style: TextStyle(fontSize: 14.sp, height: 1, color: color999999),
          ),
          SizedBox(
            height: 21.w,
          ),
          FlutterPayAndroid.localizationText(
            getStatus(e.status),
            style: TextStyle(fontSize: 14.sp, height: 1, color: color999999),
          ),
        ],
      ),
    );
  }

  getStatus(int status) {
    switch (status) {
      case 0:
        return '提现中';
      case 1:
        return '待付款';
      case 2:
        return '付款失败';
      case 3:
        return '提现成功';
      default:
    }
  }

  Widget initiate(IWithDrawDetail e) {
    return Column(
      children: [
        icon('packages/flutter_pay_android/assets/images/dot_blue.png'),
        LDashedLine(
          axis: Axis.vertical,
          dashedWidth: 1,
          dashedHeight: 2,
          count: 5,
          dashedTotalLengthWith: 25.w,
        ),
        icon(e.transferTime == 0
            ? 'packages/flutter_pay_android/assets/images/dot_prey.png'
            : 'packages/flutter_pay_android/assets/images/dot_blue.png'),
        LDashedLine(
          axis: Axis.vertical,
          dashedWidth: 1,
          dashedHeight: 2,
          count: 5,
          dashedTotalLengthWith: 25.w,
        ),
        icon(e.status == 2
            ? 'packages/flutter_pay_android/assets/images/fail_red.png'
            : (e.transferTime == 0
                ? 'packages/flutter_pay_android/assets/images/dot_prey.png'
                : 'packages/flutter_pay_android/assets/images/success_blue.png'))
      ],
    );
  }

  Widget icon(String icon) {
    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(icon),
      )),
    );
  }

  Widget amount(IWithDrawDetail e) {
    return Container(
      alignment: Alignment.center,
      child: FlutterPayAndroid.localizationText(
        e.amount.toStringAsFixed(2),
        style: TextStyle(
            fontSize: 32.sp,
            height: 1,
            fontWeight: FontWeight.w500,
            color: color1A1A1A),
      ),
    );
  }

  String checkType(int type) {
    switch (type) {
      case DEFAULT:
        return 'packages/flutter_pay_android/assets/images/zicon_circular.png';
      case ALIP:
        return 'packages/flutter_pay_android/assets/images/zicon_circular.png';
      case WECHAT:
        return 'packages/flutter_pay_android/assets/images/wechat.png';
      case BANDCARD:
        return 'packages/flutter_pay_android/assets/images/zicon_circular.png';
      default:
        return 'packages/flutter_pay_android/assets/images/zicon_circular.png';
    }
  }

  Widget arrival(IWithDrawDetail e) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(checkType(e.accountType)),
          )),
        ),
        SizedBox(
          width: 4.w,
        ),
        FlutterPayAndroid.localizationText(
          '提现到账',
          style: TextStyle(
              height: 1,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: color1A1A1A),
        )
      ],
    );
  }
}
