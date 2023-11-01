#import "FlutterPluginQposPlugin.h"

@interface FlutterPluginQposPlugin()
@property (nonatomic, strong)FlutterEventChannel *eventChannel;
@property (nonatomic, strong)FlutterEventSink eventSink;
@property (nonatomic,copy)NSString *terminalTime;
@property (nonatomic,copy)NSString *currencyCode;
@property(nonatomic,strong)QPOSService *mPos;
@property(nonatomic,strong)BTDeviceFinder *bt;
@property (nonatomic,assign)BOOL updateFWFlag;
@property (nonatomic,copy)NSString *inputAmount;
@property (nonatomic,copy)NSString *cashbackAmount;
@property (nonatomic,copy)NSString *bluetoothAddress;
@end

@implementation FlutterPluginQposPlugin{
    NSMutableArray *allBluetooth;
    NSString *btAddress;
    TransactionType mTransType;
    PosType     mPosType;
    dispatch_queue_t self_queue;
    NSString *msgStr;
    NSTimer* appearTimer;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_plugin_pos"
            binaryMessenger:[registrar messenger]];
  FlutterPluginQposPlugin* instance = [[FlutterPluginQposPlugin alloc] init];
  FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"flutter_plugin_pos_event" binaryMessenger:[registrar messenger]];
  [eventChannel setStreamHandler:instance];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPosSdkVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if ([@"initPos" isEqualToString:call.method]) {
      [self initPos];
  } else if ([@"connectBluetoothDevice" isEqualToString:call.method]) {
      NSString *bluetoothName = [call.arguments objectForKey:@"bluetooth_addr"];
      self.bluetoothAddress = bluetoothName;
      [self.mPos connectBT:bluetoothName];
  } else if ([@"getQposId" isEqualToString:call.method]) {
      [self.mPos getQPosId];
  } else if ([@"getQposInfo" isEqualToString:call.method]) {
      [self.mPos getQPosInfo];
  } else if ([@"resetQPosStatus" isEqualToString:call.method]) {
      BOOL isSuccess = [self.mPos resetPosStatus];
      result(@(isSuccess));
  } else if ([@"getUpdateCheckValue" isEqualToString:call.method]) {
      [self.mPos getUpdateCheckValueBlock:^(BOOL isSuccess, NSString *stateStr) {
          [self sendMessage:@"onRequestUpdateKey" result:stateStr];
      }];
  } else if ([@"getKeyCheckValue" isEqualToString:call.method]) {
      [self.mPos getKeyCheckValue:DUKPT_MKSK_ALLTYPE keyIndex:0];
  } else if ([@"disconnectBT" isEqualToString:call.method]) {
      [self.mPos disconnectBT];
  } else if ([@"doTrade" isEqualToString:call.method]) {
      [self doTrade];
  } else if ([@"setAmount" isEqualToString:call.method]) {
      NSString *amount = [call.arguments objectForKey:@"amount"];
      NSString *cashbackAmount = [call.arguments objectForKey:@"cashbackAmount"];
      NSString *currencyCode = [call.arguments objectForKey:@"currencyCode"];
      NSInteger transactionType = [[call.arguments objectForKey:@"transactionType"] integerValue];
      self.inputAmount = amount;
      [self.mPos setAmount:amount aAmountDescribe:cashbackAmount currency:currencyCode transactionType:transactionType];
  } else if ([@"doEmvApp" isEqualToString:call.method]) {
      [self.mPos doEmvApp:EmvOption_START];
  } else if ([@"sendTime" isEqualToString:call.method]) {
      NSString *terminalTime = [call.arguments objectForKey:@"terminalTime"];
      [self.mPos sendTime:terminalTime];
  } else if ([@"getNFCBatchData" isEqualToString:call.method]) {
      NSDictionary *mDic = [self.mPos getNFCBatchData];
      result(mDic);
  } else if ([@"sendPin" isEqualToString:call.method]) {
      NSString *pinContent = [call.arguments objectForKey:@"pinContent"];
      [self.mPos sendPinEntryResult:pinContent];
  }else if ([@"selectEmvApp" isEqualToString:call.method]) {
      NSInteger position = [[call.arguments objectForKey:@"position"] integerValue];
      [self.mPos selectEmvApp:position];
  }else if ([@"sendOnlineProcessResult" isEqualToString:call.method]) {
      NSString *onlineProcessResult = [call.arguments objectForKey:@"onlineProcessResult"];
      [self.mPos sendOnlineProcessResult:onlineProcessResult];
  }else if ([@"stopScanQPos2Mode" isEqualToString:call.method]) {
      [self.bt stopQPos2Mode];
  }else if ([@"scanQPos2Mode" isEqualToString:call.method]) {
      NSInteger scanTime = [[call.arguments objectForKey:@"scanTime"] integerValue];
      [self scanBluetooth:scanTime];
  }else if ([@"doUpdateIPEKOperation" isEqualToString:call.method]) {
      NSString *keyIndex = [call.arguments objectForKey:@"keyIndex"];
      NSString *trackksn = [call.arguments objectForKey:@"trackksn"];
      NSString *trackipek = [call.arguments objectForKey:@"trackipek"];
      NSString *trackipekCheckvalue = [call.arguments objectForKey:@"trackipekCheckvalue"];
      NSString *emvksn = [call.arguments objectForKey:@"emvksn"];
      NSString *emvipek = [call.arguments objectForKey:@"emvipek"];
      NSString *emvipekCheckvalue = [call.arguments objectForKey:@"emvipekCheckvalue"];
      NSString *pinksn = [call.arguments objectForKey:@"pinksn"];
      NSString *pinipek = [call.arguments objectForKey:@"pinipek"];
      NSString *pinipekCheckvalue = [call.arguments objectForKey:@"pinipekCheckvalue"];
      if(keyIndex.length == 1){
          keyIndex = [@"0" stringByAppendingString:keyIndex];
      }
      [self.mPos doUpdateIPEKOperation:keyIndex tracksn:trackksn trackipek:trackipek trackipekCheckValue:trackipekCheckvalue emvksn:emvksn emvipek:emvipek emvipekcheckvalue:emvipekCheckvalue pinksn:pinksn pinipek:pinipek pinipekcheckValue:pinipekCheckvalue block:^(BOOL isSuccess, NSString *stateStr) {
          [self sendMessage:@"onReturnUpdateIPEKResult" result:isSuccess];
      }];
  }else if ([@"setMasterKey" isEqualToString:call.method]) {
      NSString *key = [call.arguments objectForKey:@"key"];
      NSString *checkValue = [call.arguments objectForKey:@"checkValue"];
      NSInteger keyIndex = [[call.arguments objectForKey:@"keyIndex"] integerValue];
      [self.mPos setMasterKey:key checkValue:checkValue keyIndex:keyIndex];
  }else if ([@"updatePosFirmware" isEqualToString:call.method]) {
      NSString *firmwareStr = [call.arguments objectForKey:@"upContent"];
      NSString *bTName = [call.arguments objectForKey:@"address"];
      [self updatePosFirmware:firmwareStr btName:bTName];
  }else if ([@"updateWorkKey" isEqualToString:call.method]) {
      NSString *pik = [call.arguments objectForKey:@"pik"];
      NSString *pikCheck = [call.arguments objectForKey:@"pikCheck"];
      NSString *trk = [call.arguments objectForKey:@"trk"];
      NSString *trkCheck = [call.arguments objectForKey:@"trkCheck"];
      NSString *mak = [call.arguments objectForKey:@"mak"];
      NSString *makCheck = [call.arguments objectForKey:@"makCheck"];
      NSInteger keyIndex = [[call.arguments objectForKey:@"keyIndex"] integerValue];
      [self.mPos udpateWorkKey:pik pinKeyCheck:pikCheck trackKey:trk trackKeyCheck:trkCheck macKey:mak macKeyCheck:makCheck keyIndex:keyIndex];
  }else if ([@"anlysEmvIccData" isEqualToString:call.method]) {
      NSString *tlv = [call.arguments objectForKey:@"tlv"];
      NSDictionary * dict = [self.mPos anlysEmvIccData:tlv];
      result(dict);
  }else if ([@"setBuzzerStatus" isEqualToString:call.method]) {
      NSInteger status = [[call.arguments objectForKey:@"status"] integerValue];
      [self.mPos setBuzzerStatus:status];
  }else if ([@"doSetBuzzerOperation" isEqualToString:call.method]) {
      NSInteger times = [[call.arguments objectForKey:@"times"] integerValue];
      [self.mPos doSetBuzzerOperation:times block:^(BOOL isSuccess, NSString *stateStr) {
          [self sendMessage:@"onSetBuzzerResult" result:isSuccess];
      }];
  }else if ([@"pollOnMifareCard" isEqualToString:call.method]) {
      NSInteger timeout = [[call.arguments objectForKey:@"timeout"] integerValue];
      [self.mPos pollOnMifareCard:timeout dataBlock:^(NSDictionary *dict) {
          [self sendMessage:@"onSearchMifareCardResult" parameter:[self convertToJsonData:dict]];
      }];
  }else if ([@"authenticateMifareCard" isEqualToString:call.method]) {
      NSString *mifareCardType = [call.arguments objectForKey:@"MifareCardType"];
      NSString *keyType = [call.arguments objectForKey:@"keyType"];
      NSString *block = [call.arguments objectForKey:@"block"];
      NSString *keyValue = [call.arguments objectForKey:@"keyValue"];
      NSInteger timeout = [[call.arguments objectForKey:@"timeout"] integerValue];
      MifareCardType cardType = MifareCardType_CLASSIC;
      if ([@"CLASSIC" isEqualToString:mifareCardType]) {
          cardType = MifareCardType_CLASSIC;
      }else if ([@"ULTRALIGHT" isEqualToString:mifareCardType]){
          cardType = MifareCardType_ULTRALIGHT;
      }
      MifareKeyType type = MifareKeyType_KEY_A;
      if ([@"Key A" isEqualToString:keyType]) {
          type = MifareKeyType_KEY_A;
      }else if ([@"Key B" isEqualToString:keyType]){
          type = MifareKeyType_KEY_B;
      }
      [self.mPos authenticateMifareCard:cardType keyType:type block:block keyValue:keyValue timeout:timeout resultBlock:^(BOOL isSuccess) {
          [self sendMessage:@"onVerifyMifareCardResult" result:isSuccess];
      }];
  }else if ([@"operateMifareCardData" isEqualToString:call.method]) {
      NSString *mifareCardOperationType = [call.arguments objectForKey:@"mifareCardOperationType"];
      NSString *block = [call.arguments objectForKey:@"block"];
      NSString *data = [call.arguments objectForKey:@"data"];
      NSInteger timeout = [[call.arguments objectForKey:@"timeout"] integerValue];
      MifareCardOperationType type = MifareCardOperationType_ADD;
      if ([@"ADD" isEqualToString:mifareCardOperationType]) {
          type = MifareCardOperationType_ADD;
      }else if ([@"REDUCE" isEqualToString:mifareCardOperationType]){
          type = MifareCardOperationType_REDUCE;
      }else if ([@"RESTORE" isEqualToString:mifareCardOperationType]){
          type = MifareCardOperationType_RESTORE;
      }
      [self.mPos operateMifareCardData:type block:block data:data timeout:timeout dataBlock:^(NSDictionary *dict) {
          [self sendMessage:@"onOperateMifareCardResult" parameter:[self convertToJsonData:dict]];
      }];
  }else if ([@"readMifareCard" isEqualToString:call.method]) {
      NSString *mifareCardType = [call.arguments objectForKey:@"MifareCardType"];
      NSString *block = [call.arguments objectForKey:@"block"];
      NSInteger timeout = [[call.arguments objectForKey:@"timeout"] integerValue];
      MifareCardType cardType = MifareCardType_CLASSIC;
      if ([@"CLASSIC" isEqualToString:mifareCardType]) {
          cardType = MifareCardType_CLASSIC;
      }else if ([@"ULTRALIGHT" isEqualToString:mifareCardType]){
          cardType = MifareCardType_ULTRALIGHT;
      }
      [self.mPos readMifareCard:cardType block:block timeout:timeout dataBlock:^(NSDictionary *dict) {
          [self sendMessage:@"onReadMifareCardResult" parameter:[self convertToJsonData:dict]];
      }];
  }else if ([@"writeMifareCard" isEqualToString:call.method]) {
      NSString *mifareCardType = [call.arguments objectForKey:@"MifareCardType"];
      NSString *block = [call.arguments objectForKey:@"block"];
      NSString *data = [call.arguments objectForKey:@"data"];
      NSInteger timeout = [[call.arguments objectForKey:@"timeout"] integerValue];
      MifareCardType cardType = MifareCardType_CLASSIC;
      if ([@"CLASSIC" isEqualToString:mifareCardType]) {
          cardType = MifareCardType_CLASSIC;
      }else if ([@"ULTRALIGHT" isEqualToString:mifareCardType]){
          cardType = MifareCardType_ULTRALIGHT;
      }
      [self.mPos writeMifareCard:cardType block:block data:data timeout:timeout resultBlock:^(BOOL isSuccess) {
          [self sendMessage:@"onWriteMifareCardResult" result:isSuccess];
      }];
  }else if ([@"finishMifareCard" isEqualToString:call.method]) {
      NSInteger timeout = [[call.arguments objectForKey:@"timeout"] integerValue];
      [self.mPos finishMifareCard:timeout resultBlock:^(BOOL isSuccess) {
          [self sendMessage:@"onFinishMifareCardResult" result:isSuccess];
      }];
  }else if ([@"setSleepModeTime" isEqualToString:call.method]) {
      NSString *timeout = [[call.arguments objectForKey:@"time"] stringValue];
      [self.mPos doSetSleepModeTime:timeout block:^(BOOL isSuccess, NSString *stateStr) {
          [self sendMessage:@"onSetSleepModeTime" result:isSuccess];
      }];
  }else if ([@"setShutDownTime" isEqualToString:call.method]) {
      NSString *timeout = [[call.arguments objectForKey:@"time"] stringValue];
      [self.mPos doSetShutDownTime:timeout];
  }else if ([@"setIsOperateMifare" isEqualToString:call.method]) {
      BOOL isOperateMifare = [[call.arguments objectForKey:@"isOperateMifare"] integerValue];
      [self.mPos setIsOperateMifare:isOperateMifare];
  }else if ([@"setFormatId" isEqualToString:call.method]) {
      NSString *formatId = [call.arguments objectForKey:@"formatId"];
      if([@"DUKPT" isEqualToString:formatId]){
          formatId = @"0000";
      }else if([@"MKSK" isEqualToString:formatId]){
          formatId = @"0002";
      }
      [self.mPos setFormatID:formatId];
  }else if ([@"updateEMVConfigByXml" isEqualToString:call.method]) {
      NSString *xmlStr = [call.arguments objectForKey:@"xmlContent"];
      [self.mPos updateEMVConfigByXml:xmlStr];
  }else if ([@"setCardTradeMode" isEqualToString:call.method]) {
      NSString *cardTradeMode = [call.arguments objectForKey:@"cardTradeMode"];
      [self.mPos setCardTradeMode:[self convertCardTradeModeStrToEnum:cardTradeMode]];
  }else if ([@"setDoTradeMode" isEqualToString:call.method]) {
      NSString *doTradeMode = [call.arguments objectForKey:@"doTradeMode"];
      [self.mPos setDoTradeMode:[self convertDoTradeModeStrToEnum:doTradeMode]];
  }else if ([@"getUpdateProgress" isEqualToString:call.method]) {
      result([NSNumber numberWithInteger:[self.mPos getUpdateProgress]]);
  }else {
      result(FlutterMethodNotImplemented);
  }
}

