package com.aicheban.flutter_pay;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;

import com.alipay.sdk.app.PayTask;
import com.tencent.mm.opensdk.modelpay.PayReq;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterPayPlugin */
public class FlutterPayPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private Activity mActivity;

  private IWXAPI api;
  private Context context;
  public void init(Context context)
  {
    this.context = context;
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_pay");
    channel.setMethodCallHandler(this);
    this.init(flutterPluginBinding.getApplicationContext());
  }



  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("aliPay")) {
      aliPay(call, result);
    }
    else if (call.method.equals("wechatPay")) {
      wechatPay(call, result);
    }
    else if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private void wechatPay(@NonNull MethodCall call, @NonNull Result result){
    String appId = call.argument("appId");
    if(api==null){
      api = WXAPIFactory.createWXAPI(this.context, appId, false);
    }

    PayReq request = new PayReq();

    request.appId = appId;

    request.partnerId = call.argument("partnerId");

    request.prepayId= call.argument("prepayId");

    request.packageValue = "Sign=WXPay";

    request.nonceStr= call.argument("nonceStr");

    request.timeStamp= call.argument("timeStamp");

    request.sign= call.argument("sign");

    api.sendReq(request);
    result.success("true");
  }

  private void aliPay(@NonNull MethodCall call, @NonNull Result result){
    Activity mActivity = this.mActivity;
    String orderInfo = call.argument("orderInfo");

    final Runnable payRunnable = new Runnable() {

      @Override
      public void run() {
        PayTask alipay = new PayTask(mActivity);
        Map<String, String> result = alipay.payV2(orderInfo, true);
        Log.i("msp", result.toString());

        Message msg = new Message();
        msg.what = SDK_PAY_FLAG;
        msg.obj = result;
        mHandler.sendMessage(msg);
      }
    };

    // 必须异步调用
    Thread payThread = new Thread(payRunnable);
    payThread.start();
  }
  private static final int SDK_PAY_FLAG = 1;
  private static final int SDK_AUTH_FLAG = 2;

  @SuppressLint("HandlerLeak")
  private Handler mHandler = new Handler() {
    @SuppressWarnings("unused")
    public void handleMessage(Message msg) {
      switch (msg.what) {
        case SDK_PAY_FLAG: {
          @SuppressWarnings("unchecked")
          PayResult payResult = new PayResult((Map<String, String>) msg.obj);
          /**
           * 对于支付结果，请商户依赖服务端的异步通知结果。同步通知结果，仅作为支付结束的通知。
           */
          String resultInfo = payResult.getResult();// 同步返回需要验证的信息
          String resultStatus = payResult.getResultStatus();
          // 判断resultStatus 为9000则代表支付成功
          if (TextUtils.equals(resultStatus, "9000")) {
            // 该笔订单是否真实支付成功，需要依赖服务端的异步通知。
//            showAlert(PayDemoActivity.this, getString(R.string.pay_success) + payResult);
          } else {
            // 该笔订单真实的支付结果，需要依赖服务端的异步通知。
//            showAlert(PayDemoActivity.this, getString(R.string.pay_failed) + payResult);
          }
          break;
        }
//        case SDK_AUTH_FLAG: {
//          @SuppressWarnings("unchecked")
//          AuthResult authResult = new AuthResult((Map<String, String>) msg.obj, true);
//          String resultStatus = authResult.getResultStatus();
//
//          // 判断resultStatus 为“9000”且result_code
//          // 为“200”则代表授权成功，具体状态码代表含义可参考授权接口文档
//          if (TextUtils.equals(resultStatus, "9000") && TextUtils.equals(authResult.getResultCode(), "200")) {
//            // 获取alipay_open_id，调支付时作为参数extern_token 的value
//            // 传入，则支付账户为该授权账户
//            showAlert(PayDemoActivity.this, getString(R.string.auth_success) + authResult);
//          } else {
//            // 其他状态值则为授权失败
//            showAlert(PayDemoActivity.this, getString(R.string.auth_failed) + authResult);
//          }
//          break;
//        }
        default:
          break;
      }
    };
  };

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this. mActivity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}
