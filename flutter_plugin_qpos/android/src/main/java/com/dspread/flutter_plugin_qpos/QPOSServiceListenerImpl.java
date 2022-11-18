package com.dspread.flutter_plugin_qpos;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothDevice;

import com.alibaba.fastjson.JSONObject;
import com.dspread.xpos.CQPOSService;
import com.dspread.xpos.QPOSService;
import com.dspread.xpos.CQPOSService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


// data : {"parameters":"","method":"onRequestWaitingUser"}

//"value":"enum.toString"   一律用String 可以json转字符串  暂时如此考虑

public class QPOSServiceListenerImpl extends CQPOSService   {


    private static final String Delimiter = "||";

    @Override
    public void onRequestWaitingUser() {//等待卡片
        TRACE.d("onRequestWaitingUser()");
//        Map map = new HashMap();  //客户反馈使用的IDE会报warning，遂细化类型
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestWaitingUser");
        StringBuffer parameters = new StringBuffer();
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    /**
     * 返回选择的开始，返回交易的结果
     */
    @Override
    public void onDoTradeResult(QPOSService.DoTradeResult result, Hashtable<String, String> decodeData) {
        TRACE.d("(DoTradeResult result, Hashtable<String, String> decodeData) " + result.toString() + TRACE.NEW_LINE + "decodeData:" + decodeData);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onDoTradeResult");
        StringBuffer parameters = new StringBuffer();
        if (decodeData != null)
        parameters.append(result.toString().concat(Delimiter).concat(decodeData.toString()));
        else
            parameters.append(result.toString());

        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }
    @Override
    public void onQposInfoResult(Hashtable<String, String> posInfoData) {
        TRACE.d("onQposInfoResult" + posInfoData.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onQposInfoResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(posInfoData.toString());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    /**
     * 请求交易
     * TODO 简单描述该方法的实现功能（可选）
     *
     * @see com.dspread.xpos.QPOSService.QPOSServiceListener#onRequestTransactionResult(com.dspread.xpos.QPOSService.TransactionResult)
     */
    @Override
    public void onRequestTransactionResult(QPOSService.TransactionResult transactionResult) {
        TRACE.d("onRequestTransactionResult()" + transactionResult.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestTransactionResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(transactionResult.toString());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onRequestBatchData(String tlv) {
        TRACE.d("ICC交易结束");
        TRACE.d("onRequestBatchData:"+tlv);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestBatchData");
        StringBuffer parameters = new StringBuffer();
        parameters.append(tlv);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));

    }

    @Override
    public void onRequestTransactionLog(String tlv) {
        TRACE.d("onRequestTransactionLog(String tlv):" + tlv);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestTransactionLog");

        StringBuffer parameters = new StringBuffer();
        parameters.append(tlv);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onQposIdResult(Hashtable<String, String> posIdTable) {
        TRACE.w("onQposIdResult():" + posIdTable.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onQposIdResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(posIdTable.toString());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onRequestSelectEmvApp(ArrayList<String> appList) {
        TRACE.d("onRequestSelectEmvApp():" + appList.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestSelectEmvApp");
        StringBuffer parameters = new StringBuffer();
        for (int i = 0; i < appList.size(); i++) {
            parameters.append(appList.get(i));
        }

        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onRequestSetAmount() {
        TRACE.d("onRequestSetAmount()");
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestSetAmount");
        StringBuffer parameters = new StringBuffer();
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    /**
     * 判断是否请求在线连接请求
     * TODO 简单描述该方法的实现功能（可选）
     *
     * @see com.dspread.xpos.QPOSService.QPOSServiceListener#onRequestIsServerConnected()
     */
    @Override
    public void onRequestIsServerConnected() {
        TRACE.d("onRequestIsServerConnected()");
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestIsServerConnected");
        StringBuffer parameters = new StringBuffer();
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onRequestOnlineProcess(final String tlv) {
        TRACE.d("onRequestOnlineProcess()" + tlv);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestOnlineProcess");
        StringBuffer parameters = new StringBuffer();
        parameters.append(tlv);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onRequestTime() {
        TRACE.d("onRequestTime");
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestTime");
        StringBuffer parameters = new StringBuffer();
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }


    @Override
    public void onRequestDisplay(QPOSService.Display displayMsg) {
        TRACE.d("onRequestDisplay(Display displayMsg):" + displayMsg.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestDisplay");
        StringBuffer parameters = new StringBuffer();
        parameters.append(displayMsg.toString());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onRequestFinalConfirm() {
        TRACE.d("onRequestFinalConfirm() ");
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestFinalConfirm");
        StringBuffer parameters = new StringBuffer();
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onRequestNoQposDetected() {
        TRACE.d("onRequestNoQposDetected()");
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestNoQposDetected");
        StringBuffer parameters = new StringBuffer();
        map.put("parameters",parameters.toString());
        TRACE.d("onRequestNoQposDetected():"+JSONObject.toJSONString(map));
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onRequestQposConnected() {
        TRACE.d("onRequestQposConnected()");
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestQposConnected");
        StringBuffer parameters = new StringBuffer();
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onRequestQposDisconnected() {
        TRACE.d("onRequestQposDisconnected()");
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestQposDisconnected");
        StringBuffer parameters = new StringBuffer();
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }



    @Override
    public void onReturnReversalData(String tlv) {

        TRACE.d("onReturnReversalData(): " + tlv);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnReversalData");
        StringBuffer parameters = new StringBuffer();
        parameters.append(tlv);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnGetPinResult(Hashtable<String, String> result) {
        TRACE.d("onReturnGetPinResult(Hashtable<String, String> result):" + result.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnGetPinResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(result.toString());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnApduResult(boolean arg0, String arg1, int arg2) {
        // TODO Auto-generated method stub
        TRACE.d("onReturnApduResult(boolean arg0, String arg1, int arg2):" + arg0 + TRACE.NEW_LINE + arg1 + TRACE.NEW_LINE + arg2);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnApduResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(String.valueOf(arg0).concat(Delimiter).concat(arg1).concat(Delimiter).concat(String.valueOf(arg2)));
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnPowerOffIccResult(boolean arg0) {
        // TODO Auto-generated method stub
        TRACE.d("onReturnPowerOffIccResult(boolean arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnPowerOffIccResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));

    }

    @Override
    public void onReturnPowerOnIccResult(boolean arg0, String arg1, String arg2, int arg3) {
        // TODO Auto-generated method stub
        TRACE.d("onReturnPowerOnIccResult(boolean arg0, String arg1, String arg2, int arg3) :" + arg0 + TRACE.NEW_LINE + arg1 + TRACE.NEW_LINE + arg2 + TRACE.NEW_LINE + arg3);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnPowerOnIccResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(String.valueOf(arg0)
                .concat(Delimiter).concat(arg1)
                .concat(Delimiter).concat(arg2)
                .concat(Delimiter).concat(String.valueOf(arg3)));
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnSetSleepTimeResult(boolean isSuccess) {
        TRACE.d("onReturnSetSleepTimeResult(boolean isSuccess):" + isSuccess);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnSetSleepTimeResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(isSuccess);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onGetCardNoResult(String cardNo) {//获取卡号的回调
        TRACE.d("onGetCardNoResult(String cardNo):" + cardNo);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onGetCardNoResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(cardNo);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));

    }

    @Override
    public void onRequestCalculateMac(String calMac) {
        TRACE.d("onRequestCalculateMac(String calMac):" + calMac);

        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestCalculateMac");
        StringBuffer parameters = new StringBuffer();
        parameters.append(calMac);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }


    @Override
    public void onRequestSignatureResult(byte[] arg0) {
        TRACE.d("onRequestSignatureResult(byte[] arg0):" + arg0.toString());

        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestSignatureResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(new String(arg0));
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onRequestUpdateWorkKeyResult(QPOSService.UpdateInformationResult result) {
        TRACE.d("onRequestUpdateWorkKeyResult(UpdateInformationResult result):" + result);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestUpdateWorkKeyResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(result.toString());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnCustomConfigResult(boolean isSuccess, String result) {
        TRACE.d("onReturnCustomConfigResult(boolean isSuccess, String result):" + isSuccess + TRACE.NEW_LINE + result);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnCustomConfigResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(String.valueOf(isSuccess).concat(Delimiter).concat(result));
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
   }

    @Override
    public void onRequestSetPin() {
        TRACE.d("onRequestSetPin()");
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestSetPin");
        StringBuffer parameters = new StringBuffer();
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnSetMasterKeyResult(boolean isSuccess) {
        TRACE.d("onReturnSetMasterKeyResult(boolean isSuccess) : " + isSuccess);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnSetMasterKeyResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(isSuccess);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnBatchSendAPDUResult(LinkedHashMap<Integer, String> batchAPDUResult) {
        TRACE.d("onReturnBatchSendAPDUResult(LinkedHashMap<Integer, String> batchAPDUResult):" + batchAPDUResult.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnBatchSendAPDUResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(batchAPDUResult.toString());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onBluetoothBondFailed() {
        TRACE.d("onBluetoothBondFailed()");
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onBluetoothBondFailed");
        StringBuffer parameters = new StringBuffer();
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onBluetoothBondTimeout() {
        TRACE.d("onBluetoothBondTimeout()");
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onBluetoothBondTimeout");
        StringBuffer parameters = new StringBuffer();
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onBluetoothBonded() {
        TRACE.d("onBluetoothBonded()");
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onBluetoothBonded");
        StringBuffer parameters = new StringBuffer();
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));

    }

    @Override
    public void onBluetoothBonding() {
        TRACE.d("onBluetoothBonding()");
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onBluetoothBonding");
        StringBuffer parameters = new StringBuffer();
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));

    }

    @Override
    public void onReturniccCashBack(Hashtable<String, String> result) {
        TRACE.d("onReturniccCashBack(Hashtable<String, String> result):" + result.toString());

        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturniccCashBack");
        StringBuffer parameters = new StringBuffer();
        parameters.append(result.toString());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }


    @Override
    public void onLcdShowCustomDisplay(boolean arg0) {
        // TODO Auto-generated method stub
        TRACE.d("onLcdShowCustomDisplay(boolean arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onLcdShowCustomDisplay");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onUpdatePosFirmwareResult(QPOSService.UpdateInformationResult arg0) {
        TRACE.d("onUpdatePosFirmwareResult(UpdateInformationResult arg0):" + arg0.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onUpdatePosFirmwareResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0.toString());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnDownloadRsaPublicKey(HashMap<String, String> result) {
        TRACE.d("onReturnDownloadRsaPublicKey(HashMap<String, String> map):" + result.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnDownloadRsaPublicKey");
        StringBuffer parameters = new StringBuffer();
        parameters.append(result.toString());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onGetPosComm(int mod, String amount, String posid) {
        TRACE.d("onGetPosComm(int mod, String amount, String posid):" + mod + TRACE.NEW_LINE + amount + TRACE.NEW_LINE + posid);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onGetPosComm");
        StringBuffer parameters = new StringBuffer();
        parameters.append(String.valueOf(mod).concat(Delimiter).concat(amount).concat(Delimiter).concat(posid));
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }


    @Override
    public void onPinKey_TDES_Result(String arg0) {
        TRACE.d("onPinKey_TDES_Result(String arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onPinKey_TDES_Result");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onUpdateMasterKeyResult(boolean arg0, Hashtable<String, String> arg1) {
        // TODO Auto-generated method stub
        TRACE.d("onUpdateMasterKeyResult(boolean arg0, Hashtable<String, String> arg1):" + arg0 + TRACE.NEW_LINE + arg1.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onUpdateMasterKeyResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(String.valueOf(arg0).concat(Delimiter).concat(arg1.toString()));
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onEmvICCExceptionData(String arg0) {
        // TODO Auto-generated method stub
        TRACE.d("onEmvICCExceptionData(String arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onEmvICCExceptionData");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onSetParamsResult(boolean arg0, Hashtable<String, Object> arg1) {
        // TODO Auto-generated method stub
        TRACE.d("onSetParamsResult(boolean arg0, Hashtable<String, Object> arg1):" + arg0 + TRACE.NEW_LINE + arg1.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onSetParamsResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(String.valueOf(arg0).concat(Delimiter).concat(arg1.toString()));
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onGetInputAmountResult(boolean arg0, String arg1) {
        // TODO Auto-generated method stub
        TRACE.d("onGetInputAmountResult(boolean arg0, String arg1):" + arg0 + TRACE.NEW_LINE + arg1.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onGetInputAmountResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(String.valueOf(arg0).concat(Delimiter).concat(arg1));
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnNFCApduResult(boolean arg0, String arg1, int arg2) {
        // TODO Auto-generated method stub
        TRACE.d("onReturnNFCApduResult(boolean arg0, String arg1, int arg2):" + arg0 + TRACE.NEW_LINE + arg1 + TRACE.NEW_LINE + arg2);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnNFCApduResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(String.valueOf(arg0).concat(Delimiter).concat(arg1).concat(Delimiter).concat(String.valueOf(arg2)));
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
     }

    @Override
    public void onReturnPowerOffNFCResult(boolean arg0) {
        // TODO Auto-generated method stub
        TRACE.d(" onReturnPowerOffNFCResult(boolean arg0) :" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnPowerOffNFCResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnPowerOnNFCResult(boolean arg0, String arg1, String arg2, int arg3) {
        // TODO Auto-generated method stub
        TRACE.d("onReturnPowerOnNFCResult(boolean arg0, String arg1, String arg2, int arg3):" + arg0 + TRACE.NEW_LINE + arg1 + TRACE.NEW_LINE + arg2 + TRACE.NEW_LINE + arg3);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnPowerOnNFCResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(String.valueOf(arg0)
                .concat(Delimiter).concat(arg1)
                .concat(Delimiter).concat(arg2)
                .concat(Delimiter).concat(String.valueOf(arg3)));
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }


    @Override
    public void onCbcMacResult(String result) {
        TRACE.d("onCbcMacResult(String result):" + result);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onCbcMacResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(result);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
     }

    @Override
    public void onReadBusinessCardResult(boolean arg0, String arg1) {
        // TODO Auto-generated method stub
        TRACE.d(" onReadBusinessCardResult(boolean arg0, String arg1):" + arg0 + TRACE.NEW_LINE + arg1);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReadBusinessCardResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(String.valueOf(arg0).concat(Delimiter).concat(arg1));
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));

    }

    @Override
    public void onWriteBusinessCardResult(boolean arg0) {
        // TODO Auto-generated method stub
        TRACE.d(" onWriteBusinessCardResult(boolean arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onWriteBusinessCardResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onConfirmAmountResult(boolean arg0) {
        // TODO Auto-generated method stub
        TRACE.d("onConfirmAmountResult(boolean arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onConfirmAmountResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onQposIsCardExist(boolean cardIsExist) {
        TRACE.d("onQposIsCardExist(boolean cardIsExist):" + cardIsExist);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onQposIsCardExist");
        StringBuffer parameters = new StringBuffer();
        parameters.append(cardIsExist);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onSearchMifareCardResult(Hashtable<String, String> arg0) {
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onSearchMifareCardResult");
        StringBuffer parameters = new StringBuffer();
        if(arg0 != null) {
            TRACE.d("onSearchMifareCardResult(Hashtable<String, String> arg0):" + arg0.toString());
            parameters.append(arg0.toString());
        } else {
            TRACE.d("onSearchMifareCardResult(Hashtable<String, String> arg0): null" );
            parameters.append("poll card fail");
        }
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }


    @Override
    public void onBatchReadMifareCardResult(String msg, Hashtable<String, List<String>> cardData) {
            TRACE.d("onBatchReadMifareCardResult(boolean arg0):" + msg + cardData.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onBatchReadMifareCardResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(msg.concat(Delimiter).concat(cardData.toString()));
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onBatchWriteMifareCardResult(String msg, Hashtable<String, List<String>> cardData) {
            TRACE.d("onBatchWriteMifareCardResult(boolean arg0):" + msg + cardData.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onBatchWriteMifareCardResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(msg.concat(Delimiter).concat(cardData.toString()));
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onSetBuzzerResult(boolean arg0) {
        TRACE.d("onSetBuzzerResult(boolean arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onSetBuzzerResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onSetBuzzerTimeResult(boolean b) {
        TRACE.d("onSetBuzzerTimeResult(boolean b):" + b);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onSetBuzzerTimeResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(b);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onSetBuzzerStatusResult(boolean b) {
        TRACE.d("onSetBuzzerStatusResult(boolean b):" + b);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onSetBuzzerStatusResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(b);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onGetBuzzerStatusResult(String s) {
        TRACE.d("onGetBuzzerStatusResult(String s):" + s);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onGetBuzzerStatusResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(s);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onSetManagementKey(boolean arg0) {
        TRACE.d("onSetManagementKey(boolean arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onSetManagementKey");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnUpdateIPEKResult(boolean arg0) {
        TRACE.d("onReturnUpdateIPEKResult(boolean arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnUpdateIPEKResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnUpdateEMVRIDResult(boolean arg0) {
        TRACE.d("onReturnUpdateEMVRIDResult(boolean arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnUpdateEMVRIDResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnUpdateEMVResult(boolean arg0) {
        // TODO Auto-generated method stub
        TRACE.d("onReturnUpdateEMVResult(boolean arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnUpdateEMVResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onBluetoothBoardStateResult(boolean arg0) {
        // TODO Auto-generated method stub
        TRACE.d("onBluetoothBoardStateResult(boolean arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onBluetoothBoardStateResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));

    }

    @SuppressLint("MissingPermission")
    @Override
    public void onDeviceFound(BluetoothDevice arg0) {
        // TODO Auto-generated method stub
        TRACE.d("onDeviceFound(BluetoothDevice arg0):" + arg0.getName()+" : "+arg0.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onDeviceFound");
        StringBuffer parameters = new StringBuffer();
        TRACE.d("onDeviceFound(BluetoothDevice ):" + arg0.getName());
        parameters.append(arg0.getName());
        parameters.append("//");
        parameters.append(arg0.toString());
        parameters.append("//");
        parameters.append(arg0.getBondState());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }



    @Override
    public void onSetSleepModeTime(boolean arg0) {
        TRACE.d("onSetSleepModeTime(boolean arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onSetSleepModeTime");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnGetEMVListResult(String arg0) {
        // TODO Auto-generated method stub
        TRACE.d("onReturnGetEMVListResult(String arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnGetEMVListResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onWaitingforData(String arg0) {
        // TODO Auto-generated method stub
        TRACE.d("onWaitingforData(String arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onWaitingforData");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onRequestDeviceScanFinished() {
        // TODO Auto-generated method stub
        TRACE.d("onRequestDeviceScanFinished()");
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestDeviceScanFinished");
        StringBuffer parameters = new StringBuffer();
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onRequestUpdateKey(String arg0) {
        // TODO Auto-generated method stub
        TRACE.d("onRequestUpdateKey(String arg0):" + arg0);

        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestUpdateKey");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnGetQuickEmvResult(boolean arg0) {
        // TODO Auto-generated method stub
        TRACE.d("onReturnGetQuickEmvResult(boolean arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnGetQuickEmvResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onQposDoGetTradeLogNum(String arg0) {
        TRACE.d("onQposDoGetTradeLogNum(String arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onQposDoGetTradeLogNum");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onQposDoTradeLog(boolean arg0) {
        TRACE.d("onQposDoTradeLog(boolean arg0) :" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onQposDoTradeLog");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onAddKey(boolean arg0) {
        TRACE.d("onAddKey(boolean arg0) :" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onAddKey");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
}

    public void onEncryptData(String arg0) {
        TRACE.d("onEncryptData(String arg0) :" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onEncryptData");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onQposKsnResult(Hashtable<String, String> arg0) {
        TRACE.d("onQposKsnResult(Hashtable<String, String> arg0):" + arg0.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onQposKsnResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0.toString());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onQposDoGetTradeLog(String arg0, String arg1) {
        TRACE.d("onQposDoGetTradeLog(String arg0, String arg1):" + arg0 + TRACE.NEW_LINE + arg1);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onQposDoGetTradeLog");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0.concat(Delimiter).concat(arg1));
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onRequestDevice() {
        TRACE.d("onRequestDevice():");
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestDevice");
        StringBuffer parameters = new StringBuffer();
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onGetKeyCheckValue(List<String> checkValue) {
        TRACE.d("onGetKeyCheckValue():"+checkValue);

        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onGetKeyCheckValue");

        StringBuffer parameters = new StringBuffer();
        for (int i = 0; i < checkValue.size(); i++) {
            parameters.append(checkValue.get(i));
        }

        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onQposRequestPinResult(List<String> dataResult, int offlineTime) {
        TRACE.d("onQposRequestPinResult():");

        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onQposRequestPinResult");

        StringBuffer parameters = new StringBuffer();
        for (int i = 0; i < dataResult.size(); i++) {
            parameters.append(dataResult.get(i));
        }

        StringBuffer append = parameters.append(Delimiter).append(offlineTime);
        TRACE.d("onQposRequestPinResult():"+ append.toString());

        map.put("parameters", append.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }


    @Override
    public void onGetDevicePubKey(String clearKeys) {
        TRACE.d("onGetDevicePubKey(clearKeys):" + clearKeys);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onGetDevicePubKey");
        StringBuffer parameters = new StringBuffer();
        parameters.append(clearKeys);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    public void onSetPosBlePinCode(boolean b) {
        TRACE.d("onSetPosBlePinCode(b):" + b);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onSetPosBlePinCode");
        StringBuffer parameters = new StringBuffer();
        parameters.append(b);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onTradeCancelled() {
        TRACE.d("onTradeCancelled");
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onTradeCancelled");
        StringBuffer parameters = new StringBuffer();
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }




    @Override
    public void onReturnSetAESResult(boolean isSuccess, String result) {
        TRACE.d("onReturnSetAESResult"+isSuccess+result);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnSetAESResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(String.valueOf(isSuccess).concat(Delimiter).concat(result));
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnAESTransmissonKeyResult(boolean isSuccess, String result) {
        TRACE.d("onReturnAESTransmissonKeyResult"+isSuccess+result);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnAESTransmissonKeyResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(String.valueOf(isSuccess).concat(Delimiter).concat(result));
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnSignature(boolean b, String signaturedData) {
        TRACE.d("onReturnSignature"+b+signaturedData);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnSignature");
        StringBuffer parameters = new StringBuffer();
        parameters.append(String.valueOf(b).concat(Delimiter).concat(signaturedData));
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnConverEncryptedBlockFormat(String result) {
        TRACE.d("onReturnConverEncryptedBlockFormat"+result);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnConverEncryptedBlockFormat");
        StringBuffer parameters = new StringBuffer();
        parameters.append(result);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onQposIsCardExistInOnlineProcess(boolean haveCard) {
        TRACE.d("onQposIsCardExistInOnlineProcess"+haveCard);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onQposIsCardExistInOnlineProcess");
        StringBuffer parameters = new StringBuffer();
        parameters.append(haveCard);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }



    @Override
    public void onFinishMifareCardResult(boolean arg0) {
        // TODO Auto-generated method stub
        TRACE.d("onFinishMifareCardResult(boolean arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onFinishMifareCardResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onVerifyMifareCardResult(boolean arg0) {
        TRACE.d("onVerifyMifareCardResult(boolean arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onVerifyMifareCardResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReadMifareCardResult(Hashtable<String, String> arg0) {
        // TODO Auto-generated method stub
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReadMifareCardResult");
        StringBuffer parameters = new StringBuffer();
        if(arg0 != null){
            TRACE.d("onReadMifareCardResult(Hashtable<String, String> arg0):" + arg0.toString());
            parameters.append(arg0.toString());
        } else {
            TRACE.d("onReadWriteMifareCardResult fail" );
            parameters.append("onReadWriteMifareCardResult fail");
        }

        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onWriteMifareCardResult(boolean arg0) {
        // TODO Auto-generated method stub
        TRACE.d("onWriteMifareCardResult(boolean arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onWriteMifareCardResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onOperateMifareCardResult(Hashtable<String, String> arg0) {
        // TODO Auto-generated method stub
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onOperateMifareCardResult");
        StringBuffer parameters = new StringBuffer();
        if(arg0!=null){
            TRACE.d("onOperateMifareCardResult(Hashtable<String, String> arg0):" + arg0.toString());
            parameters.append(arg0.toString());
        } else {
            TRACE.d("onOperateMifareCardResult(Hashtable<String, String> arg0): null");
            parameters.append("operate failed");
        }
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void getMifareCardVersion(Hashtable<String, String> arg0) {

        // TODO Auto-generated method stub
            TRACE.d("getMifareCardVersion(Hashtable<String, String> arg0):" + arg0.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","getMifareCardVersion");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0.toString());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void getMifareFastReadData(Hashtable<String, String> arg0) {
        // TODO Auto-generated method stub

            TRACE.d("getMifareFastReadData(Hashtable<String, String> arg0):" + arg0.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","getMifareFastReadData");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0.toString());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void getMifareReadData(Hashtable<String, String> arg0) {

            TRACE.d("getMifareReadData(Hashtable<String, String> arg0):" + arg0.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","getMifareReadData");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0.toString());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }


    @Override
    public void writeMifareULData(String arg0) {

            TRACE.d("writeMifareULData(String arg0):" + arg0.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","writeMifareULData");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void verifyMifareULData(Hashtable<String, String> arg0) {

            TRACE.d("verifyMifareULData(Hashtable<String, String> arg0):" + arg0.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","verifyMifareULData");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0.toString());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }


    @Override
    public void onGetSleepModeTime(String arg0) {
        // TODO Auto-generated method stub

            TRACE.d("onGetSleepModeTime(String arg0):" + arg0.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onGetSleepModeTime");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onGetShutDownTime(String arg0) {

            TRACE.d("onGetShutDownTime(String arg0):" + arg0.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onGetShutDownTime");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onQposDoSetRsaPublicKey(boolean arg0) {
        // TODO Auto-generated method stub
        TRACE.d("onQposDoSetRsaPublicKey(boolean arg0):" + arg0);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onQposDoSetRsaPublicKey");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onQposGenerateSessionKeysResult(Hashtable<String, String> arg0) {

            TRACE.d("onQposGenerateSessionKeysResult(Hashtable<String, String> arg0):" + arg0.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onQposGenerateSessionKeysResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0.toString());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void transferMifareData(String arg0) {
        TRACE.d("transferMifareData(String arg0):" + arg0.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","transferMifareData");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }


    @Override
    public void onReturnRSAResult(String arg0) {
        TRACE.d("onReturnRSAResult(String arg0):" + arg0.toString());
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnRSAResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(arg0);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onRequestNoQposDetectedUnbond() {
        // TODO Auto-generated method stub
        TRACE.d("onRequestNoQposDetectedUnbond()");

        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onRequestNoQposDetectedUnbond");
        StringBuffer parameters = new StringBuffer();
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onError(QPOSService.Error error) {

        TRACE.d("onError:"+error);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onError");
        StringBuffer parameters = new StringBuffer();
        parameters.append(error.name());
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }

    @Override
    public void onReturnGetPinInputResult(int num) {
        TRACE.d("onReturnGetPinInputResult:"+num);
        Map<String,String> map = new HashMap<String,String>();
        map.put("method","onReturnGetPinInputResult");
        StringBuffer parameters = new StringBuffer();
        parameters.append(num);
        map.put("parameters",parameters.toString());
        PosPluginHandler.mEvents.success(JSONObject.toJSONString(map));
    }



}

