package com.dspread.flutter_plugin_qpos;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;

import com.alibaba.fastjson.JSONObject;
import com.dspread.xpos.QPOSService;


import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel.Result;


public class PosPluginHandler {

    private static QPOSService mPos;
    private static Context mContext;
    private static int mMode = QPOSService.CommunicationMode.BLUETOOTH.ordinal();
    private static QPOSServiceListenerImpl listener;
    static EventChannel.EventSink mEvents;
    private static Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
                    Map map = new HashMap();
                    map.put("method", "onUpdatePosFirmwareProcessChanged");
                    StringBuffer parameters = new StringBuffer();
                    int progress = msg.what;
                    parameters.append(progress);
                    map.put("parameters", parameters.toString());
                    PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
        }
    };


    public static void initEvenvSender(EventChannel.EventSink events, Object arguments) {
        TRACE.d("initEvenvSender");

        mEvents = events;

    }

    public static void initPos(String mode, Context context) {

        QPOSService.CommunicationMode mode1 = QPOSService.CommunicationMode.valueOf(mode);
        mPos = QPOSService.getInstance(mode1);
        mMode = mode1.ordinal();
        mContext = context;
        TRACE.d("mode:" + mode);
        if(mode.equals("UART")) {
            TRACE.d("mode11:" + mode);
            mPos.setD20Trade(true);
        } else {
            TRACE.d("mode2:" + mode);
           mPos.setD20Trade(false);
        }
        mPos.setConext(context);
        //通过handler处理，监听MyPosListener，实现QposService的接口，（回调接口）
        Handler handler = new Handler(Looper.myLooper());
        listener = new QPOSServiceListenerImpl();
        mPos.initListener(handler, listener);
    }

    public static void getPosSdkVersion(Result result) {
        String sdkVersion = QPOSService.getSdkVersion();
        TRACE.d(sdkVersion);
        result.success(sdkVersion);

    }

    public static void clearBluetoothBuffer() {
        mPos.clearBluetoothBuffer();
    }

    public static void scanQPos2Mode(int time) {
        mPos.scanQPos2Mode(mContext, time);
    }

    public static void startScanQposBLE(int time) {
        mPos.startScanQposBLE(time);
    }

    public static void getQposId() {
        mPos.getQposId();
    }

    public static void getQposInfo() {
        mPos.getQposInfo();
    }
    public static void getUpdateCheckValue() {
        mPos.getUpdateCheckValue();
    }

    public static void getKeyCheckValue(int index,String value) {
        mPos.getKeyCheckValue(index, QPOSService.CHECKVALUE_KEYTYPE.valueOf(value));
    }
    //    /**