- (void)sendMessage:(NSString *)methodName parameter:(NSString *)parameter{
    if(self.eventSink != nil){
        self.eventSink([self convertToJsonData:@{@"method":methodName,@"parameters":parameter}]);
    }
}

- (void)sendMessage:(NSString *)methodName result:(BOOL)result{
    if(self.eventSink != nil){
        self.eventSink([self convertToJsonData:@{@"method":methodName,@"parameters":[NSString stringWithFormat:@"%d",result]}]);
    }
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    self.eventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    self.eventSink = events;
    return nil;
}

-(void)initPos{
    if (_mPos == nil) {
        _mPos = [QPOSService sharedInstance];
    }
    [_mPos setDelegate:self];
    [_mPos setQueue:nil];
    [_mPos setBTAutoDetecting:true];
    [_mPos setPosType:PosType_BLUETOOTH_2mode];
    if (_bt== nil) {
        _bt = [[BTDeviceFinder alloc]init];
    }
    allBluetooth = [[NSMutableArray alloc]init];
}

-(void) onQposIdResult: (NSDictionary*)posId{
    NSString *aStr = [@"posId:" stringByAppendingString:posId[@"posId"]];
    
    NSString *temp = [@"psamId:" stringByAppendingString:posId[@"psamId"]];
    aStr = [aStr stringByAppendingString:@"\n"];
    aStr = [aStr stringByAppendingString:temp];
    
    temp = [@"merchantId:" stringByAppendingString:posId[@"merchantId"]];
    aStr = [aStr stringByAppendingString:@"\n"];
    aStr = [aStr stringByAppendingString:temp];
    
    temp = [@"vendorCode:" stringByAppendingString:posId[@"vendorCode"]];
    aStr = [aStr stringByAppendingString:@"\n"];
    aStr = [aStr stringByAppendingString:temp];
    
    temp = [@"deviceNumber:" stringByAppendingString:posId[@"deviceNumber"]];
    aStr = [aStr stringByAppendingString:@"\n"];
    aStr = [aStr stringByAppendingString:temp];
    
    temp = [@"psamNo:" stringByAppendingString:posId[@"psamNo"]];
    aStr = [aStr stringByAppendingString:@"\n"];
    aStr = [aStr stringByAppendingString:temp];
    
    [self sendMessage:@"onQposIdResult" parameter:aStr];
}

