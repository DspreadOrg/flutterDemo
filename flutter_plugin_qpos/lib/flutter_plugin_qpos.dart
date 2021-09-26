import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_plugin_qpos/QPOSModel.dart';
import 'package:meta/meta.dart' show visibleForTesting;
import 'package:permission_handler/permission_handler.dart';


class FlutterPluginQpos {

  /// Initializes the plugin and starts listening for potential platform events.
  factory FlutterPluginQpos() {
    if (_instance == null) {
      final MethodChannel methodChannel =
      const MethodChannel('flutter_plugin_pos');
      final EventChannel eventChannel = const EventChannel('flutter_plugin_pos_event');
//      final EventChannel eventChannel = const EventChannel('plugins.flutter.io/charging');

      _instance = FlutterPluginQpos.private(methodChannel, eventChannel);
    }
    return _instance;
  }

  /// This constructor is only used for testing and shouldn't be accessed by
  /// users of the plugin. It may break or change at any time.
  @visibleForTesting
  FlutterPluginQpos.private(this._methodChannel, this._eventChannel);

  static FlutterPluginQpos _instance;

  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;
//  Stream<BatteryState> _onBatteryStateChanged;

//
//  /// Fires whenever the battery state changes.
  Stream<QPOSModel> _onPosListenerCalled;

  Stream<QPOSModel> get onPosListenerCalled {
    if (_onPosListenerCalled == null) {
      _onPosListenerCalled = _eventChannel
          .receiveBroadcastStream()
          .map((dynamic event) => _parsePosListenerCall(event));
    }
    return _onPosListenerCalled;
  }



  QPOSModel _parsePosListenerCall(String state) {
    //    {"parameters":"","method":"onRequestWaitingUser"}
    QPOSModel qposModel = QPOSModel.fromJson(json.decode(state));
    return qposModel;
  }

     init(String mode) {
    Map<String, String> params = Map<String, String>();
    params['CommunicationMode'] = mode;
    _methodChannel.invokeMethod('initPos', params);
  }

  Future requestPermission(String mode) async {
    // request permission
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([PermissionGroup.location]);

    // request result
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);

