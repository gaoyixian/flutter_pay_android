import 'package:events_widget/events_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pay_android/flutter_pay.dart';
import 'package:flutter_pay_android/withdrawal_details.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'android_widgets.dart';
import 'box_backgrond.dart';
import 'color.dart';
import 'common_button.dart';
import 'withdrawal_interface.dart';
import 'z_bind.dart';
import 'z_check.dart';

class Withdrawal extends StatefulWidget {
  const Withdrawal({Key? key}) : super(key: key);

  @override
  State<Withdrawal> createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {
  bool isClick = false;
  //获取支付宝绑定信息
  _getAliMsg() async {
    if (isClick) return;
    isClick = true;
    if (FlutterPayAndroid.withDrawalMgr.selectAmount == 0) {
      FlutterPayAndroid.withDrawalMgr.showToast('请选择提现金额');
      return;
    }
    if (!FlutterPayAndroid.withDrawalMgr.userHasrealName) {
      FlutterPayAndroid.withDrawalMgr.toUserCertification(context);
      FlutterPayAndroid.withDrawalMgr.showToast('实名认证后方可提现');
      isClick = false;
      return;
    }
    await FlutterPayAndroid.withDrawalMgr
        .getAli(FlutterPayAndroid.withDrawalMgr.userId);
    isClick = false;
    if (FlutterPayAndroid.withDrawalMgr.aliAccount == '') {
      _toBind();
    } else {
      _toSumbit();
    }
  }

  //绑定支付宝
  _toBind() {
    showBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const ZBind();
        });
  }

  //确认提现
  _toSumbit() {
    showBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const ZCheck();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 44.w,
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            GestureDetector(
              onTap: () {
                FlutterPayAndroid.withDrawalMgr
                    .navigatorPushTo(context, const Withdrawaldetails());
              },
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 28.w),
                    child: GestureDetector(
                      child: FlutterPayAndroid.localizationText(
                        '明细',
                        style: TextStyle(
                            height: 1, color: color1A1A1A, fontSize: 12.sp),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
          title: FlutterPayAndroid.localizationText(
            '收益提现',
            style: TextStyle(
                color: color1A1A1A,
                fontSize: 15.sp,
                height: 1,
                fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          leadingWidth: 40.w,
          leading: GestureDetector(
            child: Container(
              child: returnBackBlackBtn(),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              padding: EdgeInsets.only(bottom: 100.w),
              children: [
                BoxBackground(box: _currentCash()),
                SizedBox(height: 8.w),
                _content()
              ],
            ),
            Positioned(
              bottom: 0,
              child: _submit(),
            ),
          ],
        ));
  }

  //提现金额
  Widget _content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //活动提现
        FlutterPayAndroid.withDrawalMgr.withdrawalActivityList.isEmpty
            ? Container()
            : _titleItem('活动提现'),
        //新用户
        FlutterPayAndroid.withDrawalMgr.withdrawalActivityList.isEmpty
            ? Container()
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: cashItem(
                    FlutterPayAndroid.withDrawalMgr.withdrawalActivityList[0]),
              ),
        SizedBox(height: 8.w),
        //日常提现
        _titleItem('日常提现'),
        //提现列表
        _daily(),
        //提现方式
        _titleItem('支付方式'),
        //支付宝绑定
        ali(),
        //日常提现
        _titleItem('提现说明'),
        _textInfo()
      ],
    );
  }

  Widget _submit() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 16.w),
      child: SafeArea(
        child: CommonButton.button('提现', _getAliMsg,
            width: 343.w,
            height: 44.w,
            radius: 8.w,
            font: 16.sp,
            textFontWeight: FontWeight.w500,
            disabled: FlutterPayAndroid.withDrawalMgr.selectAmount == 0),
      ),
    );
  }

  Widget _textInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: FlutterPayAndroid.localizationText(
        '5元、20元、50元提现申请秒到账\n\n5元、20元、50元每日仅限申请提现一次；\n\n单次提现金额100元以上（含100），为大额提现，大额提现在7个工作日之内到账，每周仅限申请提现一次；\n到账时间如遇周末和节假日则顺延到下周；账号因恶意违规封禁后，将冻结提现款项。\n\n提现功能还在完善中，若已过预计到账时间未到账，请耐心等待或截图联系客服，并确保您的账号无误，谢谢！',
        style: TextStyle(color: color666666, fontSize: 12.sp, height: 1.5),
      ),
    );
  }

  Widget ali() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: 8.w),
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            SizedBox(
                width: 20.w,
                height: 20.w,
                child:
                    Image.asset('packages/flutter_pay_android/assets/images/zicon_circular.png')),
            SizedBox(
              width: 8.w,
            ),
            FlutterPayAndroid.localizationText('支付宝绑定',
                style: TextStyle(
                    fontSize: 12.sp,
                    color: color1A1A1A,
                    fontWeight: FontWeight.w500,
                    height: 1)),
          ],
        ));
  }

  Widget _titleItem(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 20.w),
      child: FlutterPayAndroid.localizationText(
        title,
        style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: color1A1A1A,
            height: 1),
      ),
    );
  }

  //todo 每日申请访问限制
  Widget cashItem(IWithDrawalModel e) {
    return GestureDetector(
      onTap: () {
        FlutterPayAndroid.withDrawalMgr.selectAmount = e.id;
        setState(() {});
      },
      child: ClipRRect(
        borderRadius: BorderRadius.only(topRight: Radius.circular(4.r)),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
                width: 109.w,
                height: 61.w,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    border: FlutterPayAndroid.withDrawalMgr.selectAmount == e.id
                        ? Border.all(width: 1.w, color: colorE5454D)
                        : const Border(),
                    color: colorF7F7F7),
                child: Container(
                  alignment: Alignment.center,
                  child: FlutterPayAndroid.localizationText(
                    '¥${e.amount}',
                    style: TextStyle(
                        color: color1A1A1A,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        height: 1),
                  ),
                )),
            Visibility(
              visible: e.auto == 1,
              child: SizedBox(
                width: 35.w,
                child: Image.asset(e.activeType == 1
                    ? 'packages/flutter_pay_android/assets/images/xinyonghu.png'
                    : 'packages/flutter_pay_android/assets/images/miaodaozhang.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _daily() {
    return GridView.count(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 8.w,
      crossAxisSpacing: 12.w,
      childAspectRatio: 97.w / 50.w,
      children: FlutterPayAndroid.withDrawalMgr.withdrawalDailyList.map((e) {
        return cashItem(e);
      }).toList(),
    );
  }

  Widget _currentCash() {
    return EventsWidget(
      data: FlutterPayAndroid.withDrawalMgr,
      eventTypes: const [IWithDrawalMgr.updateListUserCash],
      builder: (context) {
        return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 4.w),
                  child: FlutterPayAndroid.localizationText(
                    '可兑换金额 (元)',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: colorFFFFFF),
                  ),
                ),
                SizedBox(
                  height: 12.w,
                ),
                FlutterPayAndroid.localizationText(
                  '${FlutterPayAndroid.withDrawalMgr.userCash}',
                  style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w600,
                      color: colorFFFFFF),
                ),
              ],
            ));
      },
    );
  }
}