-(void) onQposInfoResult: (NSDictionary*)posInfoData{
    NSString *aStr = @"ModelInfo: ";
    aStr = [aStr stringByAppendingString:posInfoData[@"ModelInfo"]];
    
    aStr = [aStr stringByAppendingString:@"\n"];
    aStr = [aStr stringByAppendingString:@"PCIHardwareVersion: "];
    aStr = [aStr stringByAppendingString:posInfoData[@"PCIHardwareVersion"]];
    
    aStr = [aStr stringByAppendingString:@"\n"];
    aStr = [aStr stringByAppendingString:@"SUB: "];
    aStr = [aStr stringByAppendingString:posInfoData[@"SUB"]];
    
    aStr = [aStr stringByAppendingString:@"\n"];
    aStr = [aStr stringByAppendingString:@"bootloaderVersion: "];
    aStr = [aStr stringByAppendingString:posInfoData[@"bootloaderVersion"]];
    
    aStr = [aStr stringByAppendingString:@"\n"];
    aStr = [aStr stringByAppendingString:@"Firmware Version: "];
    aStr = [aStr stringByAppendingString:posInfoData[@"firmwareVersion"]];
    
    aStr = [aStr stringByAppendingString:@"\n"];
    aStr = [aStr stringByAppendingString:@"Hardware Version: "];
    aStr = [aStr stringByAppendingString:posInfoData[@"hardwareVersion"]];
    
    NSString *batteryPercentage = posInfoData[@"batteryPercentage"];
    if (batteryPercentage==nil || [@"" isEqualToString:batteryPercentage]) {
        aStr = [aStr stringByAppendingString:@"\n"];
        aStr = [aStr stringByAppendingString:@"Battery Level: "];
        aStr = [aStr stringByAppendingString:posInfoData[@"batteryLevel"]];
    }else{
        aStr = [aStr stringByAppendingString:@"\n"];
        aStr = [aStr stringByAppendingString:@"Battery Percentage: "];
        aStr = [aStr stringByAppendingString:posInfoData[@"batteryPercentage"]];
    }
    aStr = [aStr stringByAppendingString:@"\n"];
    aStr = [aStr stringByAppendingString:@"Charge: "];
    aStr = [aStr stringByAppendingString:posInfoData[@"isCharging"]];
    
    aStr = [aStr stringByAppendingString:@"\n"];
    aStr = [aStr stringByAppendingString:@"USB: "];
    aStr = [aStr stringByAppendingString:posInfoData[@"isUsbConnected"]];
    
    aStr = [aStr stringByAppendingString:@"\n"];
    aStr = [aStr stringByAppendingString:@"Track 1 Supported: "];
    aStr = [aStr stringByAppendingString:posInfoData[@"isSupportedTrack1"]];
    
    aStr = [aStr stringByAppendingString:@"\n"];
    aStr = [aStr stringByAppendingString:@"Track 2 Supported: "];
    aStr = [aStr stringByAppendingString:posInfoData[@"isSupportedTrack2"]];
    aStr = [aStr stringByAppendingString:@"\n"];
    aStr = [aStr stringByAppendingString:@"Track 3 Supported: "];
    aStr = [aStr stringByAppendingString:posInfoData[@"isSupportedTrack3"]];
    aStr = [aStr stringByAppendingString:@"\n"];
    aStr = [aStr stringByAppendingString:@"updateWorkKeyFlag: "];
    aStr = [aStr stringByAppendingString:posInfoData[@"updateWorkKeyFlag"]];
    NSString *posinfo = aStr;
    [self sendMessage:@"onQposInfoResult" parameter:posinfo];
}