//     * OTG 驱动
//     *
//     * @author xiaolh
//     */
//    public static enum UsbOTGDriver {
//        CDCACM,FTDI,CH340,CP21XX,PROLIFIC,CH34XU
//    }
    public static void setUsbSerialDriver(String driver) {
        try {
            QPOSService.UsbOTGDriver usbOTGDriver = QPOSService.UsbOTGDriver.valueOf(driver);
            mPos.setUsbSerialDriver(usbOTGDriver);
        } catch (Exception e) {
            mPos.setUsbSerialDriver(QPOSService.UsbOTGDriver.CH34XU);
        }

    }

    public static void connectBluetoothDevice(boolean auto, int time, String blueTootchAddress) {
        mPos.connectBluetoothDevice(auto, time, blueTootchAddress);
    }

    public static void connectBLE(String blueTootchAddress) {
        mPos.connectBLE(blueTootchAddress);

    }


    public static void destroy() {
        if (mPos != null) {
            close();
            mPos = null;
            mContext = null;
        }
    }

    public static void close() {
        TRACE.d("close");
        if (mPos == null) {
            return;
        } else if (mMode == QPOSService.CommunicationMode.AUDIO.ordinal()) {
            mPos.closeAudio();
        } else if (mMode == QPOSService.CommunicationMode.BLUETOOTH.ordinal()) {
            mPos.disconnectBT();
        } else if (mMode == QPOSService.CommunicationMode.BLUETOOTH_BLE.ordinal()) {
            mPos.disconnectBLE();
        } else if (mMode == QPOSService.CommunicationMode.UART.ordinal()) {
            mPos.closeUart();
        } else if (mMode == QPOSService.CommunicationMode.USB.ordinal()
                || mMode == QPOSService.CommunicationMode.USB_OTG.ordinal()
                || mMode == QPOSService.CommunicationMode.USB_OTG_CDC_ACM.ordinal()) {
            mPos.closeUsb();
        }

    }

    public static void setCardTradeMode(String cardTradeMode) {
        mPos.setCardTradeMode(QPOSService.CardTradeMode.valueOf(cardTradeMode));
    }

    public static void setFormatId(String formatId) {
        mPos.setFormatId(formatId);
    }

    public static void setDoTradeMode(String doTradeMode) {
        mPos.setDoTradeMode(QPOSService.DoTradeMode.valueOf(doTradeMode));
    }

    public static void doTrade(int i, int i1) {
        mPos.doTrade(i, i1);
    }

    public static void setAmount(String amount, String cashbackAmount, String currencyCode, String transactionType) {
        mPos.setAmount(amount, cashbackAmount, currencyCode, QPOSService.TransactionType.valueOf(transactionType));
    }

    public static void doEmvApp(String emvOption) {
        mPos.doEmvApp(QPOSService.EmvOption.valueOf(emvOption));
    }

    public static void sendTime(String terminalTime) {
        mPos.sendTime(terminalTime);

    }

    public static Hashtable<String, String> getNFCBatchData() {
        return mPos.getNFCBatchData();
    }

    public static void sendPin(String pinContent) {
        mPos.sendPin(pinContent);
    }

    public static void selectEmvApp(int position) {
        mPos.selectEmvApp(position);
    }

    public static void sendOnlineProcessResult(String onlineProcessResult) {
        mPos.sendOnlineProcessResult(onlineProcessResult);
    }

    public static Hashtable<String, String> anlysEmvIccData(String tlv) {
        return mPos.anlysEmvIccData(tlv);
    }

    public static void updateEmvConfig(String emvAppCfg, String emvCapkCfg) {
        TRACE.d("emvAppCfg: " + emvAppCfg);
        TRACE.d("emvCapkCfg: " + emvCapkCfg);
        mPos.updateEmvConfig(emvAppCfg, emvCapkCfg);
    }

    public static void updateEMVConfigByXml(String xmlContent){
     TRACE.d("emv config: " + xmlContent);
     mPos.updateEMVConfigByXml(xmlContent);
    }

    public static void updatePosFirmware(String upContent, String mAddress) {
        byte[] bytes = Utils.hexStringToByteArray(upContent);
        mPos.updatePosFirmware(bytes, mAddress);
        new Thread(new Runnable() {
            int progress = 0;

            @Override
            public void run() {
                progress = mPos.getUpdateProgress();
                if (progress == -1)
                    return;
                while (progress < 100) {
                    int i = 0;
                    while (i < 100) {
                        try {
                            Thread.sleep(1);
                        } catch (InterruptedException e) {
                            // TODO Auto-generated catch block
                            e.printStackTrace();
                        }
                        i++;
                    }
                    if (mPos == null)
                        return;
                    progress = mPos.getUpdateProgress();
                    if (progress == -1) {
                        return;
                    } else {
                        Message msg = new Message();
                        msg.what = progress;
                        mHandler.sendMessage(msg);
                    }

                }
            }
        }).start();
    }


    public static void doUpdateIPEKOperation(String keyIndex, String trackksn, String trackipek, String trackipekCheckvalue, String emvksn, String emvipek, String emvipekCheckvalue, String pinksn, String pinipek, String pinipekCheckvalue) {
        if (keyIndex.length() == 1)
            keyIndex = "0".concat(keyIndex);
        mPos.doUpdateIPEKOperation(keyIndex, trackksn, trackipek, trackipekCheckvalue
                , emvksn, emvipek, emvipekCheckvalue
                , pinksn, pinipek, pinipekCheckvalue);
    }

    public static void updateWorkKey(String pik, String pikCheck, String trk, String trkCheck, String mak, String makCheck, int keyIndex) {
        mPos.updateWorkKey(pik, pikCheck, trk, trkCheck, mak, makCheck, keyIndex);
    }

    public static void setMasterKey(String key, String checkValue, int parseInt) {
        mPos.setMasterKey(key, checkValue, parseInt);
    }

    public static void getUpdateProgress(Result result) {
        result.success(mPos.getUpdateProgress());
    }

    public static void openUart(String path) {
        mPos.setDeviceAddress(path);
        mPos.openUart();
    }

    public static void pinMapSync(String value) {
        mPos.pinMapSync(value,20);
    }

    public static void getTrack2Ciphertext(String time){
        mPos.getTrack2Ciphertext(time);
    }

    public static boolean resetQPosStatus() {return mPos.resetQPosStatus();}
}