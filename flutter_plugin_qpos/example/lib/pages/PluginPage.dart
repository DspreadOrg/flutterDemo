import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';
import 'package:flutter_plugin_qpos/QPOSModel.dart';
import 'package:flutter_plugin_qpos_example/keyboard/view_keyboard.dart';
import 'package:flutter_plugin_qpos_example/pages/SecondPage.dart';

// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:toast/toast.dart';

import '../Utils.dart';
import '../LogUtil.dart';
//import 'package:permission_handler/permission_handler.dart';
//
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class PluginPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

}

final communicationMode = const [
  'AUDIO',
  'BLUETOOTH_VER2',
  'UART',
  'UART_K7',
  'BLUETOOTH_2Mode',
  'USB',
  'BLUETOOTH_4Mode',
  'UART_GOOD',
  'USB_OTG',
  'USB_OTG_CDC_ACM',
  'BLUETOOTH',
  'BLUETOOTH_BLE',
  'UNKNOW',
];


class _MyAppState extends State<PluginPage> {
  FlutterPluginQpos _flutterPluginQpos = FlutterPluginQpos();
  String _platformVersion = 'Unknown';
  String display = "";
  String tlvData = "";
  QPOSModel? trasactionData;
  StreamSubscription? _subscription;
  List<String>? items;
  // var items = List<String>?;
  int? numPinField;
  var scanFinish = 0;
  String? _mAddress;
  var _updateValue;
  bool _visibility = true;
  bool concelFlag = false;
  ProgressDialog? pr;
  int? test;
  bool offstage = true;
  var _mifareBlockAddrTxt = new TextEditingController();
  var _mifareValueTxt = new TextEditingController();