-(void)scanBluetooth:(NSInteger)scanTime{
    NSInteger delay = 0;
    [self.bt setBluetoothDelegate2Mode:self];
    if ([self.bt getCBCentralManagerState] == CBCentralManagerStateUnknown) {
            while ([self.bt getCBCentralManagerState]!= CBCentralManagerStatePoweredOn) {
                //NSLog(@"Bluetooth state is not power on");
                [self sleepMs:10];
                if(delay++==10){
                    return;
                }
            }
        }
        [self.bt scanQPos2Mode:scanTime];
}

-(void) sleepMs: (NSInteger)msec {
    NSTimeInterval sec = (msec / 1000.0f);
    [NSThread sleepForTimeInterval:sec];
}

-(void)onBluetoothName2Mode:(NSString *)bluetoothName{
    if (bluetoothName != nil && ![bluetoothName isEqualToString:@""]) {
        if (![allBluetooth containsObject:bluetoothName]) {
            [allBluetooth addObject:bluetoothName];
            NSString *temp = [NSString stringWithFormat:@"%@//%@",bluetoothName,bluetoothName];
            [self sendMessage:@"onDeviceFound" parameter:temp];
        }
    }
}

-(void)finishScanQPos2Mode{
    [self sendMessage:@"onRequestDeviceScanFinished" parameter:@""];
}

-(void)bluetoothIsPowerOff2Mode{
    [self sendMessage:@"bluetoothIsPowerOff2Mode" parameter:@""];
}

-(void)bluetoothIsPowerOn2Mode{
    [self sendMessage:@"bluetoothIsPowerOn2Mode" parameter:@""];
}

-(void)doTrade{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    self.terminalTime = [dateFormatter stringFromDate:[NSDate date]];
    mTransType = TransactionType_GOODS;
    _currencyCode = @"156";
    [self.mPos doTrade:30];
}

-(void) onRequestSetAmount{
    [self sendMessage:@"onRequestSetAmount" parameter:@""];
}

-(void) onRequestWaitingUser{
    NSString *displayStr  =@"Please insert/swipe/tap card now.";
    [self sendMessage:@"onRequestWaitingUser" parameter:displayStr];
}

//callback of input pin on phone
-(void) onRequestPinEntry{
    //NSLog(@"onRequestPinEntry");
    [self sendMessage:@"onRequestSetPin" parameter:@""];
}

