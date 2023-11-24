package com.dspread.flutter_plugin_qpos;

import android.Manifest;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.LocationManager;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import android.os.Build;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import java.util.Hashtable;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.PluginRegistry;

/**
 * FlutterPluginQposPlugin
 */
public class FlutterPluginQposPlugin implements FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler,ActivityAware {

    private Context mContext;
    private MethodChannel methodChannel;
    private EventChannel eventChannel;
    private Activity mActivity;

    private static final int BLUETOOTH_CODE = 100;
    private static final int LOCATION_CODE = 101;
    public FlutterPluginQposPlugin(Activity mainActivity) {
        mActivity = mainActivity;
    }

    public FlutterPluginQposPlugin() {

    }


    /**
     * Plugin registration.
     * Deprecated
     */
//    public static void registerWith(final PluginRegistry.Registrar registrar) {
////    final FlutterPluginQposPlugin instance = new FlutterPluginQposPlugin();
////    instance.onAttachedToEngine(registrar.context(), registrar.messenger());
//    }

    @Override
    public void onAttachedToEngine(FlutterPlugin.FlutterPluginBinding binding) {
        TRACE.d("FlutterPluginPosPlugin：onAttachedToEngine");

        onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
    }

    private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
        this.mContext = applicationContext;
        methodChannel = new MethodChannel(messenger, "flutter_plugin_pos");
        eventChannel = new EventChannel(messenger, "flutter_plugin_pos_event");
        eventChannel.setStreamHandler(this);
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(FlutterPlugin.FlutterPluginBinding binding) {
        TRACE.d("onDetachedFromEngine");
        mContext = null;
        PosPluginHandler.initEvenvSender(null, null);
        methodChannel.setMethodCallHandler(null);
        methodChannel = null;
        eventChannel.setStreamHandler(null);
        eventChannel = null;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {

        TRACE.d("FlutterPluginPosPlugin：onMethodCall" + call.method);

        //Result 传递同步消息
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android ${Build.VERSION.RELEASE}");
        } else if (call.method.equals("initPos")) {
            TRACE.d("initPos");
            //pos=null;
            String mode = call.argument("CommunicationMode");
//      val context: Context? = call.argument("Context")
            TRACE.d("initial para:" + mode);
            //实现类的单例模式
            PosPluginHandler.initPos(mode, mContext);
        } else if (call.method.equals("getPosSdkVersion")) {
            TRACE.d("getPosSdkVersion");
            PosPluginHandler.getPosSdkVersion(result);
        } else if (call.method.equals("scanQPos2Mode")) {
            TRACE.d("scanQPos2Mode");
            int scanTime = call.argument("scanTime");
            checkBluePermision(scanTime);
//            PosPluginHandler.scanQPos2Mode(scanTime);
        } else if (call.method.equals("startScanQposBLE")) {
            TRACE.d("startScanQposBLE");
            PosPluginHandler.startScanQposBLE(6);
        } else if (call.method.equals("clearBluetoothBuffer")) {
            TRACE.d("startScanQposBLE");
            PosPluginHandler.clearBluetoothBuffer();
        } else if (call.method.equals("connectBluetoothDevice")) {
            TRACE.d("connectBluetoothDevice");
//            checkBluePermision();
            String address = call.argument("bluetooth_addr");
            PosPluginHandler.connectBluetoothDevice(true, 25, address);
        } else if (call.method.equals("disconnectBT")) {
            TRACE.d("disconnectBT");
            PosPluginHandler.close();
        } else if (call.method.equals("getQposId")) {
            TRACE.d("getQposId");
            PosPluginHandler.getQposId();
        } else if (call.method.equals("getQposInfo")) {
            TRACE.d("getQposInfo");
            PosPluginHandler.getQposInfo();
        }else if(call.method.equals("getICCTag")){
            TRACE.d("getIccTag");
            String EncryptType=call.argument("EncryptType");
            String cardTypes = call.argument("cardType");
            String tagCounts = call.argument("tagCount");
            int  cardtype = Integer.parseInt(cardTypes);
            int tagCount=Integer.parseInt(tagCounts);
            String tagArrStr=call.argument("tagArrStr");
            String getIccTag=PosPluginHandler.getICCTag(EncryptType,cardtype,tagCount,tagArrStr);
            result.success(getIccTag);
        } else if (call.method.equals("getUpdateCheckValue")) {
            TRACE.d("getUpdateCheckValue");
            PosPluginHandler.getUpdateCheckValue();
        } else if (call.method.equals("getKeyCheckValue")) {
            TRACE.d("getKeyCheckValue");
            String CHECKVALUE_KEYTYPE = call.argument("keyType");
            String keyIndex = call.argument("keyIndex");
            PosPluginHandler.getKeyCheckValue(Integer.parseInt(keyIndex), CHECKVALUE_KEYTYPE);
        } else if (call.method.equals("setCardTradeMode")){
            String cardTradeMode = call.argument("cardTradeMode");
            TRACE.d("setCardTradeMode"+cardTradeMode);
            PosPluginHandler.setCardTradeMode(cardTradeMode);
        } else if (call.method.equals("setFormatId")){
            String formatId = call.argument("formatId");
            TRACE.d("setFormatId"+formatId);
            PosPluginHandler.setFormatId(formatId);
        } else if (call.method.equals("setDoTradeMode")){
            String doTradeMode = call.argument("doTradeMode");
            TRACE.d("doTradeMode"+doTradeMode);
            PosPluginHandler.setDoTradeMode(doTradeMode);
        } else if (call.method.equals("doTrade")) {
            TRACE.d("doTrade");
            int keyIndex = call.argument("keyIndex");
            TRACE.d("keyindex:"+keyIndex);
            PosPluginHandler.doTrade(keyIndex, 40);
        } else if(call.method.equals("setAmountIcon")){
            TRACE.d("setAmountIcon");
            String amountType = call.argument("amountType");
            String amountIcon = call.argument("amountIcon");
            PosPluginHandler.setAmountIcon(amountType, amountIcon);
        } else if (call.method.equals("setAmount")) {
            TRACE.d("setAmount");
            String amount = call.argument("amount");
            String cashbackAmount = call.argument("cashbackAmount");
            String currencyCode = call.argument("currencyCode");
            String transactionType = call.argument("transactionType");
//      params['amount'] = "100";
//      params['cashbackAmount'] = "";
//      params['currencyCode'] = "156";
//      params['transactionType'] = "GOODS";
            PosPluginHandler.setAmount(amount, cashbackAmount, currencyCode, transactionType);

        } else if (call.method.equals("doEmvApp")) {
            TRACE.d("doEmvApp");
            String emvOption = call.argument("EmvOption");
            PosPluginHandler.doEmvApp(emvOption);

        } else if (call.method.equals("sendTime")) {
            TRACE.d("sendTime");
            String terminalTime = call.argument("terminalTime");
            PosPluginHandler.sendTime(terminalTime);

        } else if (call.method.equals("getNFCBatchData")) {
            Hashtable<String, String> nfcBatchData = PosPluginHandler.getNFCBatchData();
            result.success(nfcBatchData);
        }else if(call.method.equals("sendNfcProcessResult")){
            String sendNfcProcessResult = call.argument("sendNfcProcessResult");
            PosPluginHandler.sendNfcProcessResult(sendNfcProcessResult);
        } else if (call.method.equals("sendPin")) {

            String pinContent = call.argument("pinContent");

            PosPluginHandler.sendPin(pinContent);

        } else if (call.method.equals("selectEmvApp")) {

            int position = call.argument("position");

            PosPluginHandler.selectEmvApp(position);

        } else if (call.method.equals("sendOnlineProcessResult")) {
            String onlineProcessResult = call.argument("onlineProcessResult");
            PosPluginHandler.sendOnlineProcessResult(onlineProcessResult);
        } else if (call.method.equals("anlysEmvIccData")) {
            String tlv = call.argument("tlv");
            Hashtable<String, String> anlysEmvIccData = PosPluginHandler.anlysEmvIccData(tlv);
            result.success(anlysEmvIccData);
        } else if (call.method.equals("updateEmvConfig")) {
            String emvAppCfg = call.argument("emvApp");
            String emvCapkCfg = call.argument("emvCapk");
            PosPluginHandler.updateEmvConfig(emvAppCfg, emvCapkCfg);
        } else if (call.method.equals("updateEMVConfigByXml")) {
            String xmlContent = call.argument("xmlContent");
            PosPluginHandler.updateEMVConfigByXml(xmlContent);
        } else if (call.method.equals("updatePosFirmware")) {

//      params['upContent'] = upContent;
//      params['address'] = mAddress;
//      await _methodChannel.invokeMethod('updatePosFirmware',params);
            String upContent = call.argument("upContent");
            String mAddress = call.argument("address");
            PosPluginHandler.updatePosFirmware(upContent, mAddress);

        } else if (call.method.equals("doUpdateIPEKOperation")) {

//    params['keyIndex'] = index.toString();
//    params['trackksn'] = trackksn;
//    params['trackipek'] = trackipek;
//    params['trackipekCheckvalue'] = trackipekCheckvalue;
//    params['emvksn'] = emvksn;
//    params['emvipek'] = emvipek;
//    params['emvipekCheckvalue'] = emvipekCheckvalue;
//    params['pinksn'] = pinksn;
//    params['pinipek'] = pinipek;
//    params['pinipekCheckvalue'] = pinipekCheckvalue;
//    await _methodChannel.invokeMethod('doUpdateIPEKOperation',params);    String upContent = call.argument("upContent");
            String keyIndex = call.argument("keyIndex");
            String trackksn = call.argument("trackksn");
            String trackipek = call.argument("trackipek");
            String trackipekCheckvalue = call.argument("trackipekCheckvalue");
            String emvksn = call.argument("emvksn");
            String emvipek = call.argument("emvipek");
            String emvipekCheckvalue = call.argument("emvipekCheckvalue");
            String pinksn = call.argument("pinksn");
            String pinipek = call.argument("pinipek");
            String pinipekCheckvalue = call.argument("pinipekCheckvalue");
            PosPluginHandler.doUpdateIPEKOperation(keyIndex,
                    trackksn, trackipek, trackipekCheckvalue
                    , emvksn, emvipek, emvipekCheckvalue
                    , pinksn, pinipek, pinipekCheckvalue);

        }else if (call.method.equals("updateWorkKey")){
            String keyIndex = call.argument("keyIndex");
            String pik = call.argument("pik");
            String pikCheck = call.argument("pikCheck");
            String trk = call.argument("trk");
            String trkCheck = call.argument("trkCheck");
            String mak = call.argument("mak");
            String makCheck = call.argument("makCheck");
            PosPluginHandler.updateWorkKey(
                    pik, pikCheck,
                    trk, trkCheck,
                    mak, makCheck, Integer.parseInt(keyIndex));

        }else if (call.method.equals("setMasterKey")) {
//
//      params['key'] = key;
//      params['checkValue'] = checkValue;
//      StringBuffer index = StringBuffer();
//      index.write(keyIndex);
//      params['keyIndex'] = index.toString();
//      await _methodChannel.invokeMethod('setMasterKey',params);
            String key = call.argument("key");
            String checkValue = call.argument("checkValue");
            String keyIndex = call.argument("keyIndex");
            PosPluginHandler.setMasterKey(key, checkValue, Integer.parseInt(keyIndex));

        } else if (call.method.equals("getUpdateProgress")) {

            PosPluginHandler.getUpdateProgress(result);

        } else if (call.method.equals("openUart")) {

          String path = call.argument("path");
          PosPluginHandler.openUart(path);

        } else if (call.method.equals("pinMapSync")) {

            String value = call.argument("value");
            PosPluginHandler.pinMapSync(value);

        } else if(call.method.equals("getTrack2Ciphertext")) {
            String time = call.argument("time");
            PosPluginHandler.getTrack2Ciphertext(time);
        } else if(call.method.equals("getMIccCardData")) {
            String time = call.argument("time");
            PosPluginHandler.getMIccCardData(time);
        } else if(call.method.equals("resetQPosStatus")){
           boolean re = PosPluginHandler.resetQPosStatus();
           TRACE.d("flutterpluginqposplugin:"+re);
            result.success(re);
        } else if(call.method.equals("pollOnMifareCard")){
            int timeout = call.argument("timeout");
            PosPluginHandler.pollOnMifareCard(timeout);

        } else if(call.method.equals("authenticateMifareCard")){
            String mifareCardType = call.argument("MifareCardType");
            String keyType = call.argument("keyType");
            String block = call.argument("block");
            String keyValue = call.argument("keyValue");
            String timeout =call.argument("timeout");
            PosPluginHandler.authenticateMifareCard(mifareCardType,keyType,block,keyValue, Integer.parseInt(timeout));

        } else if(call.method.equals("operateMifareCardData")){
            String mifareCardOperationType = call.argument("MifareCardOperationType");
            String block = call.argument("block");
            String data = call.argument("data");
            String timeout =call.argument("timeout");
            PosPluginHandler.operateMifareCardData(mifareCardOperationType,block,data,Integer.parseInt(timeout));

        } else if(call.method.equals("readMifareCard")){
            String mifareCardType = call.argument("MifareCardType");
            String block = call.argument("block");
            String timeout =call.argument("timeout");
            PosPluginHandler.readMifareCard(mifareCardType,block,Integer.parseInt(timeout));

        } else if(call.method.equals("setIsOperateMifare")){
            boolean isOperateMifare = call.argument("isOperateMifare");
            PosPluginHandler.setIsOperateMifare(isOperateMifare);
        } else if(call.method.equals("writeMifareCard")){
            String mifareCardType = call.argument("MifareCardType");
            String block = call.argument("block");
            String data = call.argument("data");
            String timeout =call.argument("timeout");
            PosPluginHandler.writeMifareCard(mifareCardType,block,data,Integer.parseInt(timeout));

        } else if(call.method.equals("finishMifareCard")){
            int timeout = call.argument("timeout");
            PosPluginHandler.finishMifareCard(timeout);
        } else if(call.method.equals("setBuzzerStatus")){
            int status = call.argument("status");
            PosPluginHandler.setBuzzerStatus(status);
        } else if(call.method.equals("doSetBuzzerOperation")){
            int times = call.argument("times");
            PosPluginHandler.doSetBuzzerOperation(times);
        } else if(call.method.equals("setSleepModeTime")){
            int time = call.argument("time");
            PosPluginHandler.setSleepModeTime(time);
        } else if(call.method.equals("setShutDownTime")){
            int time = call.argument("time");
            PosPluginHandler.setShutDownTime(time);
        }
        else {
            result.notImplemented();
        }
    }