  @override
  void initState() {
    super.initState();
    initPlatformState();
    _subscription =
        _flutterPluginQpos.onPosListenerCalled!.listen((QPOSModel datas) {
      parasListener(datas);
      setState(() {
        trasactionData = datas;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    //取消监听
    if (_subscription != null) {
      _subscription!.cancel();
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = (await _flutterPluginQpos.posSdkVersion)!;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    var content;
    Widget buttonSection = new Container(
      child: new Row(
        children: [

          ElevatedButton(
            onPressed: () async {
              setState(() {
                scanFinish = -1;
                items = null;
              });
              selectDevice();
            },
            child: Text("select device"),
          ),
          ElevatedButton(
            onPressed: () async {
              startDoTrade();
            },
            child: Text("start do trade"),
          ),
          ElevatedButton(
            onPressed: () async {
              disconnectToDevice();
            },
            child: Text("disconnect"),
          )
        ],
      ),
    );

    PopupMenuButton  popMenuUpdate(){
      return PopupMenuButton<String>(
          initialValue: "",
          child:Text("update button"),
          onSelected: (String string) {
            print("selected:"+string.toString());
            onUpdateButtonSelected(string,context);
          },
          itemBuilder: (context) => <PopupMenuItem<String>>[
            PopupMenuItem(
              child: Text("update Emv Config By bin"),
              value: "0",
            ),
            PopupMenuItem(
              child: Text("update Firmware"),
              value: "1",
            ),
            PopupMenuItem(
              child: Text("update IPEK"),
              value: "2",
            ),
            PopupMenuItem(
              child: Text("update Master Key"),
              value: "3",
            ),
            PopupMenuItem(
              child: Text("update Session Key"),
              value: "4",
            ),
            PopupMenuItem(
              child: Text("update Emv Config By xml"),
              value: "5",
            )
          ]
      );
    }

    PopupMenuButton  popMenuInfo(){
      return PopupMenuButton<String>(
          initialValue: "",
          child: //RaisedButton(
          //onPressed: () {  },
          Text("device_info button")
          ,
          onSelected: (String string) {
            print(string.toString());
            onDeviceInfoButtonSelected(string,context);

          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
            PopupMenuItem(
              child: Text("get Device Id"),
              value: "0",
            ),
            PopupMenuItem(
              child: Text("get Device Info"),
              value: "1",
            ),
            PopupMenuItem(
              child: Text("get Device update Key CheckValue"),
              value: "2",
            ),
            PopupMenuItem(
              child: Text("get Device Key CheckValue"),
              value: "3",
            ),
            PopupMenuItem(
              child: Text("reset Pos"),
              value: "4",
            )
          ]);
    }

    PopupMenuButton popMenuOperateMifare(){
      return PopupMenuButton<String>(
          initialValue: "",
          child: //RaisedButton(
          //onPressed: () {  },
          Text("MenuOperateMifare")
          ,
          onSelected: (String string) {
            print(string.toString());
            onOperateMifareButtonSelected(string,context);

          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
            PopupMenuItem(
              child: Text("ADD"),
              value: "0",
            ),
            PopupMenuItem(
              child: Text("REDUCE"),
              value: "1",
            ),
            PopupMenuItem(
              child: Text("RESTORE"),
              value: "2",
            ),
          ]);
    }

    _showMenu(int type){
      final RenderBox? button = context.findRenderObject() as RenderBox?;
      final RenderBox? overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox?;
      final RelativeRect position = RelativeRect.fromRect(
        Rect.fromPoints(
          button!.localToGlobal(Offset(0, 0), ancestor: overlay),
          button.localToGlobal(button.size.bottomRight(Offset.zero),
              ancestor: overlay),
        ),
        Offset.zero & overlay!.size,
      );
      var pop;
      if(type== 1) pop = popMenuUpdate();
      else if(type == 2) pop = popMenuInfo();
      else if(type == 3) pop = popMenuOperateMifare();
      showMenu<String>(
          context: context,
        items: pop.itemBuilder(context) as List<PopupMenuEntry<String>>,
        position: position,   ).then<void>((String? newValue) {
        if (!mounted) return null;
        if (newValue == null) {
          if (pop.onCanceled != null) pop.onCanceled!();
          return null;
        }
        if (pop.onSelected != null) pop.onSelected!(newValue);
      });
    }

    Widget textSection = new Container(
      child: new Column(
        children: [
          Text(
            '$_platformVersion',
          ),
//          Text(
//            '$display',
//          ),
          Text(
            '$trasactionData',
          ),
        ],
      ),
    );

    Widget mifareSection = new Offstage(
          offstage: offstage,
          child: new Container(
            child: new Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              _flutterPluginQpos.pollOnMifareCard(10);
                            },
                            child: Text('pollOnMifare'))),
                    Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            //MifareCardOperationType should be "CLASSIC" or "UlTRALIGHT"
                            //keyType should be "Key A" or "Key B"
                            var blockAddress = _mifareBlockAddrTxt.text;
                            print("address:"+blockAddress);
                            if(blockAddress.length == 0) blockAddress = "0A";
                            _flutterPluginQpos.authenticateMifareCard("CLASSIC", "Key A", blockAddress, "ffffffffffff", 20);

                          },
                          child: Text('authenticateMifare'),
                        )),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              // _flutterPluginQpos.operateMifareCardData("CLASSIC", "Key A", "0A", "ffffffffffff", 20);
                              _showMenu(3);
                            },
                            child: Text('operateMifareData')))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              var blockAddress = _mifareBlockAddrTxt.text;
                              print("address:"+blockAddress);
                              if(blockAddress.length == 0) blockAddress = "0A";
                              _flutterPluginQpos.readMifareCard("CLASSIC", blockAddress, 20);
                            },
                            child: Text('readMifare'))),
                    Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            var blockAddress = _mifareBlockAddrTxt.text;
                            var value = _mifareValueTxt.text;
                            print("address:"+blockAddress+" value:"+value);
                            if(blockAddress.length == 0) blockAddress = "0A";
                            if(value.length == 0) value = "0002";
                            _flutterPluginQpos.setIsOperateMifare(false);//set false so the int value won't be conver to Hex
                            _flutterPluginQpos.writeMifareCard("CLASSIC", blockAddress, value,20);
                          },
                          child: Text('writeMifare'),
                        )),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              _flutterPluginQpos.finishMifareCard(10);
                            },
                            child: Text('finishMifare')))
                  ],
                ),
                Row(
                  children:[
                    Expanded(
                      child: new TextField(
                          controller: _mifareBlockAddrTxt,//把 TextEditingController 对象应用到 TextField 上
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: 'mifare block address',
                            border: OutlineInputBorder(),
                          ),
                      )),
                    Expanded(
                        child: new TextField(
                          controller: _mifareValueTxt,//把 TextEditingController 对象应用到 TextField 上
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: 'write or operate value',
                            border: OutlineInputBorder(),
                          ),
                        )),
                  ],
                )
              ],
            ),

          ),


        );

    Widget textResultSection = new Container(
      child: new Column(
        children: [
          Text(
            '$display',
          ),
        ],
      ),
    );

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('plugin page'),
          ),
          body: new ListView(
            children: [
              ElevatedButton(
                onPressed: () async {
                  openUart();
                },
                child: Text("open uart"),
              ),
              buttonSection,
              textSection,
              ElevatedButton(onPressed:(){
                _showMenu(1);
              } ,
                  child: Text("update button")
              ),
              // btnMenuSection(),
              // btnMenuDeviceInfoSection,
              ElevatedButton(onPressed:(){
                _showMenu(2);
              } ,
                  child: Text("device info button")
              ),
              ElevatedButton(onPressed:(){
                 setState(() {
                  offstage = !offstage;
                });

              } ,
                  child: Text("operate mifare")
              ),

              getListSection()??Text(''),
              textResultSection,
              mifareSection,


//              getupdateSection()
            ],
            padding: EdgeInsets.all(2.0),
          )),
    );
  }