    if (permission == PermissionStatus.granted) {
      print("granted");
      init(mode);
      scanQPos2Mode(20);
    } else {
      print("no permission");
    }
  }



    Future<String> get posSdkVersion async{
    String version = await _methodChannel.invokeMethod('getPosSdkVersion');
    return version;
  }

    Future<void> connectBluetoothDevice(String addre) async{
    await _methodChannel.invokeMethod('connectBluetoothDevice',{"bluetooth_addr" : addre});
  }

  Future<void> getQposId() async {
    await _methodChannel.invokeMethod('getQposId');
  }
  void getQposInfo() async{
    await _methodChannel.invokeMethod('getQposInfo');
  }

  void getUpdateCheckValue() async{
    await _methodChannel.invokeMethod('getUpdateCheckValue');
  }

  void getKeyCheckValue(int i, String s) async{
    Map<String, String> params = Map<String, String>();
    params['keyIndex'] = i.toString();
    params['keyType'] = s;
    await _methodChannel.invokeMethod('getKeyCheckValue');
  }

  Future<void> disconnectBT() async{
    await _methodChannel.invokeMethod('disconnectBT');
  }

  Future<void> doTrade(Map map) async{

    await _methodChannel.invokeMethod('doTrade',map);
  }

  void setAmount(Map<String, String> params) async{
    await _methodChannel.invokeMethod('setAmount',params);

  }

  void doEmvApp(String s) async{
    Map<String, String> params = Map<String, String>();
    params['EmvOption'] = s;
    await _methodChannel.invokeMethod('doEmvApp',params);

  }

  void sendTime(String s) async{
    Map<String, String> params = Map<String, String>();
    params['terminalTime'] = s;
    await _methodChannel.invokeMethod('sendTime',params);

  }

  Future<HashMap> getNFCBatchData() async{
     Future<HashMap> map =  await _methodChannel.invokeMethod('getNFCBatchData');
     return map;
  }

  void sendPin(String s) async{
    Map<String, String> params = Map<String, String>();
    params['pinContent'] = s;
    await _methodChannel.invokeMethod('sendPin',params);

  }

  void selectEmvApp(int i) async{
    Map<String, int> params = Map<String, int>();
    params['position'] = i;
    await _methodChannel.invokeMethod('selectEmvApp',params);

  }

  void sendOnlineProcessResult(String str)  async{
    Map<String, String> params = Map<String, String>();
    params['onlineProcessResult'] = str;
    await _methodChannel.invokeMethod('sendOnlineProcessResult',params);

  }

  void stopScanQPos2Mode() async{
    await _methodChannel.invokeMethod('stopScanQPos2Mode');
  }

  void scanQPos2Mode(int i)  async{
    Map<String, int> params = Map<String, int>();
    params['scanTime'] = i;
    await _methodChannel.invokeMethod('scanQPos2Mode',params);

  }

  void updateEmvConfig(String emvapp, String emvcapk) async{
    Map<String, String> params = Map<String, String>();
    params['emvApp'] = emvapp;
    params['emvCapk'] = emvcapk;
    await _methodChannel.invokeMethod('updateEmvConfig',params);

  }

  Future<void> updatePosFirmware(String upContent, String mAddress) async{
    Map<String, String> params = Map<String, String>();
    params['upContent'] = upContent;
    params['address'] = mAddress;
   return _methodChannel.invokeMethod('updatePosFirmware',params);

  }

  void doUpdateIPEKOperation(int ipekgroup,
      String trackksn, String trackipek, String trackipekCheckvalue,
      String emvksn, String emvipek, String emvipekCheckvalue,
      String pinksn, String pinipek, String pinipekCheckvalue)async{
    Map<String, String> params = Map<String, String>();
    StringBuffer index = StringBuffer();
    index.write(ipekgroup);
    params['keyIndex'] = index.toString();
    params['trackksn'] = trackksn;
    params['trackipek'] = trackipek;
    params['trackipekCheckvalue'] = trackipekCheckvalue;
    params['emvksn'] = emvksn;
    params['emvipek'] = emvipek;
    params['emvipekCheckvalue'] = emvipekCheckvalue;
    params['pinksn'] = pinksn;
    params['pinipek'] = pinipek;
    params['pinipekCheckvalue'] = pinipekCheckvalue;
    await _methodChannel.invokeMethod('doUpdateIPEKOperation',params);

  }

  void setMasterKey(String key, String checkValue, int keyIndex) async{
    Map<String, String> params = Map<String, String>();
    params['key'] = key;
    params['checkValue'] = checkValue;
    StringBuffer index = StringBuffer();
    index.write(keyIndex);
    params['keyIndex'] = index.toString();
    await _methodChannel.invokeMethod('setMasterKey',params);

  }

  Future<int> getUpdateProgress() async{
     int process = await _methodChannel.invokeMethod('getUpdateProgress');
    return process;

  }

  void openUart(String s) async{
    Map<String, String> params = Map<String, String>();
    params['path'] = s;
    await _methodChannel.invokeMethod('openUart',params);
  }

  void pinMapSync(value) async{
    Map<String, String> params = Map<String, String>();
    params['value'] = value;
    await _methodChannel.invokeMethod('pinMapSync',params);
  }






}