-(void) onDHError: (DHError)errorState{
    NSString *msg = @"";
    if(errorState ==DHError_TIMEOUT) {
        msg = @"Pos no response";
    } else if(errorState == DHError_DEVICE_RESET) {
        msg = @"Pos reset";
    } else if(errorState == DHError_UNKNOWN) {
        msg = @"Unknown error";
    } else if(errorState == DHError_DEVICE_BUSY) {
        msg = @"Pos Busy";
    } else if(errorState == DHError_INPUT_OUT_OF_RANGE) {
        msg = @"Input out of range.";
    } else if(errorState == DHError_INPUT_INVALID_FORMAT) {
        msg = @"Input invalid format.";
    } else if(errorState == DHError_INPUT_ZERO_VALUES) {
        msg = @"Input are zero values.";
    } else if(errorState == DHError_INPUT_INVALID) {
        msg = @"Input invalid.";
    } else if(errorState == DHError_CASHBACK_NOT_SUPPORTED) {
        msg = @"Cashback not supported.";
    } else if(errorState == DHError_CRC_ERROR) {
        msg = @"CRC Error.";
    } else if(errorState == DHError_COMM_ERROR) {
        msg = @"Communication Error.";
    }else if(errorState == DHError_MAC_ERROR){
        msg = @"MAC Error.";
    }else if(errorState == DHError_CMD_TIMEOUT){
        msg = @"CMD Timeout.";
    }else if(errorState == DHError_AMOUNT_OUT_OF_LIMIT){
        msg = @"Amount out of limit.";
    }
    NSString *error = msg;
    [self sendMessage:@"onError" parameter:error];
}

//开始执行start 按钮后返回的结果状态
-(void) onDoTradeResult: (DoTradeResult)result DecodeData:(NSDictionary*)decodeData{
    NSString *display = @"";
    if (result == DoTradeResult_NONE) {
        display = @"No card detected. Please insert or swipe card again and press check card.";
        [self sendMessage:@"onDoTradeResult" parameter:[NSString stringWithFormat:@"NONE||%@",display]];
    }else if (result==DoTradeResult_ICC) {
        display = @"ICC Card Inserted";
        [self sendMessage:@"onDoTradeResult" parameter:[NSString stringWithFormat:@"ICC||%@",display]];
    }else if(result==DoTradeResult_NOT_ICC){
        display = @"Card Inserted (Not ICC)";
        [self sendMessage:@"onDoTradeResult" parameter:[NSString stringWithFormat:@"NOT_ICC||%@",display]];
    }else if(result==DoTradeResult_MCR){
        //NSLog(@"decodeData: %@",decodeData);
        NSString *formatID = [NSString stringWithFormat:@"Format ID: %@\n",decodeData[@"formatID"]] ;
        NSString *maskedPAN = [NSString stringWithFormat:@"Masked PAN: %@\n",decodeData[@"maskedPAN"]];
        NSString *expiryDate = [NSString stringWithFormat:@"Expiry Date: %@\n",decodeData[@"expiryDate"]];
        NSString *cardHolderName = [NSString stringWithFormat:@"Cardholder Name: %@\n",decodeData[@"cardholderName"]];
        NSString *serviceCode = [NSString stringWithFormat:@"Service Code: %@\n",decodeData[@"serviceCode"]];
        NSString *encTrack1 = [NSString stringWithFormat:@"Encrypted Track 1: %@\n",decodeData[@"encTrack1"]];
        NSString *encTrack2 = [NSString stringWithFormat:@"Encrypted Track 2: %@\n",decodeData[@"encTrack2"]];
        NSString *encTrack3 = [NSString stringWithFormat:@"Encrypted Track 3: %@\n",decodeData[@"encTrack3"]];
        NSString *pinKsn = [NSString stringWithFormat:@"PIN KSN: %@\n",decodeData[@"pinKsn"]];
        NSString *trackksn = [NSString stringWithFormat:@"Track KSN: %@\n",decodeData[@"trackksn"]];
        NSString *pinBlock = [NSString stringWithFormat:@"pinBlock: %@\n",decodeData[@"pinblock"]];
        NSString *encPAN = [NSString stringWithFormat:@"encPAN: %@\n",decodeData[@"encPAN"]];
        NSString *msg = [NSString stringWithFormat:@"Card Swiped:\n"];
        msg = [msg stringByAppendingString:formatID];
        msg = [msg stringByAppendingString:maskedPAN];
        msg = [msg stringByAppendingString:expiryDate];
        msg = [msg stringByAppendingString:cardHolderName];
        msg = [msg stringByAppendingString:pinKsn];
        msg = [msg stringByAppendingString:trackksn];
        msg = [msg stringByAppendingString:serviceCode];
        msg = [msg stringByAppendingString:encTrack1];
        msg = [msg stringByAppendingString:encTrack2];
        msg = [msg stringByAppendingString:encTrack3];
        msg = [msg stringByAppendingString:pinBlock];
        msg = [msg stringByAppendingString:encPAN];
        display = msg;
        self.inputAmount = @"";
        [self sendMessage:@"onDoTradeResult" parameter:[NSString stringWithFormat:@"MSR||%@",display]];
    }else if(result==DoTradeResult_NFC_OFFLINE || result == DoTradeResult_NFC_ONLINE){
        //NSLog(@"decodeData: %@",decodeData);
        NSString *formatID = [NSString stringWithFormat:@"Format ID: %@\n",decodeData[@"formatID"]] ;
        NSString *maskedPAN = [NSString stringWithFormat:@"Masked PAN: %@\n",decodeData[@"maskedPAN"]];
        NSString *expiryDate = [NSString stringWithFormat:@"Expiry Date: %@\n",decodeData[@"expiryDate"]];
        NSString *cardHolderName = [NSString stringWithFormat:@"Cardholder Name: %@\n",decodeData[@"cardholderName"]];
        NSString *serviceCode = [NSString stringWithFormat:@"Service Code: %@\n",decodeData[@"serviceCode"]];
        NSString *encTrack1 = [NSString stringWithFormat:@"Encrypted Track 1: %@\n",decodeData[@"encTrack1"]];
        NSString *encTrack2 = [NSString stringWithFormat:@"Encrypted Track 2: %@\n",decodeData[@"encTrack2"]];
        NSString *encTrack3 = [NSString stringWithFormat:@"Encrypted Track 3: %@\n",decodeData[@"encTrack3"]];
        NSString *pinKsn = [NSString stringWithFormat:@"PIN KSN: %@\n",decodeData[@"pinKsn"]];
        NSString *trackksn = [NSString stringWithFormat:@"Track KSN: %@\n",decodeData[@"trackksn"]];
        NSString *pinBlock = [NSString stringWithFormat:@"pinBlock: %@\n",decodeData[@"pinblock"]];
        NSString *encPAN = [NSString stringWithFormat:@"encPAN: %@\n",decodeData[@"encPAN"]];
        NSString *msg = [NSString stringWithFormat:@"Tap Card:\n"];
        msg = [msg stringByAppendingString:formatID];
        msg = [msg stringByAppendingString:maskedPAN];
        msg = [msg stringByAppendingString:expiryDate];
        msg = [msg stringByAppendingString:cardHolderName];
        msg = [msg stringByAppendingString:pinKsn];
        msg = [msg stringByAppendingString:trackksn];
        msg = [msg stringByAppendingString:serviceCode];
        msg = [msg stringByAppendingString:encTrack1];
        msg = [msg stringByAppendingString:encTrack2];
        msg = [msg stringByAppendingString:encTrack3];
        msg = [msg stringByAppendingString:pinBlock];
        msg = [msg stringByAppendingString:encPAN];
        NSString *str = @"";
        if(result == DoTradeResult_NFC_ONLINE){
            str = @"NFC_ONLINE";
        }else if(result == DoTradeResult_NFC_OFFLINE){
            str = @"NFC_OFFLINE";
        }
        [self sendMessage:@"onDoTradeResult" parameter:[NSString stringWithFormat:@"%@||%@",str,msg]];
    }else if(result==DoTradeResult_NFC_DECLINED){
        NSString *displayStr = @"Tap Card Declined";
        [self sendMessage:@"onDoTradeResult" parameter:[NSString stringWithFormat:@"NFC_DECLINED||%@",displayStr]];
    }else if (result==DoTradeResult_NO_RESPONSE){
        NSString *displayStr = @"Check card no response";
        [self sendMessage:@"onDoTradeResult" parameter:[NSString stringWithFormat:@"NO_RESPONSE||%@",displayStr]];
    }else if(result==DoTradeResult_BAD_SWIPE){
        NSString *displayStr = @"Bad Swipe. \nPlease swipe again and press check card.";
        [self sendMessage:@"onDoTradeResult" parameter:[NSString stringWithFormat:@"BAD_SWIPE||%@",displayStr]];
    }else if(result==DoTradeResult_NO_UPDATE_WORK_KEY){
        NSString *displayStr = @"device not update work key";
        [self sendMessage:@"onDoTradeResult" parameter:[NSString stringWithFormat:@"NO_UPDATE_WORK_KEY||%@",displayStr]];
    }
}

