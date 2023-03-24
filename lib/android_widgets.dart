import 'package:flutter/material.dart';
import 'package:flutter_pay_android/flutter_pay.dart';
import 'package:flutter_pay_interface/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'choose_pay.dart';

Widget returnBackBlackBtn({double? left}) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(left: left ?? 16.w),
    color: Colors.transparent,
    child: Image.asset(
      'packages/flutter_pay_android/assets/images/return_black.png',
      width: 20.w,
      height: 20.w,
      fit: BoxFit.cover,
    ),
  );
}

Widget _title(
  String text,
) {
  return Row(
    children: [
      Container(
        width: 4.w,
        height: 15.w,
        color: hexColor(0xE5454D),
      ),
      SizedBox(
        width: 8.w,
      ),
      FlutterPayAndroid.localizationText(
        text,
        style: TextStyle(
            color: hexColor(0x000000),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500),
      )
    ],
  );
}

Widget _content(String text) {
  return FlutterPayAndroid.localizationText(
    text,
    style: TextStyle(
        color: hexColor(0x000000),
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 1.7),
  );
}

Widget getLxbysm() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _title('支付宝自动续费服务声明'),
      Container(
        padding: EdgeInsets.only(left: 12.w, top: 7.w, bottom: 20.w),
        child: _content(
            '用支付宝订购连续包月/连续包季/连续包年，用户可随时在支付宝设置-支付设置-免密支付/自动扣款中选择《车趣》vip功能，关闭自动续费功能，取消后不再扣费。'),
      ),
      _title('微信自动续费服务声明'),
      Container(
        padding: EdgeInsets.only(left: 12.w, top: 7.w, bottom: 20.w),
        child: _content(
            '用微信订购连续包月/连续包季/连续包年，用户可随时在微信服务-钱包-支付设置-自动续费中选择《车趣》vip功能，关闭自动续费功能，取消后不再扣费。'),
      )
    ],
  );
}

typedef ToPayFunc = void Function(int typ);

class AndroidPlayButton extends StatefulWidget {
  final double rate;
  final ToPayFunc toPayFunc;
  const AndroidPlayButton({
    Key? key,
    required this.rate,
    required this.toPayFunc,
  }) : super(key: key);

  @override
  State<AndroidPlayButton> createState() => _AndroidPlayButtonState();
}

class _AndroidPlayButtonState extends State<AndroidPlayButton> {
  bool isAli = true;
  @override
  Widget build(BuildContext context) {
    var rate = widget.rate;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            widget.toPayFunc(isAli ? payTypeAlipay : payTypeWechat);
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  !isAli
                      ? 'packages/flutter_pay_android/assets/images/wcicon.png'
                      : 'packages/flutter_pay_android/assets/images/zicon.png',
                  width: 20 * rate,
                  height: 20 * rate,
                ),
                SizedBox(width: 8 * rate),
                FlutterPayAndroid.localizationText(
                  isAli ? '支付宝支付' : '微信支付',
                  style: TextStyle(
                      color: hexColor(0xFFFFFF),
                      fontSize: 14.sp,
                      height: 1.1,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 12 * rate,
                ),
                Container(
                  width: 0.5 * rate,
                  color: hexColor(0xFFFFFF),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
                barrierDismissible: true,
                context: context,
                useSafeArea: false,
                useRootNavigator: false,
                builder: (BuildContext context) {
                  return ChoosePay(
                    onchange: (isShow) {
                      isAli = isShow;
                      Navigator.pop(context);
                      setState(() {});
                    },
                  );
                });
          },
          child: Container(
            padding: EdgeInsets.only(
                top: 10 * rate, bottom: 10 * rate, left: 16 * rate),
            color: Colors.transparent,
            child: Image.asset(
              'packages/flutter_pay_android/assets/images/drop_down_vip.png',
              width: 16 * rate,
              height: 16 * rate,
            ),
          ),
        )
      ],
    );
  }
}

typedef ToPayFunc2 = void Function(int id, int index);

class RechargePopup extends StatefulWidget {
  final int id;
  final int gold;
  final int rmb;
  final ToPayFunc2 toPay;

  const RechargePopup(
      {Key? key,
      required this.id,
      required this.gold,
      required this.rmb,
      required this.toPay})
      : super(key: key);

  @override
  State<RechargePopup> createState() => _RechargePopupState();
}

class Pay {
  int index;
  String url;
  String name;
  Pay({required this.index, required this.url, required this.name});
}