//onQposInfoResult(java.util.Hashtable);
//onRequestTime();
//onRequestDisplay(com.dspread.xpos.QPOSService$Display);
//onQposIdResult(java.util.Hashtable);
//onDoTradeResult(com.dspread.xpos.QPOSService$DoTradeResult,java.util.Hashtable);
//onRequestWaitingUser();
//onRequestTransactionResult(com.dspread.xpos.QPOSService$TransactionResult);
//onReturnConverEncryptedBlockFormat(java.lang.String);
//onRequestQposDisconnected();
//onGetInputAmountResult(boolean,java.lang.String);
//onRequestIsServerConnected();
//onRequestFinalConfirm();
//onSetBuzzerStatusResult(boolean);
//onGetBuzzerStatusResult(java.lang.String);
//onReturnDownloadRsaPublicKey(java.util.HashMap);
//onReturnPowerOnIccResult(boolean,java.lang.String,java.lang.String,int);
//onUpdateMasterKeyResult(boolean,java.util.Hashtable);
//onBatchReadMifareCardResult(java.lang.String,java.util.Hashtable);
//onEmvICCExceptionData(java.lang.String);
//onBluetoothBondFailed();
//onWriteBusinessCardResult(boolean);
//onQposIsCardExist(boolean);
//onRequestBatchData(java.lang.String);
//onReturniccCashBack(java.util.Hashtable);
//onRequestSelectEmvApp(java.util.ArrayList);
//onReturnUpdateIPEKResult(boolean);
//onReturnUpdateEMVRIDResult(boolean);
//onReturnUpdateEMVResult(boolean);
//onSetBuzzerTimeResult(boolean);
//onBluetoothBoardStateResult(boolean);
//onReturnApduResult(boolean,java.lang.String,int);
//onLcdShowCustomDisplay(boolean);
//onSetSleepModeTime(boolean);
//onReturnGetEMVListResult(java.lang.String);
//onReturnGetPinResult(java.util.Hashtable);
//onBluetoothBonded();
//onReturnPowerOnNFCResult(boolean,java.lang.String,java.lang.String,int);
//onRequestSetAmount();
//onRequestQposConnected();
//onUpdatePosFirmwareResult(com.dspread.xpos.QPOSService$UpdateInformationResult);
//onPinKey_TDES_Result(java.lang.String);
//onReturnNFCApduResult(boolean,java.lang.String,int);
//onConfirmAmountResult(boolean);
//onRequestDeviceScanFinished();
//onReturnBatchSendAPDUResult(java.util.LinkedHashMap);
//onSearchMifareCardResult(java.util.Hashtable);
//onReturnReversalData(java.lang.String);
//onRequestCalculateMac(java.lang.String);
//onSetManagementKey(boolean);
//onReturnPowerOffNFCResult(boolean);
//onReturnPowerOffIccResult(boolean);
//onBluetoothBondTimeout();
//onRequestTransactionLog(java.lang.String);
//onGetCardNoResult(java.lang.String);
//onReturnCustomConfigResult(boolean,java.lang.String);
//onReturnSetMasterKeyResult(boolean);
//onRequestUpdateWorkKeyResult(com.dspread.xpos.QPOSService$UpdateInformationResult);
//onReturnSetSleepTimeResult(boolean);
//onBluetoothBonding();
//onRequestOnlineProcess(java.lang.String);
//onSetParamsResult(boolean,java.util.Hashtable);
//onReadBusinessCardResult(boolean,java.lang.String);
//onRequestNoQposDetected();
//onBatchWriteMifareCardResult(java.lang.String,java.util.Hashtable);
//onSetBuzzerResult(boolean);
//onRequestSignatureResult([B);
//onRequestUpdateKey(java.lang.String);
//onReadMifareCardResult(java.util.Hashtable);
//onWriteMifareCardResult(boolean);
//onFinishMifareCardResult(boolean);
//onOperateMifareCardResult(java.util.Hashtable);
//onVerifyMifareCardResult(boolean);
//onReturnAESTransmissonKeyResult(boolean,java.lang.String);
//onGetKeyCheckValue(java.util.List);
//onReturnSignature(boolean,java.lang.String);
//getMifareFastReadData(java.util.Hashtable);
//onReturnSetAESResult(boolean,java.lang.String);
//onReturnGetQuickEmvResult(boolean);
//onQposDoGetTradeLogNum(java.lang.String);
//onQposIsCardExistInOnlineProcess(boolean);
//getMifareCardVersion(java.util.Hashtable);
//getMifareReadData(java.util.Hashtable);
//onSetPosBlePinCode(boolean);
//onQposDoGetTradeLog(java.lang.String,java.lang.String);
//onGetDevicePubKey(java.lang.String);
//onRequestSetPin();
//onCbcMacResult(java.lang.String);
//onAddKey(boolean);
//onError(com.dspread.xpos.QPOSService$Error);
//onQposKsnResult(java.util.Hashtable);
//onEncryptData(java.lang.String);
//onRequestDevice();
//onTradeCancelled();
//onQposDoTradeLog(boolean);
//onWaitingforData(java.lang.String);
//onDeviceFound(android.bluetooth.BluetoothDevice);
//onGetPosComm(int,java.lang.String,java.lang.String);
//onQposDoSetRsaPublicKey(boolean);
//verifyMifareULData(java.util.Hashtable);
//onQposGenerateSessionKeysResult(java.util.Hashtable);
//onRequestNoQposDetectedUnbond();
//onReturnRSAResult(java.lang.String);
//writeMifareULData(java.lang.String);
//transferMifareData(java.lang.String);
//onGetShutDownTime(java.lang.String);
//onGetSleepModeTime(java.lang.String);
//
//Process finished with exit code 0