-(void) onRequestSelectEmvApp: (NSArray*)appList{
    NSMutableString *muStr = [NSMutableString string];
    for (int i=0 ; i<[appList count] ; i++){
        NSString *emvApp = [appList objectAtIndex:i];
        [muStr appendString:emvApp];
    }
    [self sendMessage:@"onRequestSelectEmvApp" parameter:muStr];
}

-(void) onRequestFinalConfirm{
    //NSLog(@"onRequestFinalConfirm-------amount = %@",self.inputAmount);
    msgStr = @"Confirm amount";
}

-(void) onRequestTime{
    [self sendMessage:@"onRequestTime" parameter:@""];
}

-(void) onRequestOnlineProcess: (NSString*) tlv{
    //NSLog(@"onRequestOnlineProcess = %@",[[QPOSService sharedInstance] anlysEmvIccData:tlv]);
    NSString *displayStr = [@"onRequestOnlineProcess: " stringByAppendingString:tlv];
    msgStr = @"Request data to server.";
    [self sendMessage:@"onRequestOnlineProcess" parameter: displayStr];
}

-(void) onRequestTransactionResult: (TransactionResult)transactionResult{
    NSString *messageTextView = @"";
    if (transactionResult==TransactionResult_APPROVED) {
        messageTextView = @"Approved";
    }else if(transactionResult == TransactionResult_TERMINATED) {
        messageTextView = @"Terminated";
    } else if(transactionResult == TransactionResult_DECLINED) {
        messageTextView = @"Declined";
    } else if(transactionResult == TransactionResult_CANCEL) {
        messageTextView = @"Cancel";
    } else if(transactionResult == TransactionResult_CAPK_FAIL) {
        messageTextView = @"CAPK fail";
    } else if(transactionResult == TransactionResult_NOT_ICC) {
        messageTextView = @"Not ICC card";
    } else if(transactionResult == TransactionResult_SELECT_APP_FAIL) {
        messageTextView = @"App fail";
    } else if(transactionResult == TransactionResult_DEVICE_ERROR) {
        messageTextView = @"Pos Error";
    } else if(transactionResult == TransactionResult_CARD_NOT_SUPPORTED) {
        messageTextView = @"Card not support";
    } else if(transactionResult == TransactionResult_MISSING_MANDATORY_DATA) {
        messageTextView = @"Missing mandatory data";
    } else if(transactionResult == TransactionResult_CARD_BLOCKED_OR_NO_EMV_APPS) {
        messageTextView = @"Card blocked or no EMV apps";
    } else if(transactionResult == TransactionResult_INVALID_ICC_DATA) {
        messageTextView = @"Invalid ICC data";
    }else if(transactionResult == TransactionResult_NFC_TERMINATED) {
        messageTextView = @"NFC Terminated";
    }
    self.inputAmount = @"";
    self.cashbackAmount = @"";
    [self sendMessage:@"onRequestTransactionResult" parameter:messageTextView];
}

-(void) onRequestBatchData: (NSString*)tlv{
    tlv = [@"batch data: " stringByAppendingString:tlv];
    NSString *displayStr = tlv;
    [self sendMessage:@"onRequestBatchData" parameter:displayStr];
}

-(void) onReturnReversalData: (NSString*)tlv{
    tlv = [@"reversal data: " stringByAppendingString:tlv];
    NSString *displayStr = tlv;
    [self sendMessage:@"onReturnReversalData" parameter:displayStr];
}