    private void checkBluePermision(int time) {
        TRACE.d("checkBluePermision:"+time);
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.S){
            if(ContextCompat.checkSelfPermission(mContext, Manifest.permission.BLUETOOTH_SCAN) != PackageManager.PERMISSION_GRANTED
                    ||ContextCompat.checkSelfPermission(mContext, Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED
                    ||ContextCompat.checkSelfPermission(mContext, Manifest.permission.BLUETOOTH_ADVERTISE) != PackageManager.PERMISSION_GRANTED){
                String[] list = new String[]{Manifest.permission.BLUETOOTH_SCAN, Manifest.permission.BLUETOOTH_CONNECT, Manifest.permission.BLUETOOTH_ADVERTISE};
                ActivityCompat.requestPermissions(mActivity, list, BLUETOOTH_CODE);

            }
        }
        BluetoothAdapter adapter = BluetoothAdapter.getDefaultAdapter();

        if (!adapter.isEnabled()) {//表示蓝牙不可用
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            enableBtIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            mContext.startActivity(enableBtIntent);
            return;
        }
        LocationManager lm = (LocationManager) mContext.getSystemService(Context.LOCATION_SERVICE);
        boolean ok = lm.isProviderEnabled(LocationManager.GPS_PROVIDER);
        if (ok) {//开了定位服务
            if (ContextCompat.checkSelfPermission(mContext, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                Log.e("POS_SDK", "没有权限");
                    ActivityCompat.requestPermissions(mActivity, new String[]{Manifest.permission.ACCESS_COARSE_LOCATION,Manifest.permission.ACCESS_FINE_LOCATION}, LOCATION_CODE);

//                return false;
            } else {
                PosPluginHandler.scanQPos2Mode(time);
//                return true;
            }
        } else {
            Log.e("BRG", "System detects that the GPS location service is not turned on");
//            return false;
        }
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        TRACE.d("onListen");
        PosPluginHandler.initEvenvSender(events, arguments);
    }

    @Override
    public void onCancel(Object arguments) {
        TRACE.d("onCancel");
        PosPluginHandler.initEvenvSender(null, arguments);
//
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        mActivity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }
}