//
//  Future requestPermission(List<PermissionGroup> permissions) async {
//    if(permissions == null || permissions.length<1){
//      return false;
//    }
//    // 申请权限
//    Map<PermissionGroup, PermissionStatus> permissionsMap =
//        await PermissionHandler().requestPermissions(permissions);
//    PermissionStatus permission = null;
//    // 申请结果
//    for (int i = 0; i < permissions.length; i++) {
//      permission = await PermissionHandler()
//          .checkPermissionStatus(permissions[i]);
//      if (permission != PermissionStatus.granted) {
//        Fluttertoast.showToast(msg: "denied");
//        return false;
//      }
//      return true;
//    }
//  }

  void searchNearByDevice() {}

  Future<void> connectToDevice(String item) async {
    List<String> addrs = item.split("//");
    _mAddress = addrs[1];
    setState(() {
      scanFinish = 0;
      items = null;
    });
    await _flutterPluginQpos.connectBluetoothDevice(addrs[1]);
  }

  Future<void> disconnectToDevice() async {
    await _flutterPluginQpos.disconnectBT();
  }



  void startDoTrade() {
    int keyIndex = 0;
    // params['keyIndex'] = 0;
    _flutterPluginQpos.setFormatId(FormatID.DUKPT);
    // _flutterPluginQpos.setCardTradeMode(CardTradeMode.SWIPE_TAP_INSERT_CARD);
    // _flutterPluginQpos.setDoTradeMode(DoTradeMode.COMMON);
    _flutterPluginQpos.doTrade(keyIndex);
  }

  Future<void> parasListener(QPOSModel datas) async {
    //Map map = new Map<String, dynamic>.from(json.decode(datas));
    // CustomerModel testModel = CustomerModel.fromJson(json.decode(datas));
    //String method = map["method"];
    String? method = datas.method;
    List<String> paras = new List.empty();
    //String parameters = map["parameters"];
    String? parameters = datas.parameters;
    if (parameters != null && parameters.length > 0) {
      paras = parameters.split("||");
    }

    switch (method) {
      case 'onRequestTransactionResult':
        setState(() {
          display = "onRequestTransactionResult: " + parameters!+"\n"+display+"\n"+tlvData;
        });
        break;
      case 'onRequestWaitingUser':
        setState(() {
          display = "Please insert/swipe/tap card";
        });
        break;
      case 'onReturnConverEncryptedBlockFormat':
        break;
      case 'onWaitingforData':
        break;
      case 'onRequestDevice':
        break;
      case 'onEncryptData':
        break;
      case 'onRequestDisplay':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onQposInfoResult':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onCbcMacResult':
        break;
      case 'onRequestTime':
        _flutterPluginQpos.sendTime("20200215175558");
        break;
      case 'onAddKey':
        break;
      case 'onTradeCancelled':
        break;
      case 'onRequestSetPin':
        setState(() {
          display = "Please input pin on your app";
        });
        _flutterPluginQpos.sendPin("1111");
        break;
      case 'onQposRequestPinResult':
        _showKeyboard(context,parameters!);
        break;
      case 'onGetPosComm':
        break;
      case 'onDeviceFound':
        setState(() {
          if (items == null) {
            // ignore: deprecated_member_use
            // items = new List.empty();
            items = new List.empty(growable: true);
          }
          items!.add(parameters!);
        });
        StringBuffer buffer = new StringBuffer();
        for (int i = 0; i < items!.length; i++) {
          buffer.write(items![i]);
        }
        print("onDeviceFound : ${buffer.toString()}");
        break;
      case 'onQposDoTradeLog':
        break;
      case 'onQposKsnResult':
        break;
      case 'onDoTradeResult':
        if (Utils.equals(paras[0], "ICC")) {
          _flutterPluginQpos.doEmvApp("START");
        }

        if (Utils.equals(paras[0], "NFC_ONLINE") || Utils.equals(paras[0], "NFC_OFFLINE")) {
          Future geticctag = _flutterPluginQpos.getICCTag("PLAINTEXT", 1, 1, "9F06");
           String icctag = await geticctag;
           String tlv = "8A025931"+icctag;
           print("tlv=="+tlv);
          _flutterPluginQpos.sendNfcProcessResult(tlv);

          Future map = _flutterPluginQpos.getNFCBatchData().then((value) =>  setState(() {
            display = value.toString();
          }));

          //
        }else if(Utils.equals(paras[0], "MCR")){
          setState(() {
            display = paras[1];
          });
        }
        break;
      case 'onQposIdResult':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onError':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onReturnRSAResult':
        break;
      case 'onQposDoSetRsaPublicKey':
        break;
      case 'onGetShutDownTime':
        break;
      case 'writeMifareULData':
        setState(() {
          display = "writeMifareULData:"+parameters!;
        });
        break;
      case 'onQposGenerateSessionKeysResult':
        break;
      case 'verifyMifareULData':
        break;
      case 'transferMifareData':
        break;
      case 'onGetSleepModeTime':
        break;
      case 'onRequestNoQposDetectedUnbond':
        break;
      case 'onRequestBatchData':
        print("onRequestBatchData:"+parameters!);
        break;
      case 'onReturnGetPinResult':
        break;
      case 'onReturniccCashBack':
        break;
      case 'onReturnSetSleepTimeResult':
        break;
      case 'onPinKey_TDES_Result':
        break;
      case 'onEmvICCExceptionData':
        break;
      case 'onGetInputAmountResult':
        break;
      case 'onRequestQposDisconnected':
        setState(() {
          display = "device disconnected!";
        });
        break;
      case 'onReturnPowerOnIccResult':
        break;
      case 'onBluetoothBondTimeout':
        break;
      case 'onBluetoothBonded':
        break;
      case 'onReturnDownloadRsaPublicKey':
        break;
      case 'onReturnPowerOnNFCResult':
        break;
      case 'onConfirmAmountResult':
        break;
      case 'onQposIsCardExist':
        break;
      case 'onSearchMifareCardResult':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onReturnBatchSendAPDUResult':
        break;
      case 'onReturnApduResult':
        break;
      case 'onBatchReadMifareCardResult':
        break;
      case 'onSetBuzzerTimeResult':
        break;
      case 'onWriteBusinessCardResult':
        break;
      case 'onBatchWriteMifareCardResult':
        break;
      case 'onSetBuzzerResult':
        break;
      case 'onRequestSelectEmvApp':
        _flutterPluginQpos.selectEmvApp(1);

        break;
      case 'onLcdShowCustomDisplay':
        break;
      case 'onRequestQposConnected':
        setState(() {
                display = "device connected!";
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>SecondPage(_flutterPluginQpos)));
            });
        break;
      case 'onUpdatePosFirmwareResult':
        concelFlag = true;
        if (pr!.isOpen()) {
          pr!.close();
        }
        break;
      case 'onUpdatePosFirmwareProcessChanged':
        print('onUpdatePosFirmwareProcessChanged${parameters}');

        print('onUpdatePosFirmwareProcessChanged${double.parse(parameters!)}');
        if(pr != null && pr!.isOpen()){
          // pr!.update(
          //   progress: double.parse(parameters),
          //   message: "Please wait...",
          //   progressWidget: Container(
          //       padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
          //   maxProgress: 100.0,
          // );
          pr!.update(value: int.parse(parameters),msg: "Please wait...");
        }
        break;

      case 'onReturnPowerOffNFCResult':
        break;
      case 'onReadBusinessCardResult':
        break;
      case 'onReturnPowerOffIccResult':
        break;
      case 'onSetBuzzerStatusResult':
        break;
      case 'onRequestTransactionLog':
        break;
      case 'onGetBuzzerStatusResult':
        break;
      case 'onSetManagementKey':
        break;
      case 'onUpdateMasterKeyResult':
        break;
      case 'onReturnUpdateIPEKResult':
        break;
      case 'onBluetoothBonding':
        break;
      case 'onSetParamsResult':
        break;
      case 'onReturnSetMasterKeyResult':
        break;
      case 'onReturnNFCApduResult':
        break;
      case 'onReturnCustomConfigResult':
        break;
      case 'onRequestUpdateWorkKeyResult':
        break;
      case 'onReturnUpdateEMVRIDResult':
        break;
      case 'onReturnReversalData':
        break;
      case 'onReturnUpdateEMVResult':
        break;
      case 'onBluetoothBoardStateResult':
        break;
      case 'onGetCardNoResult':
        break;
      case 'onRequestCalculateMac':
        break;
      case 'onRequestFinalConfirm':
        break;
      case 'onSetSleepModeTime':
        break;
      case 'onRequestSetAmount':

        // _flutterPluginQpos.setAmountIcon(AmountType.MONEY_TYPE_CUSTOM_STR, "Y");

        Map<String, String> params = Map<String, String>();

        simpleDialog(context).then((value) {
          setState(() {
            print("final type:"+value);
            params['transactionType'] = value;
            params['amount'] = "100";
            params['cashbackAmount'] = "";
            params['currencyCode'] = "156";
            // params['transactionType'] = "GOODS";
            _flutterPluginQpos.setAmount(params);
          });
        });

        break;
      case 'onReturnGetEMVListResult':
        break;
      case 'onRequestDeviceScanFinished':
        setState(() {
          scanFinish = 1;
        });
        break;
      case 'onRequestSignatureResult':
        break;
      case 'onRequestIsServerConnected':
        break;
      case 'onRequestNoQposDetected':
        break;
      case 'onRequestOnlineProcess':
        tlvData = parameters!;
        Future map = _flutterPluginQpos.anlysEmvIccData(parameters).then((value) =>  setState(() {
          //print("anlysEmvIccData:"+value.toString());
          LogUtil.v("anlysEmvIccData:"+value.toString());
          // An example to show how to get the key value
          var tlvData = value["tlv"];
          if(tlvData != null) print("tlv= "+tlvData);
          String str = "8A023030"; //Currently the default value,
          _flutterPluginQpos.sendOnlineProcessResult(str); //脚本通知/55域/ICCDATA
        }));


        break;
      case 'onBluetoothBondFailed':
        break;
      case 'onWriteMifareCardResult':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onQposIsCardExistInOnlineProcess':
        break;
      case 'onSetPosBlePinCode':
        break;
      case 'onQposDoGetTradeLogNum':
        break;
      case 'onGetDevicePubKey':
        break;
      case 'onReturnGetQuickEmvResult':
        break;
      case 'onReturnSignature':
        break;
      case 'onReadMifareCardResult':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onOperateMifareCardResult':
        setState(() {
          display = parameters!;
        });
        break;
      case 'getMifareFastReadData':
        break;
      case 'getMifareReadData':
        setState(() {
          display = parameters!;
        });
        break;
      case 'getMifareCardVersion':
        break;
      case 'onFinishMifareCardResult':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onQposDoGetTradeLog':
        break;
      case 'onRequestUpdateKey':
        break;
      case 'onReturnSetAESResult':
        break;
      case 'onReturnAESTransmissonKeyResult':
        break;
      case 'onVerifyMifareCardResult':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onGetKeyCheckValue':
        break;
      case 'bluetoothIsPowerOff2Mode':
        print("bluetoothIsPowerOff2Mode");
        break;
      case 'bluetoothIsPowerOn2Mode':
        print("bluetoothIsPowerOn2Mode");
        break;
      case 'onReturnGetPinInputResult':
        setState(() {
          numPinField = int.parse(parameters!);
        });
        break;
      default:
        throw ArgumentError('error');
    }
  }

  void selectDevice() {
    // _flutterPluginQpos.requestPermission(communicationMode[10]);
    _flutterPluginQpos.init(communicationMode[10]);
    _flutterPluginQpos.scanQPos2Mode(10);
  }

  void openUart() {
    _flutterPluginQpos.init(communicationMode[2]);
    _mAddress = "/dev/ttyS1";
    _flutterPluginQpos.openUart(_mAddress!);
  }

  Widget _getListDate(BuildContext context, int position)  {
    if (items != null) {
      return new TextButton(
          onPressed: () => connectToDevice(items![position]),
          child: new Text("text ${items![position]}"));
    }else{
      return new TextButton(
          onPressed: () => connectToDevice(items![position]),
          child: new Text("No item"));
    }
  }

  Widget? getListSection() {
    if (items == null) {
      if (scanFinish == 0) {
        return new Text("");
      } else {
        if (scanFinish == -1)
          return new Center(child: new CircularProgressIndicator());
      }
    } else {
      if (scanFinish == 1) {
        Widget listSection = new ListView.builder(
          shrinkWrap: true,
          //解决无限高度问题
          physics: new NeverScrollableScrollPhysics(),
          padding: new EdgeInsets.all(5.0),
          itemExtent: 50.0,
          itemCount: items == null ? 0 : items!.length,
          itemBuilder: (BuildContext context, int index) {
            return _getListDate(context, index);
          },
        );
        return listSection;
      } else {
        return new Center(child: new CircularProgressIndicator());
      }
    }
  }

  Widget getupdateSection() {
    if (_visibility) {
      return new LinearProgressIndicator(
        backgroundColor: Colors.blue,
        value: _updateValue,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
      );
    } else {
      return new Text("");
    }
  }



  operatUpdateProcess(ByteData value, BuildContext context) async {
    if(pr != null && pr!.isOpen())
      pr!.close();
    pr = ProgressDialog(context: context);
    //pr = new ProgressDialog(context, type: ProgressDialogType.Download);
    //pr!.style(message: 'Update Firmware...',);
    pr!.show(max:100, msg: 'Update Firmware...',progressType: ProgressType.normal);
    // await pr!.show();
    Uint8List list = value.buffer.asUint8List(0);
    var upContent = Utils.Uint8ListToHexStr(list);
    print("upContent:${upContent}");
    await _flutterPluginQpos.updatePosFirmware(upContent!, _mAddress!);
  }

  void updatePos(BuildContext context) async {
    DefaultAssetBundle.of(context).load('configs/upgrader.asc').then((value) {
      setState(() {
        _visibility = true;
      });

      operatUpdateProcess(value,context);

      print("点击事件结束");
    });
  }

  void onUpdateButtonSelected(String string, BuildContext context) {
    print("update button:" + string);
    switch (string) {
      case "0":
        Future<ByteData> future =
        DefaultAssetBundle.of(context).load('configs/emv_capk.bin');
        DefaultAssetBundle.of(context)
            .load('configs/emv_app.bin')
            .then((value) {
          Uint8List list = value.buffer.asUint8List(0);
          var emvapp = Utils.Uint8ListToHexStr(list);
          print("emvConfig:${emvapp}");
          future.then((onValue) {
            Uint8List list = onValue.buffer.asUint8List(0);
            var emvcapk = Utils.Uint8ListToHexStr(list);
            print("emvConfig:${emvcapk}");
            _flutterPluginQpos.updateEmvConfig(emvapp!, emvcapk!);
          });
        });
        break;
      case "1":
        updatePos(context);
        break;
      case "2":
        _flutterPluginQpos.doUpdateIPEKOperation(
            0,
            "09118012400705E00000",
            "C22766F7379DD38AA5E1DA8C6AFA75AC",
            "B2DE27F60A443944",
            "09118012400705E00000",
            "C22766F7379DD38AA5E1DA8C6AFA75AC",
            "B2DE27F60A443944",
            "09118012400705E00000",
            "C22766F7379DD38AA5E1DA8C6AFA75AC",
            "B2DE27F60A443944");

        break;
      case "3":
        _flutterPluginQpos.setMasterKey(
            "1A4D672DCA6CB3351FD1B02B237AF9AE", "08D7B4FB629D0885", 0);

        break;
      case "4":
        _flutterPluginQpos.updateWorkKey("1A4D672DCA6CB3351FD1B02B237AF9AE", "08D7B4FB629D0885",
            "1A4D672DCA6CB3351FD1B02B237AF9AE", "08D7B4FB629D0885",
            "1A4D672DCA6CB3351FD1B02B237AF9AE", "08D7B4FB629D0885",
            0);
        break;
      case "5":
        DefaultAssetBundle.of(context).loadString('configs/emv_profile_tlv.xml',cache:false).then((value) {
          print("emvConfig:$value");
          _flutterPluginQpos.updateEMVConfigByXml(value);
        });
        break;
    }
  }

  void onDeviceInfoButtonSelected(String string, BuildContext context) {
    switch (string) {
      case "0":
        _flutterPluginQpos.getQposId();

        // _flutterPluginQpos.setBuzzerStatus(0);
        // _flutterPluginQpos.doSetBuzzerOperation(3);
        // _flutterPluginQpos.setShutDownTime(20);
        // _flutterPluginQpos.setSleepModeTime(10);

        break;
      case "1":
        _flutterPluginQpos.getQposInfo();
        //an example to get track2 without doTrade
        // its callback is onRequestBatchData
        // the return data's format is length+data
        var currentTime = "20211123143010"; //must be yyyyMMddHHmmss
        // _flutterPluginQpos.getTrack2Ciphertext(currentTime);
        // _flutterPluginQpos.getMIccCardData(currentTime);
        break;
      case "2":
        _flutterPluginQpos.getUpdateCheckValue();

        break;
      case "3":
        _flutterPluginQpos.getKeyCheckValue(0,'DUKPT_MKSK_ALLTYPE');

        break;
      case "4":
        _flutterPluginQpos.resetQPosStatus().then((value) =>  setState(() {
          if(value!){
            setState(() {
              display = "pos reset";
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>SecondPage(_flutterPluginQpos)));
            });
          }
        }));
        // bool a = _flutterPluginQpos.resetPosStatus() as bool;
        // if(a) {
        // }
    }
  }

  void onOperateMifareButtonSelected(String string, BuildContext context) {
    var mifareCardOperationType = "ADD";
    switch (string) {
      case "0":
        mifareCardOperationType = "ADD";
        break;
      case "1":
        mifareCardOperationType = "REDUCE";
        break;
      case "2":
        mifareCardOperationType = "RESTORE";
        break;
      default:
        break;
    }
    var blockAddress = _mifareBlockAddrTxt.text;
    var value = _mifareValueTxt.text;
    print("operate address:"+blockAddress+" value:"+value);
    if(blockAddress.length == 0) blockAddress = "0A";
    if(value.length == 0) value = "01";
    _flutterPluginQpos.operateMifareCardData(mifareCardOperationType, blockAddress, value, 20);
  }
  void _showKeyboard(BuildContext context, String parameters) {
    print("_showKeyboard:"+parameters);

    List<String> keyBoardList = new List.empty(growable: true);
    var paras = parameters.split("||");
    String keyMap = paras[0];

    for(int i = 0; i< keyMap.length;i+=2 ){
      String keyValue = keyMap.substring(i,i+2);
      print("POS"+keyValue);
      keyBoardList.add(int.parse(keyValue,radix: 16).toString());
    }

    for(int i=0;i<keyBoardList.length;i++){
      if(keyBoardList[i] == "13"){
        keyBoardList[i] = "cancel";
      }else if(keyBoardList[i] == "14"){
        keyBoardList[i] = "del";
      }
      else if(keyBoardList[i] == "15"){
        keyBoardList[i] = "confirm";
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return CustomKeyboard(
          pwdField: numPinField,
          initEvent: (value) {
            print("pinMapSync:"+value);
             _flutterPluginQpos.pinMapSync(value);
          },
          callback: (keyEvent) {
            if (keyEvent.isClose()) {
              print("POS keyEvent.isClose()");
              Navigator.pop(context);
            }
          },
          keyList: keyBoardList,
          keyHeight: 46,
          autoBack: false,
          onResult: (data) {
            // Fluttertoast.showToast(msg:"POS onResult" + data,
            //     toastLength:Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
            print("POS onResult "+data);
          },
        );
      },
    );
  }

}

  Future simpleDialog(BuildContext context)async{
    print("simpleDialog");
    var result=await showDialog(context: context,
        builder:(context){
          return SimpleDialog(
            title: Text("Transcation Type"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("GOODS"),
                onPressed: (){
                  print("GOODS");
                  Navigator.pop(context,"GOODS");
                },
              ),
              SimpleDialogOption(
                child: Text("SERVICES "),
                onPressed: (){
                  print("SERVICES");
                  Navigator.pop(context,"SERVICES");
                },
              ),
              SimpleDialogOption(
                child: Text("CASH"),
                onPressed: (){
                  print("CASH");
                  Navigator.pop(context,"CASH");
                },
              ),
              SimpleDialogOption(
                child: Text("CASHBACK"),
                onPressed: (){
                  print("CASHBACK");
                  Navigator.pop(context,"CASHBACK");
                },
              ),
              SimpleDialogOption(
                child: Text("INQUIRY"),
                onPressed: (){
                  print("INQUIRY");
                  Navigator.pop(context,"INQUIRY");
                },
              ),
              SimpleDialogOption(
                child: Text("TRANSFER"),
                onPressed: (){
                  print("TRANSFER");
                  Navigator.pop(context,"TRANSFER");
                },
              ),
              SimpleDialogOption(
                child: Text("ADMIN"),
                onPressed: (){
                  print("ADMIN");
                  Navigator.pop(context,"ADMIN");
                },
              ),
              SimpleDialogOption(
                child: Text("CASHDEPOSIT"),
                onPressed: (){
                  print("CASHDEPOSIT");
                  Navigator.pop(context,"CASHDEPOSIT");
                },
              ),
              SimpleDialogOption(
                child: Text("PAYMENT"),
                onPressed: (){
                  print("PAYMENT");
                  Navigator.pop(context,"PAYMENT");
                },
              ),
              SimpleDialogOption(
                child: Text("PBOCLOG||ECQ_INQUIRE_LOG"),
                onPressed: (){
                  print("PBOCLOG||ECQ_INQUIRE_LOG");
                  Navigator.pop(context,"PBOCLOG||ECQ_INQUIRE_LOG");
                },
              ),
              SimpleDialogOption(
                child: Text("SALE"),
                onPressed: (){
                  print("SALE");
                  Navigator.pop(context,"SALE");
                },
              ),
              SimpleDialogOption(
                child: Text("PREAUTH"),
                onPressed: (){
                  print("PREAUTH");
                  Navigator.pop(context,"PREAUTH");
                },
              ),
              SimpleDialogOption(
                child: Text("ECQ_DESIGNATED_LOAD"),
                onPressed: (){
                  print("ECQ_DESIGNATED_LOAD");
                  Navigator.pop(context,"ECQ_DESIGNATED_LOAD");
                },
              ),
              SimpleDialogOption(
                child: Text("ECQ_UNDESIGNATED_LOAD"),
                onPressed: (){
                  print("ECQ_UNDESIGNATED_LOAD");
                  Navigator.pop(context,"ECQ_UNDESIGNATED_LOAD");
                },
              ),
              SimpleDialogOption(
                child: Text("ECQ_CASH_LOAD"),
                onPressed: (){
                  print("ECQ_CASH_LOAD");
                  Navigator.pop(context,"ECQ_CASH_LOAD");
                },
              ),
              SimpleDialogOption(
                child: Text("ECQ_CASH_LOAD_VOID"),
                onPressed: (){
                  print("ECQ_CASH_LOAD_VOID");
                  Navigator.pop(context,"ECQ_CASH_LOAD_VOID");
                },
              ),
              SimpleDialogOption(
                child: Text("CHANGE_PIN"),
                onPressed: (){
                  print("CHANGE_PIN");
                  Navigator.pop(context,"CHANGE_PIN");
                },
              ),
              SimpleDialogOption(
                child: Text("REFOUND"),
                onPressed: (){
                  print("REFOUND");
                  Navigator.pop(context,"REFOUND");
                },
              ),
              SimpleDialogOption(
                child: Text("SALES_NEW"),
                onPressed: (){
                  print("SALES_NEW");
                  Navigator.pop(context,"SALES_NEW");
                },
              ),
            ],
          );
        }
    );
    print("result --- > "+result);
    return result;
  }


// class SecondPage extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(title: Text('The second page'),),
//       body: Center(child: RaisedButton(
//         child: Text('Return'),
//         onPressed: (){
//           Navigator.pop(context);
//         },
//       ),),
//     );
//   }
//
// }