//pos 连接成功的回调
-(void) onRequestQposConnected{
    NSString *displayStr =@"";
    if ([self.bluetoothAddress  isEqual: @"audioType"]) {
        displayStr = @"AudioType connected.";
    }else{
        displayStr = @"Bluetooth connected.";
    }
    [self.bt stopQPos2Mode];
    [self sendMessage:@"onRequestQposConnected" parameter:@""];
}

-(void) onRequestQposDisconnected{
    [self sendMessage:@"onRequestQposDisconnected" parameter:@""];
}

-(void) onRequestNoQposDetected{
    [self sendMessage:@"onRequestNoQposDetected" parameter:@""];
}

-(void) onRequestDisplay: (Display)displayMsg{
    NSString *msg = @"";
    if (displayMsg==Display_CLEAR_DISPLAY_MSG) {
        msg = @"";
    }else if(displayMsg==Display_PLEASE_WAIT){
        msg = @"Please wait...";
    }else if(displayMsg==Display_REMOVE_CARD){
        msg = @"Please remove card";
    }else if (displayMsg==Display_TRY_ANOTHER_INTERFACE){
        msg = @"Please try another interface";
    }else if (displayMsg == Display_TRANSACTION_TERMINATED){
        msg = @"Terminated";
    }else if (displayMsg == Display_PIN_OK){
        msg = @"Pin ok";
    }else if (displayMsg == Display_INPUT_PIN_ING){
        msg = @"please input pin on pos";
    }else if (displayMsg == Display_MAG_TO_ICC_TRADE){
        msg = @"please insert chip card on pos";
    }else if (displayMsg == Display_INPUT_OFFLINE_PIN_ONLY){
        msg = @"input offline pin only";
    }else if(displayMsg == Display_CARD_REMOVED){
        msg = @"Card Removed";
    }
    [self sendMessage:@"onRequestDisplay" parameter:msg];
}

- (void)onGetKeyCheckValue:(NSDictionary *)checkValueResult{
    [self sendMessage:@"onGetKeyCheckValue" parameter:@""];
}

-(void) onReturnGetPinResult:(NSDictionary*)decodeData{
//    NSString *aStr = @"pinKsn: ";
//    aStr = [aStr stringByAppendingString:decodeData[@"pinKsn"]];
//    aStr = [aStr stringByAppendingString:@"\n"];
//    aStr = [aStr stringByAppendingString:@"pinBlock: "];
//    aStr = [aStr stringByAppendingString:decodeData[@"pinBlock"]];
//    NSString *displayStr = aStr;
}

-(void) onRequestUpdateWorkKeyResult:(UpdateInformationResult)updateInformationResult{
    NSString *updateResult = @"";
    if (updateInformationResult==UpdateInformationResult_UPDATE_SUCCESS) {
        updateResult = @"Success";
    }else if(updateInformationResult==UpdateInformationResult_UPDATE_FAIL){
        updateResult = @"Failed";
    }else if(updateInformationResult==UpdateInformationResult_UPDATE_PACKET_LEN_ERROR){
        updateResult = @"Packet len error";
    }else if(updateInformationResult==UpdateInformationResult_UPDATE_PACKET_VEFIRY_ERROR){
        updateResult = @"Packer vefiry error";
    }
    [self sendMessage:@"onRequestUpdateWorkKeyResult" parameter:updateResult];
}

//eg: update TMK api in pos.
-(void)setMasterKeyTest:(NSInteger)keyIndex{
    NSString *pik = @"89EEF94D28AA2DC189EEF94D28AA2DC1";//111111111111111111111111
    NSString *pikCheck = @"82E13665B4624DF5";
    pik = @"F679786E2411E3DEF679786E2411E3DE";//33333333333333333333333333333
    pikCheck = @"ADC67D8473BF2F06";
    [self.mPos setMasterKey:pik checkValue:pikCheck keyIndex:keyIndex];
}

-(void) onReturnSetMasterKeyResult: (BOOL)isSuccess{
    [self sendMessage:@"onReturnSetMasterKeyResult" result:isSuccess];
}

- (void)updateEMVConfigByXML{
    NSData *xmlData = [self readLine:@"emv_profile_tlv"];
    NSString *xmlStr = [QPOSUtil asciiFormatString:xmlData];
    [self.mPos updateEMVConfigByXml:xmlStr];
}

// callback function of updateEmvConfig and updateEMVConfigByXml api.
-(void)onReturnCustomConfigResult:(BOOL)isSuccess config:(NSString*)resutl{
    [self sendMessage:@"onReturnCustomConfigResult" result:isSuccess];
}

// update pos firmware api
- (void)updatePosFirmware:(NSString *)firmwareStr btName:(NSString *)btName{
    NSData *data = [QPOSUtil HexStringToByteArray:firmwareStr];//read a14upgrader.asc
    if (data != nil) {
       NSInteger flag = [[QPOSService sharedInstance] updatePosFirmware:data address:self.bluetoothAddress];
        if (flag==-1) {
            NSLog(@"Pos is not plugged in");
            return;
        }
        self.updateFWFlag = true;
        dispatch_async(dispatch_queue_create(0, 0), ^{
            while (true) {
                [NSThread sleepForTimeInterval:1];
                NSInteger progress = [self.mPos getUpdateProgress];
                if (progress < 100) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!self.updateFWFlag) {
                            return;
                        }
                        NSLog(@"Current progress:%ld%%",(long)progress);
                    });
                    continue;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"finish upgrader");
                });
                break;
            }
        });
    }else{
        NSLog( @"pls make sure you have passed the right data");
    }
}

// callback function of updatePosFirmware api.
-(void) onUpdatePosFirmwareResult:(UpdateInformationResult)updateInformationResult{
    self.updateFWFlag = false;
    NSString *str = @"";
    if (updateInformationResult==UpdateInformationResult_UPDATE_SUCCESS) {
        str = @"Success";
    }else if(updateInformationResult==UpdateInformationResult_UPDATE_FAIL){
        str = @"Failed";
    }else if(updateInformationResult==UpdateInformationResult_UPDATE_PACKET_LEN_ERROR){
        str = @"Packet len error";
    }else if(updateInformationResult==UpdateInformationResult_UPDATE_PACKET_VEFIRY_ERROR){
        str = @"Packer vefiry error";
    }
    [self sendMessage:@"onUpdatePosFirmwareResult" parameter:str];
}