class _RechargePopupState extends State<RechargePopup> {
  List<Pay> paymethod = [
    Pay(
        index: payTypeAlipay,
        url: 'packages/flutter_pay_android/assets/images/zicon_circular.png',
        name: '支付宝支付'),
    Pay(
        index: payTypeWechat,
        url: 'packages/flutter_pay_android/assets/images/wechat_icon.png',
        name: '微信支付'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _rechargeitem(widget.gold, widget.rmb),
            SizedBox(height: 25.w),
            _payList(),
            SizedBox(height: 45.w)
          ],
        ),
      ),
    );
  }

  Widget _payList() {
    return Column(
      children: paymethod.map((e) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
            widget.toPay(widget.id, e.index);
          },
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            child: Row(
              children: _rechargeColumnList(e),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _rechargeColumnList(e) {
    List<Widget> list = [];
    list.add(
      Container(
        padding: EdgeInsets.symmetric(vertical: 14.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(right: 8.w),
              child: Image.asset(
                e.url,
                width: 24.w,
                height: 24.w,
                // package: "flutter_pay_android",
              ),
            ),
            FlutterPayAndroid.localizationText(
              e.name,
              style: TextStyle(
                  fontSize: 14.sp,
                  color: color1A1A1A,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
    list.add(
      const Expanded(child: SizedBox()),
    );
    list.add(Image.asset(
      'packages/flutter_pay_android/assets/images/next_setting.png',
      width: 20.w,
      height: 20.w,
      fit: BoxFit.cover,
    ));
    return list;
  }

  _rechargeitem(int gold, int rmb) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.w, bottom: 28.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16.w,
                height: 16.w,
                child: Image.asset('packages/flutter_pay_android/assets/images/car_currency.png'),
              ),
              SizedBox(width: 4.w),
              FlutterPayAndroid.localizationText(
                '$gold',
                style: TextStyle(
                  color: color1A1A1A,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              )
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 3.w),
              child: FlutterPayAndroid.localizationText(
                '￥',
                style: TextStyle(
                  color: color1A1A1A,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ),
            FlutterPayAndroid.localizationText(
              '$rmb',
              style: TextStyle(
                  color: color1A1A1A,
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w600,
                  height: 1),
            )
          ],
        ),
      ],
    );
  }
}

class Earnings extends StatefulWidget {
  const Earnings({Key? key}) : super(key: key);

  @override
  EarningsState createState() => EarningsState();
}

class EarningsState extends State<Earnings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 44.w,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
        title: FlutterPayAndroid.localizationText(
          '收益说明',
          style:
              const TextStyle(fontSize: 15, color: Color.fromRGBO(0, 0, 0, 1)),
        ),
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
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            FlutterPayAndroid.localizationText(
                '厦门车伴科技有限公司（简称“我们”）为旗下平台（即车趣APP）的有权开发商和运营商。平台社区增值业务由我们运营，用户（也称“您”）使用本平台奖励获取、兑换、提现等相关功能，即表明您作为有完全民事行为能力人，且已详细阅读本说明，知晓此说明的内容、作用方式和生效形式，并遵守和履行本说明。本说明对您和厦门车伴科技有限公司均具有法律约束力。'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '在您使用平台服务获取和提取收益（包括：互动收益、通话收益、部分直播收益）前，您应当阅读并遵守本说明及将来公示的新增的单项说明或规则、操作时的提示以及规则。'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '我们在此特别提醒您认真阅读并充分理解本说明，特别是免除或限制我们责任、限制您的权利、规定争议解决方式的相关条款。除非您接受本说明，否则您无权使用相关功能。您一经使用奖励获取、收益兑换和提现等相关功能，即视为您已理解并接受本说明。'),
            FlutterPayAndroid.localizationText(''),
            _title(
                '我们保留根据相关法律规定、主管部门要求、业务开展情况等，对奖励的领取、兑换、提现规则进行变更、调整、中止或终止的权利，同时也会将变更、调整予以公示并自公示之日起生效。'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(''),
            _title('1、如何获得奖励？'),
            FlutterPayAndroid.localizationText(''),
            _title('A.付费消息：'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '用户在以下情况将有机会获得付费方付费消息车币价值的固定比例作为奖励：'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '（1）系统匹配的会话，男用户为付费方。系统匹配的会话包括：系统匹配的搭讪/消息（如红娘牵线）/消息红包等。'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '（2）除系统匹配的会话及平台另有规定外，首发消息的一方为双方会话关系中的付费方。属于男用户的首发消息包含：卡片搭讪/一键搭讪/搭讪/私信，以及视频和语音通话（包括男用户使用视频速配、语音速配等场景）；属于女用户的首发消息包含：私信。'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '（3）若一方在会话关系中已经被认定为付费方，则系统匹配到同一会话关系时，该方仍为付费方。'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '（4）但在12小时内未回复付费消息，则将无法获得相应的奖励。'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '在平台允许的范围内，付费消息价格可由用户根据自身魅力值等级自行设定和调整。聊天卡等道具可根据其车币价值抵扣付费消息的部分价格。'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '当用户收到其他用户的付费消息（即陌生用户搭讪、消息红包等）时，会获得该部分付费消息车币价值的34%作为奖励（具体奖励以平台显示为准）。未进行真人认证的用户，付费消息可以获得的奖励为17%。我们鼓励您进行真人认证交友。'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(''),
            _title('B.礼物：'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '当用户收到收益礼物时，将会获得该礼物车币价值的34%作为奖励；公会用户提成比例以其与所在公会的约定比例为准。用户背包中尚未送出的礼物不能用于提取收益。'),
            FlutterPayAndroid.localizationText(''),
            _title('C.奖金：'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '在满足平台活动规则时，用户可能会获得一定奖金收益，如邀请奖金、额外分成奖金等等，具体以平台规则及展示为准。'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(''),
            _title('2、奖励如何领取？'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '领取奖励前，需要进行实名认证，通过认证后，绑定支付宝、微信账号方可提现。'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '为了不影响您的领取，请提前完成实名认证（“我”页面 - “我的认证”处进行认证）'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(''),
            _title('3、什么情况下会领取失败？'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText('用户的支付宝、微信账号没有做实名认证，或被限额；'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText('支付宝、微信账户和实名不一致；'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText('用户的账号存在异常；'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText('支付宝、微信技术故障；'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText('平台技术故障；'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '用户被其他用户举报、受到平台调查或监管部门有特定要求等存在未解决争议事项；'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '同一用户利用多个经过实名认证的账号使用并领取收益并提现的行为。该同一用户的判定标准包括但不限于在同一设备上登录多个账号及利用同一人图像真人认证多个账号等。'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(''),
            _title('4、领取失败后，该笔奖励会到哪里？'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText('领取失败会导致该笔奖励冻结，如有疑问，请联系客服。'),
            FlutterPayAndroid.localizationText(''),
            _title('5、其他费用'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '用户对其收益应依法纳税，其平台收益相关的纳税申报、税费及相关责任义务等由用户与其合作方（公会、灵活用工平台等）约定，与平台方无关。'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(''),
            _title('6、其他声明'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '用户理解并同意，奖励规则具体以平台显示为准。若由于平台系统突发故障、第三方软件服务商故障、黑客攻击等导致平台显示和功能故障，平台将在发现后尽快修复，平台无需因此承担赔偿责任。'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '用户应按照要求提供包括但不限于姓名、推广用名、QQ号、手机号码、联系地址、联系邮箱、指定收款银行账户信息（户名、开户行及卡号）、手持身份证正面照、身份证正反面扫描件等平台需求的全部信息。用户因自身的原因导致无法领取奖励，或领取奖励时发生任何错误而产生的任何损失或责任，厦门车伴科技有限公司不承担责任，包括但不限于：'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText('（1）因用户的平台账户失效、丢失、被封号；'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText('（2）因用户绑定的支付宝、微信账户的原因导致的损失或责任；'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '（3）同一用户利用多个经过实名认证的账号使用并领取收益并提现的行为。该同一用户的判定标准包括但不限于在同一设备上登录多个账号及利用同一人图像真人认证多个账号等；'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '领取过程中涉及由第三方提供相关服务的责任由该第三方承担，厦门车伴科技有限公司不承担该等责任，包括但不限于：'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '（1）支付宝、微信未按照用户或平台指令进行操作引起的任何损失或责任；'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '（2）因支付宝、微信原因导致资金未能及时到账或未能导致引起的任何损失或责任；'),
            FlutterPayAndroid.localizationText(''),
            FlutterPayAndroid.localizationText(
                '（3）支付宝、微信交易限额或次数等方面的限制而引起的任何损失或责任。'),
            FlutterPayAndroid.localizationText(''),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) {
    return FlutterPayAndroid.localizationText(
      text,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
    );
  }
}