- (void)onReturnSetSleepTimeResult:(BOOL)isSuccess{
    [self sendMessage:@"onReturnSetSleepTimeResult" result:isSuccess];
}

- (void)onReturnBuzzerStatusResult:(BOOL)isSuccess{
    [self sendMessage:@"onSetBuzzerStatusResult" result:isSuccess];
}

- (DoTradeMode)convertDoTradeModeStrToEnum:(NSString *)doTradeModeStr{
    DoTradeMode doTradeMode = DoTradeMode_COMMON;
    if([@"COMMON" isEqualToString:doTradeModeStr]){
        doTradeMode = DoTradeMode_COMMON;
    }else if ([@"IS_DEBIT_OR_CREDIT" isEqualToString:doTradeModeStr]){
        doTradeMode = DoTradeMode_IS_DEBIT_OR_CREDIT;
    }else if ([@"CHECK_CARD_NO_IPNUT_PIN" isEqualToString:doTradeModeStr]){
        doTradeMode = DoTradeMode_CHECK_CARD_NO_IPNUT_PIN;
    }
    return doTradeMode;
}

- (CardTradeMode)convertCardTradeModeStrToEnum:(NSString *)cardTradeModeStr{
    CardTradeMode cardTradeMode = CardTradeMode_SWIPE_TAP_INSERT_CARD;
    if([@"ONLY_INSERT_CARD" isEqualToString:cardTradeModeStr]){
        cardTradeMode = CardTradeMode_ONLY_INSERT_CARD;
    }else if ([@"ONLY_SWIPE_CARD" isEqualToString:cardTradeModeStr]){
        cardTradeMode = CardTradeMode_ONLY_SWIPE_CARD;
    }else if ([@"SWIPE_INSERT_CARD" isEqualToString:cardTradeModeStr]){
        cardTradeMode = CardTradeMode_SWIPE_INSERT_CARD;
    }else if ([@"UNALLOWED_LOW_TRADE" isEqualToString:cardTradeModeStr]){
        cardTradeMode = CardTradeMode_UNALLOWED_LOW_TRADE;
    }else if ([@"SWIPE_TAP_INSERT_CARD" isEqualToString:cardTradeModeStr]){
        cardTradeMode = CardTradeMode_SWIPE_TAP_INSERT_CARD;
    }else if ([@"SWIPE_TAP_INSERT_CARD_UNALLOWED_LOW_TRADE" isEqualToString:cardTradeModeStr]){
        cardTradeMode = CardTradeMode_SWIPE_TAP_INSERT_CARD_UNALLOWED_LOW_TRADE;
    }else if ([@"ONLY_TAP_CARD" isEqualToString:cardTradeModeStr]){
        cardTradeMode = CardTradeMode_ONLY_TAP_CARD;
    }else if ([@"SWIPE_TAP_INSERT_CARD_NOTUP" isEqualToString:cardTradeModeStr]){
        cardTradeMode = CardTradeMode_SWIPE_TAP_INSERT_CARD_NOTUP;
    }else if ([@"TAP_INSERT_CARD_TUP" isEqualToString:cardTradeModeStr]){
        cardTradeMode = CardTradeMode_TAP_INSERT_CARD_TUP;
    }else if ([@"SWIPE_TAP_INSERT_CARD_Down" isEqualToString:cardTradeModeStr]){
        cardTradeMode = CardTradeMode_SWIPE_TAP_INSERT_CARD_Down;
    }else if ([@"SWIPE_TAP_INSERT_CARD_NOTUP_UNALLOWED_LOW_TRADE" isEqualToString:cardTradeModeStr]){
        cardTradeMode = CardTradeMode_SWIPE_TAP_INSERT_CARD_NOTUP_UNALLOWED_LOW_TRADE;
    }else if ([@"SWIPE_INSERT_CARD_UNALLOWED_LOW_TRADE" isEqualToString:cardTradeModeStr]){
        cardTradeMode = CardTradeMode_SWIPE_INSERT_CARD_UNALLOWED_LOW_TRADE;
    }else if ([@"SWIPE_TAP_INSERT_CARD_UNALLOWED_LOW_TRADE_NEW" isEqualToString:cardTradeModeStr]){
        cardTradeMode = CardTradeMode_SWIPE_TAP_INSERT_CARD_UNALLOWED_LOW_TRADE_NEW;
    }else if ([@"SWIPE_TAP_INSERT_CARD_NOTUP_DELAY" isEqualToString:cardTradeModeStr]){
        cardTradeMode = CardTradeMode_SWIPE_TAP_INSERT_CARD_NOTUP_DELAY;
    }
    return cardTradeMode;
}

- (NSData*)readLine:(NSString*)name{
    NSString* binFile = [[NSBundle mainBundle]pathForResource:name ofType:@".bin"];
    NSString* ascFile = [[NSBundle mainBundle]pathForResource:name ofType:@".asc"];
    NSString* xmlFile = [[NSBundle mainBundle]pathForResource:name ofType:@".xml"];
    if (binFile!= nil && ![binFile isEqualToString: @""]) {
        NSFileManager* Manager = [NSFileManager defaultManager];
        NSData* data1 = [[NSData alloc] init];
        data1 = [Manager contentsAtPath:binFile];
        return data1;
    }else if (ascFile!= nil && ![ascFile isEqualToString: @""]){
        NSFileManager* Manager = [NSFileManager defaultManager];
        NSData* data2 = [[NSData alloc] init];
        data2 = [Manager contentsAtPath:ascFile];
        //NSLog(@"----------");
        return data2;
    }else if (xmlFile!= nil && ![xmlFile isEqualToString: @""]){
        NSFileManager* Manager = [NSFileManager defaultManager];
        NSData* data2 = [[NSData alloc] init];
        data2 = [Manager contentsAtPath:xmlFile];
        return data2;
    }
    return nil;
}

- (NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;

    if (!jsonData) {
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}
@end
