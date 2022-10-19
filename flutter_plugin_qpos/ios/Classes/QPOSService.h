//
//  QPOSService.h
//  qpos-ios-demo
//
//  Created by Robin on 11/19/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CBPeripheral;
typedef NS_ENUM(NSInteger, PosType) {
    PosType_AUDIO,
    PosType_BLUETOOTH,
    PosType_BLUETOOTH_new, // delete this mode
    PosType_BLUETOOTH_2mode //bluetooth 2 mode
};

typedef NS_ENUM(NSInteger, resetState) {
    resetState_INIT,
    resetState_RESETING,
    resetState_RESETED
};

typedef NS_ENUM(NSInteger, UpdateInformationResult) {
    UpdateInformationResult_UPDATE_SUCCESS,
    UpdateInformationResult_UPDATE_FAIL,
    UpdateInformationResult_UPDATE_PACKET_VEFIRY_ERROR,
    UpdateInformationResult_UPDATE_PACKET_LEN_ERROR,
    UpdateInformationResult_UPDATE_LOWPOWER,
    UpdateInformationResult_UPDATING,
    UpdateInformationResult_UPDATE_CMD_ERROR,
    UpdateInformationResult_UPDATE_SIGNATURE_ERROR,
    UpdateInformationResult_UPDATE_FRAME_LENGTH_ERROR,
    UpdateInformationResult_UPDATE_DATA_FORMAT_ERROR,
    UpdateInformationResult_UPDATE_WRITE_VALUE_ERROR,
    UpdateInformationResult_UPDATE_NOT_FINISH,
    UpdateInformationResult_UPDATE_PLEASE_PLUG_INTO_POWER,
};

typedef NS_ENUM(NSInteger, DoTradeResult)
{
    DoTradeResult_NONE,
    DoTradeResult_MCR,
    DoTradeResult_ICC,
    DoTradeResult_BAD_SWIPE,
    DoTradeResult_NO_RESPONSE,
    DoTradeResult_NOT_ICC,
    DoTradeResult_NO_UPDATE_WORK_KEY,
    DoTradeResult_NFC_ONLINE,   // add 20150715
    DoTradeResult_NFC_OFFLINE,
    DoTradeResult_NFC_DECLINED,
    DoTradeResult_TRY_ANOTHER_INTERFACE,
    DoTradeResult_CARD_NOT_SUPPORT,
    DoTradeResult_PLS_SEE_PHONE
};

typedef NS_ENUM(NSInteger, EmvOption)
{
    EmvOption_START,
    EmvOption_START_WITH_FORCE_ONLINE,
    EmvOption_START_WITH_FORCE_PIN,
    EmvOption_START_WITH_FORCE_ONLINE_FORCE_PIN
    
};

typedef NS_ENUM(NSInteger, CHECKVALUE_KEYTYPE)
{
    MKSK_TMK,
    MKSK_PIK,
    MKSK_TDK,
    MKSK_MCK,
    TCK,
    MAGK,
    DUKPT_TRK_IPEK,
    DUKPT_EMV_IPEK,
    DUKPT_PIN_IPEK,
    DUKPT_TRK_KSN,
    DUKPT_EMV_KSN,
    DUKPT_PIN_KSN,
    DUKPT_MKSK_ALLTYPE
};

typedef NS_ENUM(NSInteger, Error)
{
    Error_TIMEOUT,
    Error_MAC_ERROR,
    Error_CMD_NOT_AVAILABLE,
    Error_DEVICE_RESET,
    Error_UNKNOWN,
    Error_DEVICE_BUSY,
    Error_INPUT_OUT_OF_RANGE,
    Error_INPUT_INVALID_FORMAT,
    Error_INPUT_ZERO_VALUES,
    Error_INPUT_INVALID,
    Error_CASHBACK_NOT_SUPPORTED,
    Error_CRC_ERROR,
    Error_COMM_ERROR,
    Error_CMD_TIMEOUT,
    Error_WR_DATA_ERROR,
    Error_EMV_APP_CFG_ERROR,
    Error_EMV_CAPK_CFG_ERROR,
    Error_APDU_ERROR,
    Error_ICC_ONLINE_TIMEOUT,
    Error_AMOUNT_OUT_OF_LIMIT,
    Error_DIGITS_UNAVAILABLE,
    Error_QPOS_MEMORY_OVERFLOW,
    Error_SELECT_APP_TIMEOUT
};

typedef NS_ENUM(NSInteger, DHError)
{
    DHError_TIMEOUT,
    DHError_MAC_ERROR,
    DHError_CMD_NOT_AVAILABLE,
    DHError_DEVICE_RESET,
    DHError_UNKNOWN,
    DHError_DEVICE_BUSY,
    DHError_INPUT_OUT_OF_RANGE,
    DHError_INPUT_INVALID_FORMAT,
    DHError_INPUT_ZERO_VALUES,
    DHError_INPUT_INVALID,
    DHError_CASHBACK_NOT_SUPPORTED,
    DHError_CRC_ERROR,
    DHError_COMM_ERROR,
    DHError_CMD_TIMEOUT,
    DHError_WR_DATA_ERROR,
    DHError_EMV_APP_CFG_ERROR,
    DHError_EMV_CAPK_CFG_ERROR,
    DHError_APDU_ERROR,
    DHError_ICC_ONLINE_TIMEOUT,
    DHError_AMOUNT_OUT_OF_LIMIT,
    DHError_DIGITS_UNAVAILABLE,
    DHError_QPOS_MEMORY_OVERFLOW,
    DHError_SELECT_APP_TIMEOUT
};


typedef NS_ENUM(NSInteger, Display)
{
    Display_TRY_ANOTHER_INTERFACE,
    Display_PLEASE_WAIT,
    Display_REMOVE_CARD,
    Display_CLEAR_DISPLAY_MSG,
    Display_PROCESSING,
    Display_TRANSACTION_TERMINATED,
    Display_PIN_OK,
    Display_INPUT_PIN_ING,
    Display_MAG_TO_ICC_TRADE,
    Display_INPUT_OFFLINE_PIN_ONLY,
    Display_INPUT_LAST_OFFLINE_PIN,
    Display_CARD_REMOVED,
    Display_MSR_DATA_READY,
    Display_QPOS_MEMORY_OVERFLOW
    
};

typedef NS_ENUM(NSInteger, TransactionResult) {
    TransactionResult_APPROVED,
    TransactionResult_TERMINATED,
    TransactionResult_DECLINED,
    TransactionResult_CANCEL,
    TransactionResult_CAPK_FAIL,
    TransactionResult_NOT_ICC,
    TransactionResult_SELECT_APP_FAIL,
    TransactionResult_DEVICE_ERROR,
    TransactionResult_CARD_NOT_SUPPORTED,
    TransactionResult_MISSING_MANDATORY_DATA,
    TransactionResult_CARD_BLOCKED_OR_NO_EMV_APPS,
    TransactionResult_INVALID_ICC_DATA,
    TransactionResult_FALLBACK,
    TransactionResult_NFC_TERMINATED,
    TransactionResult_TRADE_LOG_FULL,
    TransactionResult_CONTACTLESS_TRANSACTION_NOT_ALLOW,
    TransactionResult_CARD_BLOCKED,
    TransactionResult_TOKEN_INVALID,
    TransactionResult_APP_BLOCKED,
    TransactionResult_MULTIPLE_CARDS,
};

typedef NS_ENUM(NSInteger, TransactionType) {
    TransactionType_GOODS, // 货物
    TransactionType_SERVICES, // 服务
    TransactionType_CASH,//现金
    TransactionType_CASHBACK, // 退货 返现
    TransactionType_INQUIRY, // 查询
    TransactionType_TRANSFER, // 转账
    TransactionType_ADMIN,//管理
    TransactionType_CASHDEPOSIT,//存款
    TransactionType_PAYMENT,// 付款 支付
    //add 2014-04-02
    TransactionType_PBOCLOG,//        0x0A            /*PBOC日志(电子现金日志)*/
    TransactionType_SALE,//           0x0B            /*消费*/
    TransactionType_PREAUTH,//        0x0C            /*预授权*/
    TransactionType_ECQ_DESIGNATED_LOAD,//        0x10                /*电子现金Q指定账户圈存*/
    TransactionType_ECQ_UNDESIGNATED_LOAD,//    0x11                /*电子现金费非指定账户圈存*/
    TransactionType_ECQ_CASH_LOAD,//    0x12    /*电子现金费现金圈存*/
    TransactionType_ECQ_CASH_LOAD_VOID,//            0x13                /*电子现金圈存撤销*/
    TransactionType_ECQ_INQUIRE_LOG,//    0x0A    /*电子现金日志(和PBOC日志一样)*/
    TransactionType_REFUND,
    TransactionType_UPDATE_PIN
};

typedef NS_ENUM(NSInteger, LcdModeAlign) {
    LCD_MODE_ALIGNLEFT,
    LCD_MODE_ALIGNRIGHT,
    LCD_MODE_ALIGNCENTER
};

typedef NS_ENUM(NSInteger, AmountType) {
    AmountType_NONE,
    AmountType_RMB,
    AmountType_DOLLAR,
    AmountType_CUSTOM_STR
};

typedef NS_ENUM(NSInteger, CardTradeMode) {
    CardTradeMode_ONLY_INSERT_CARD,
    CardTradeMode_ONLY_SWIPE_CARD,
    CardTradeMode_SWIPE_INSERT_CARD,
    CardTradeMode_UNALLOWED_LOW_TRADE,
    CardTradeMode_SWIPE_TAP_INSERT_CARD,// add 20150715
    CardTradeMode_SWIPE_TAP_INSERT_CARD_UNALLOWED_LOW_TRADE,
    CardTradeMode_ONLY_TAP_CARD,
    CardTradeMode_SWIPE_TAP_INSERT_CARD_NOTUP,
    CardTradeMode_TAP_INSERT_CARD_NOTUP,//无上翻键
    CardTradeMode_TAP_INSERT_CARD_TUP,//有上翻键
    CardTradeMode_SWIPE_TAP_INSERT_CARD_Down,//下翻建
    CardTradeMode_SWIPE_TAP_INSERT_CARD_NOTUP_UNALLOWED_LOW_TRADE,
    CardTradeMode_SWIPE_INSERT_CARD_UNALLOWED_LOW_TRADE,
    CardTradeMode_SWIPE_TAP_INSERT_CARD_UNALLOWED_LOW_TRADE_NEW,
    CardTradeMode_SWIPE_TAP_INSERT_CARD_NOTUP_DELAY,
};

typedef NS_ENUM(NSInteger, DoTradeMode) {//不需要对外提供
    DoTradeMode_COMMON,
    DoTradeMode_CHECK_CARD_NO_IPNUT_PIN,//不输入密码
    DoTradeMode_IS_DEBIT_OR_CREDIT//
};

typedef NS_ENUM(NSInteger,DoTradeLog) {
    DoTradeLog_clear,
    DoTradeLog_getAllCount,
    DoTradeLog_getOneLog,
    DoTradeLog_deleteOneLog,
    DoTradeLog_deleteLastLog,
    DoTradeLog_ClearOneByBatchID,
    DoTradeLog_GetOneByBatchID
};
typedef NS_ENUM(NSInteger,EncryptType) {
    EncryptType_plaintext,
    EncryptType_encrypted
};

typedef NS_ENUM(NSInteger,PanStatus) {
    PanStatus_DEFAULT,
    PanStatus_PLAINTEXT,
    PanStatus_ENCRYPTED
};

typedef NS_ENUM(NSInteger,EMVOperation) {
    EMVOperation_clear,
    EMVOperation_add,
    EMVOperation_delete,
    EMVOperation_getList,
    EMVOperation_update,
    EMVOperation_quickemv//EMVOperation_getEmv
};

typedef NS_ENUM(NSInteger,Cmd1620Status){
    Cmd1620Status_NONE,
    Cmd1620Status_EXECUTING,
    Cmd1620Status_QUERY,
    Cmd1620Status_EXECUTED
};

typedef NS_ENUM(NSInteger,FelicaOpMode){
    FelicaOpMode_POWER_ON,
    FelicaOpMode_SEND_APDU,
    FelicaOpMode_POWER_OFF
};

typedef NS_ENUM(NSInteger,FelicaStatusCode){
    FelicaStatusCode_NFC_FELICA_SUCCESS,
    FelicaStatusCode_NFC_FELICA_PARAM_ERROR,
    FelicaStatusCode_NFC_FELICA_POLL_ERROR,
    FelicaStatusCode_NFC_FELICA_OPERATION_ERROR,
    FelicaStatusCode_NFC_FELICA_RAW_TRANS_ERROR,
    FelicaStatusCode_NFC_FELICA_TIMEOUT,
    FelicaStatusCode_NFC_FELICA_ERROR_END,
};

typedef NS_ENUM(NSInteger,MifareCardType){
    MifareCardType_CLASSIC,
    MifareCardType_ULTRALIGHT,
};

typedef NS_ENUM(NSInteger,MifareKeyType){
    MifareKeyType_KEY_A,
    MifareKeyType_KEY_B,
};

typedef NS_ENUM(NSInteger,MifareCardOperationType){
    MifareCardOperationType_ADD,
    MifareCardOperationType_REDUCE,
    MifareCardOperationType_RESTORE,
};

typedef NS_ENUM(NSInteger,LEDType){
    LEDType_FIXED_COLOR,
    LEDType_RGB_COLOR,
};

typedef NS_ENUM(NSInteger,LEDStatus){
    LEDStatus_ON,
    LEDStatus_OFF,
    LEDStatus_BLINKS,
};

typedef NS_ENUM(NSInteger,LEDDirection){
    LEDDirection_ALL,
    LEDDirection_LEFT,
    LEDDirection_RIGHT,
    LEDDirection_UP,
    LEDDirection_DOWN,
};

typedef NS_ENUM(NSInteger,BuzzerType){
    BuzzerType_COMMON,
    BuzzerType_PAYMENT_SUCCESS,
    BuzzerType_PAYMENT_ERROR,
    BuzzerType_PAIRING_SUCCESS,
};


@protocol QPOSServiceListener<NSObject>

@optional
-(void)onRequestWaitingUser;
-(void)onRequestPinEntry;
-(void)onQposIdResult: (NSDictionary*)posId;
-(void)onQposInfoResult: (NSDictionary*)posInfoData;
-(void)onDoTradeResult: (DoTradeResult)result DecodeData:(NSDictionary*)decodeData;
-(void)onRequestSetAmount;
-(void)onRequestSelectEmvApp: (NSArray*)appList;
-(void)onRequestIsServerConnected;
-(void)onRequestFinalConfirm;
-(void)onRequestOnlineProcess: (NSString*) tlv;
-(void)onRequestTime;
-(void)onRequestTransactionResult: (TransactionResult)transactionResult;
-(void)onRequestTransactionLog: (NSString*)tlv;
-(void)onRequestBatchData: (NSString*)tlv;
-(void)onRequestQposConnected;
-(void)onRequestQposDisconnected;
-(void)onRequestNoQposDetected;
-(void)onError: (Error)errorState;//pls del this Delegate
-(void)onDHError: (DHError)errorState;//replace function onError
-(void)onRequestDisplay: (Display)displayMsg;
-(void)onRequestUpdateWorkKeyResult:(UpdateInformationResult)updateInformationResult;
-(void)onRequestGetCardNoResult:(NSString *)result;
-(void)onRequestSignatureResult:(NSData *)result;
-(void)onReturnReversalData: (NSString*)tlv;
-(void)onReturnGetPinResult:(NSDictionary*)decodeData;
-(void)onReturnBuzzerStatusResult:(BOOL)isSuccess;//callback of Seting whether the buzzer
-(void)onReturnSetSleepTimeResult:(BOOL)isSuccess;
-(void)onReturnCustomConfigResult:(BOOL)isSuccess config:(NSString*)resutl;
-(void)onReturnSetMasterKeyResult: (BOOL)isSuccess;
-(void)onReturniccCashBack: (NSDictionary*)result;
-(void)onLcdShowCustomDisplay: (BOOL)isSuccess;
-(void)onUpdatePosFirmwareResult:(UpdateInformationResult)result;
-(void)onDownloadRsaPublicKeyResult:(NSDictionary *)result;
-(void)onGetPosComm:(NSInteger)mode amount:(NSString *)amt posId:(NSString*)aPosId;
-(void)onUpdateMasterKeyResult:(BOOL)isSuccess aDic:(NSDictionary *)resultDic;
-(void)onEmvICCExceptionData: (NSString*)tlv;
-(void)onAsyncResetPosStatus:(NSString *)isReset;
-(void)onGetKeyCheckValue:(NSDictionary *)checkValueResult;
-(void)onReturnGetEMVListResult:(NSString *)result;
-(void)onReturnUpdateEMVResult:(BOOL)isSuccess;
-(void)onReturnUpdateEMVRIDResult:(BOOL)isSuccess;
-(void)onReturnSetAESResult:(BOOL)isSuccess resultStr:(NSString *)result;
-(void)onReturnAESTransmissonKeyResult:(BOOL)isSuccess resultStr:(NSString *)result;
-(void)onGetShutDownTime:(NSString *)time;
-(void)onReturnPowerOnIccResult:(BOOL) isSuccess  KSN:(NSString *) ksn ATR:(NSString *)atr ATRLen:(NSInteger)atrLen;
-(void)onReturnPowerOffIccResult:(BOOL) isSuccess;
-(void)onReturnApduResult:(BOOL)isSuccess APDU:(NSString *)apdu APDU_Len:(NSInteger) apduLen;
-(void)onPinKeyTDESResult:(NSString *)encPin;
-(void)onGetDevicePublicKey:(NSString *)clearKeys;
-(void)onQposGenerateSessionKeysResult:(NSDictionary *)result;
-(void)onDoSetRsaPublicKey:(BOOL)result;
-(void)onReturnSetConnectedShutDownTimeResult:(BOOL)isSuccess;
-(void)onReturnGetConnectedShutDownTimeResult:(NSString *)time;
-(void)onReturnUpdateKeyByTR_31Result:(BOOL)result;
-(void)onReturnGetEncryptDataResult:(NSDictionary*)tlv;
-(void)onReturnBatchSendAPDUResult:(NSDictionary *)apduResponses;
-(void)onReturnPowerOnFelicaResult:(FelicaStatusCode)result;
-(void)onReturnPowerOffFelicaResult:(FelicaStatusCode)result;
-(void)onReturnSendApduFelicaResult:(FelicaStatusCode)result responseLen:(NSString *)responseLen responseData:(NSString *)responseData;
@end

@interface QPOSService : NSObject
+(QPOSService *)sharedInstance;
-(void)setDelegate:(id<QPOSServiceListener>)aDelegate;
-(void)setQueue:(dispatch_queue_t)queue;
-(void)setPosType:(PosType) aPosType;
#pragma UPDATE IPEK
-(void)doUpdateIPEKOperation:(NSString *)groupKey
            tracksn:(NSString *)trackksn
          trackipek:(NSString *)trackipek
trackipekCheckValue:(NSString *)trackipekCheckValue
             emvksn:(NSString *)emvksn
            emvipek:(NSString *)emvipek
  emvipekcheckvalue:(NSString *)emvipekcheckvalue
             pinksn:(NSString *)pinksn
            pinipek:(NSString *)pinipek
  pinipekcheckValue:(NSString *)pinipekcheckValue
              block:(void(^)(BOOL isSuccess,NSString *stateStr))EMVBlock;

- (void)updateIPEKOperationByKeyType:(NSString *)groupKey
                     tracksn:(NSString *)trackksn
                   trackipek:(NSString *)trackipek
         trackipekCheckValue:(NSString *)trackipekCheckValue
                      emvksn:(NSString *)emvksn
                     emvipek:(NSString *)emvipek
           emvipekcheckvalue:(NSString *)emvipekcheckvalue
                      pinksn:(NSString *)pinksn
                     pinipek:(NSString *)pinipek
           pinipekcheckValue:(NSString *)pinipekcheckValue
                       block:(void(^)(BOOL isSuccess,NSString *stateStr))EMVBlock;

//buzzer
-(void)doSetBuzzerOperation:(NSInteger)timeOut
                      block:(void (^)(BOOL isSuccess, NSString*stateStr))buzzerBlock;
//Update emv Rid configuration
-(void)updateEMVRID:(NSInteger)operationType
               data:(NSString *)data
              block:(void(^)(BOOL isSuccess,NSString *stateStr))EMVBlock;
//Update AID configuration
-(void)updateAID:(NSInteger)operationType
            data:(NSString *)data
           block:(void(^)(BOOL isSuccess,NSString *stateStr))EMVBlock;
//Setting AID
-(void)setAIDwithBool:(BOOL)isTrue
                 data:(NSString *)data
                block:(void(^)(BOOL isSuccess,NSString *stateStr))EMVBlock;
//Set waiting for ARPC time
-(void)setOnlineTime:(NSInteger)aTime;
-(NSInteger)getOnLineTime;
//Read POS upgrade key
-(void)getUpdateCheckValueBlock:(void(^)(BOOL isSuccess,NSString *stateStr))updateCheckValueBlock;
//Set POS shutdown time
-(void)doSetShutDownTime:(NSString *)timeOut;
//Update POS sleep time
-(void)doSetSleepModeTime:(NSString *)timeOut  block:(void(^)(BOOL isSuccess,NSString *stateStr))sleepModeBlock;
//bluetooth
-(BOOL)getBluetoothState;
-(void)setBTAutoDetecting: (BOOL)flag;
-(BOOL)connectBT: (NSString *)bluetoothName;
-(BOOL)connectBT: (NSString *)bluetoothName connectTime:(NSInteger)time;
-(CBPeripheral*)getConnectedPeripheral:(NSString *)bluetoothName;
-(BOOL)connectBluetoothByCBPeripheral: ( CBPeripheral*)myCBPeripheral;
-(BOOL)connectBluetoothNoScan: (NSString*)bluetoothName;
-(NSArray *)getConnectedDevices;
-(void)disconnectBT;
-(BOOL)resetPosStatus;
-(BOOL)cancelTrade:(BOOL)isUserCancel;
-(void)asynresetPosStatus;
//you can set CardTradeMode before calling doTrade.
-(void)setCardTradeMode:(CardTradeMode) aCardTMode;
//you can set DoTradeMode before calling doTrade.
-(void)setDoTradeMode:(DoTradeMode)doTradeMode;
-(void)setFormatID:(NSString *)formatID;
-(void)setAmountPoint:(BOOL)amoutPoint;
-(void)startAudio;
-(void)stopAudio;
//start trade api
-(void)doTrade;
-(void)doTrade:(NSInteger) timeout;
-(void)doTrade:(NSInteger)keyIndex delays:(NSInteger)timeout;
-(void)doCheckCard;
-(void)doCheckCard:(NSInteger) timeout;
-(void)doCheckCard:(NSInteger) timeout keyIndex:(NSInteger) mKeyIndex;
-(void)doTrade_QF:(NSInteger)tradeMode TradeRandomString:(NSString *)randomString TradeExtraString:(NSString *)extraString;
-(void)doTrade_QF:(NSInteger)tradeMode TradeRandomString:(NSString *)randomString TradeExtraString:(NSString *)extraString timeout:(NSInteger) delay;
//open quick emv
-(void)setIsQuickEMV:(BOOL)isQuickEMV;
-(BOOL)getQuickEMV;
-(void)doEmvApp: (EmvOption)aemvOption;
-(void)setAmount: (NSString *)aAmount aAmountDescribe:(NSString *)aAmountDescribe currency:(NSString *)currency transactionType:(TransactionType)transactionType;
-(void)setAmount:(NSString *)aAmount aAmountDescribe:(NSString *)aAmountDescribe currency:(NSString *)currency transactionType:(TransactionType)transactionType posDisplayAmount:(BOOL)flag; 
-(void)cancelSetAmount;
-(void)finalConfirm: (BOOL)isConfirmed;
//Multiple AIDs options
-(void)selectEmvApp: (NSInteger)index;
-(void)cancelSelectEmvApp;
//send ARPC to pos api by sendOnlineProcessResult function.
-(void)sendOnlineProcessResult: (NSString *)tlv;
-(void)sendOnlineProcessResult: (NSString *)tlv delay:(NSInteger)delay;
-(void)isServerConnected: (BOOL)isConnected;
// send current time to pos
-(void)sendTime: (NSString *)aterminalTime;
//you can use this api to get NFC batch data.
-(NSDictionary *)getNFCBatchData;
-(void)getNFCBatchData:(void(^)(NSDictionary *dict))nfcBatchDataBlock;
//get ios sdk version
-(NSString *)getSdkVersion;
//get pos infomation
-(void)getQPosInfo;
-(void)getQPosId;
//add icc apdu 2014-03-11
-(void)powerOffIcc;
-(void)powerOnIcc;
-(void)sendApdu:(NSString *)apduStr;
//nfc
-(void)powerOffNFC:(NSInteger) timeout withBlock:(void (^)(BOOL isSuccess))onPowerOffNFCResultBlock;
-(void)sendApduByNFC:(NSString *)apduString delay:(NSInteger)timeout withBlock:(void (^)(BOOL isSuccess, NSString *apdu, NSInteger apduLen))onNFCApduResultBlock;
-(void)powerOnNFC:(NSInteger) isEncrypt delay:(NSInteger) timeout withBlock:(void (^)(BOOL isSuccess, NSString *ksn, NSString *atr, NSInteger atrLen))onPowerOnNFCResultBlock;

-(void)sendPinEntryResult:(NSString *)pin;
-(void)cancelPinEntry;
-(void)bypassPinEntry;

//Set the currency identifier displayed by the POS. For example: $
-(void)setAmountIcon:(NSString *)aAmountIcon;
-(void)setAmountIcon:(AmountType) amtType amtIcon:(NSString *)aAmountIcon;
//update emv configure api by bin file
-(void)updateEmvConfig:(NSString *)emvAppCfg emvCapk:(NSString*)emvCapkCfg DEPRECATED_MSG_ATTRIBUTE("Please use [pos updateEMVConfigByXml]");
-(void)readEmvAppConfig;
-(void)readEmvCapkConfig;
//update emv configure api by xml file
-(void)updateEMVConfigByXml:(NSString *)xmlStr;
//update emv configure api by TLV
-(void)updateEmvAPPByTlv:(EMVOperation)emvOperation appTlv:(NSString *)appTlv;//appTlv更新emv配置
-(void)updateEmvCAPKByTlv:(EMVOperation)emvOperation capkTlv:(NSString *)capkTlv;//capkTlv更新emv配置
//update emv app configure
-(void)updateEmvCAPK:(NSInteger )operationType data:(NSArray *)data  block:(void (^)(BOOL isSuccess, NSString *stateStr))updateCAPKBlock DEPRECATED_MSG_ATTRIBUTE("Please use [pos updateEmvCAPKByTlv]");
-(void)updateEmvAPP:(NSInteger )operationType data:(NSArray*)data  block:(void (^)(BOOL isSuccess, NSString *stateStr))updateEMVAPPBlock DEPRECATED_MSG_ATTRIBUTE("Please use [pos updateEmvAPPByTlv]");
//update workkey api
-(void)udpateWorkKey:(NSString *)updateKey;
-(void)udpateWorkKey:(NSString *)pik pinKeyCheck:(NSString *)pikCheck trackKey:(NSString *)trk trackKeyCheck:(NSString *)trkCheck macKey:(NSString *)mak macKeyCheck:(NSString *)makCheck;
-(void)udpateWorkKey:(NSString *)workKey workKeyCheckValue:(NSString *)workKeyCheck;
-(void)udpateWorkKey:(NSString *)workKey workKeyCheckValue:(NSString *)workKeyCheck keyIndex:(int)keyIndex timeout:(int)timeout;
-(void)udpateWorkKey:(NSString *)pik pinKeyCheck:(NSString *)pikCheck trackKey:(NSString *)trk trackKeyCheck:(NSString *)trkCheck macKey:(NSString *)mak macKeyCheck:(NSString *)makCheck keyIndex:(NSInteger) mKeyIndex;
-(void)udpateWorkKey:(NSString *)pik pinKeyCheck:(NSString *)pikCheck trackKey:(NSString *)trk trackKeyCheck:(NSString *)trkCheck macKey:(NSString *)mak macKeyCheck:(NSString *)makCheck keyIndex:(NSInteger) mKeyIndex delay:(NSInteger)timeout;
-(void)udpateWorkKey:(NSString *)pik pinKeyCheck:(NSString *)pikCheck trackKey:(NSString *)trk trackKeyCheck:(NSString *)trkCheck macKey:(NSString *)mak macKeyCheck:(NSString *)makCheck transKey:(NSString *)tnsk transKeyCheck:(NSString *)tnskCheck keyIndex:(NSInteger) mKeyIndex delay:(NSInteger)timeout;

// update master key api
-(void)setMasterKey:(NSString *)key  checkValue:(NSString *)chkValue;
-(void)setMasterKey:(NSString *)key  checkValue:(NSString *)chkValue keyIndex:(NSInteger) mKeyIndex;
-(void)setMasterKey:(NSString *)key  checkValue:(NSString *)chkValue keyIndex:(NSInteger) mKeyIndex delay:(NSInteger)timeout;

//you can use this api to show custom text on pos after finish transaction.
-(void)lcdShowCustomDisplay:(LcdModeAlign) alcdModeAlign lcdFont:(NSString *)alcdFont;
-(void)lcdShowCustomDisplay:(LcdModeAlign) alcdModeAlign lcdFont:(NSString *)alcdFont delay:(NSInteger)timeout;
-(void)lcdShowCloseDisplay;

-(BOOL)isQposPresent;
-(NSDictionary *)anlysEmvIccData:(NSString *)tlv;
//you can use this api to get progress of upgrade pos firmware
//you can use this api to upgrade pos firmware.
-(NSInteger)getUpdateProgress;
-(NSInteger)updatePosFirmware:(NSData*)aData address:(NSString*)devAddress;
-(NSInteger)updateMPPosFirmware:(NSData*)aData address:(NSString*)devAddress;
//you can use this api to get pinblock and pinksn
-(void)getPin:(NSInteger)encryptType keyIndex:(NSInteger)keyIndex maxLen:(NSInteger)maxLen typeFace:(NSString *)typeFace cardNo:(NSString *)cardNo data:(NSString *)data delay:(NSInteger)timeout withResultBlock:(void (^)(BOOL isSuccess, NSDictionary * result))getPinBlock;
-(NSDictionary*)syncGetPin:(NSInteger)encryptType keyIndex:(NSInteger)keyIndex maxLen:(NSInteger)maxLen typeFace:(NSString *)typeFace cardNo:(NSString *)cardNo date:(NSString *)data delay:(NSInteger)timeout;

//you can use this api to get value of special emv tag.
-(NSDictionary *)getICCTag:(NSInteger)cardType tagCount:(NSInteger)mTagCount tagArrStr:(NSString*)mTagArrStr;
-(void)getICCTag:(NSInteger)cardType tagCount:(NSInteger)mTagCount tagArrStr:(NSString*)mTagArrStr tagArrBlock:(void(^)(NSDictionary *dict))tagArrBlock;
-(NSDictionary *)getICCTag:(EncryptType)encryTypeStr cardType:(NSInteger)cardType tagCount:(NSInteger)mTagCount tagArrStr:(NSString*)mTagArrStr;
-(void)getICCTag:(EncryptType)encryTypeStr cardType:(NSInteger)cardType tagCount:(NSInteger)mTagCount tagArrStr:(NSString*)mTagArrStr tagArrBlock:(void(^)(NSDictionary *dict))tagArrBlock;
-(NSDictionary *)getICCTagNew:(EncryptType)encryTypeStr cardType:(NSInteger)cardType tagCount:(NSInteger)mTagCount tagArrStr:(NSString *)mTagArrStr;
-(void)getICCTagNew:(EncryptType)encryTypeStr cardType:(NSInteger)cardType tagCount:(NSInteger)mTagCount tagArrStr:(NSString *)mTagArrStr tagArrBlock:(void(^)(NSDictionary *dict))tagArrBlock;
//you can use api to custom input on pos.
-(void)customInputDisplay:(NSInteger)operationType displayType:(NSInteger)dispType maxLen:(NSInteger)maxLen DisplayString:(NSString *)displayStr delay:(NSInteger)timeout withResultBlock:(void (^)(BOOL isSuccess, NSString * result))customInputDisplayResult;
-(void)buildPinBlock:(NSString *)workKey workKeyCheck:(NSString *)workKeyCheck encryptType:(NSInteger)encryptType keyIndex:(NSInteger)keyIndex maxLen:(NSInteger)maxLen typeFace:(NSString *)typeFace cardNo:(NSString *)cardNo date:(NSString *)date delay:(NSInteger)timeout;
-(BOOL)syncIsCardExist:(NSInteger)timeout;
-(void)isCardExist:(NSInteger)timeout withResultBlock:(void (^)(BOOL))isCardExistBlock;
-(void)isCardExistInOnlineProcess:(NSInteger)timeout withResultBlock:(void (^)(BOOL))isCardExistBlock;
-(void)cbc_mac_cn_all:(NSInteger)keyLen atype:(NSInteger)algorithmType otype:(NSInteger)operatorType data:(NSString *)dataStr delay:(NSInteger)timeout withResultBlock:(void (^)(NSString *))cbcmacBlock;
-(void)getKsn:(void(^)(BOOL isSuccess,NSDictionary *dict))getKsnBlock;
-(void)getIccCardNo: (NSString *)aterminalTime;
-(void)iccCashBack:(NSString *)transactionTime random:(NSString *)aRandom;
#pragma mark init emv app
-(NSMutableDictionary *)getEMVAPPDict;
#pragma mark init emv capk
-(NSMutableDictionary *)EmvAppTag;
-(void)getKeyCheckValue:(CHECKVALUE_KEYTYPE)checkValueType keyIndex:(NSInteger)keyIndex;
-(void)setBuzzerStatus:(NSInteger)status;//Set whether the buzzer is muted, 0 is not muted, other values are muted
-(void)setAESKey:(NSString *)AESCiphertext CRC:(NSString *)CRC timeout:(NSInteger)timeout;
-(void)getAESTransmissionKey:(NSInteger)timeout;
-(void)getShutDownTime;
-(void)setPanStatus:(PanStatus)panStatus;
-(void)setPanMaskFormat:(NSInteger)frontLength backLength:(NSInteger)backLength;
-(void)getDevicePublicKey:(NSInteger)timeout;
-(void)setShutDownTimeOnConnected:(NSInteger)time;
-(void)getShutDownTimeOnConnected;
-(void)updateKeyByTR_31:(NSInteger)keyIndex keyBlock:(NSString *)keyBlock;
-(void)updateKeyByTR_31:(NSInteger)keyIndex keyBlock:(NSString *)keyBlock timeout:(NSInteger)timeout;
-(void)generateSessionKeys;
-(void)updateRSA:(NSString *)publicKey pemFile:(NSString *)pemFile;
-(void)getEncryptData:(NSData *)data keyType:(NSString*)keyType keyIndex:(NSString *)keyIndex timeOut:(NSInteger)timeout;
-(void)getMPUCardInfo:(void(^)(NSDictionary *dict))mpuInfoBlock;
-(void)getMIccCardData:(NSString *)transactionTime;
-(void)updateKeyByTR_31VersionD:(NSInteger)keyIndex ksn:(NSString *)ksn keyBlock:(NSString *)keyBlock;
-(void)powerOnFelica:(NSInteger)timeout;
-(void)powerOffFelica:(NSInteger)timeout;
-(void)sendApduByFelica:(NSString *)apduString timeout:(NSInteger)timeout;
-(void)generateTransportKey:(NSInteger)timeout dataBlock:(void(^)(NSDictionary *))dataBlock;
-(void)updateIPEKByTransportKey:(NSString *)groupKey tracksn:(NSString *)trackksn trackipek:(NSString *)trackipek trackipekCheckValue:(NSString *)trackipekCheckValue emvksn:(NSString *)emvksn emvipek:(NSString *)emvipek emvipekcheckvalue:(NSString *)emvipekcheckvalue pinksn:(NSString *)pinksn pinipek:(NSString *)pinipek pinipekcheckValue:(NSString *)pinipekcheckValue block:(void(^)(BOOL isSuccess))resultBlock;
-(void)updateWorkKeyByTransportKey:(NSString *)pik pinKeyCheck:(NSString *)pikCheck trackKey:(NSString *)trk trackKeyCheck:(NSString *)trkCheck macKey:(NSString *)mak macKeyCheck:(NSString *)makCheck keyIndex:(NSInteger) mKeyIndex timeout:(NSInteger)timeout block:(void(^)(BOOL isSuccess))resultBlock;
-(void)sendCVV:(NSString *)cvvStr resultBlock:(void(^)(BOOL))resultBlock;
-(void)getEncryptedDataBlock:(NSInteger)keyIndex dataBlock:(void(^)(NSDictionary *))dataBlock;
-(void)setIsSaveLog:(BOOL)IsSaveLog
              block:(void(^)(BOOL isSuccess,NSString *stateStr))IsSaveLogBlock;
-(void)doTradeLogOperation:(NSInteger)operationType
                      data:(NSInteger)data
                     block:(void(^)(BOOL isSuccess,NSInteger markType, NSDictionary *stateStr))doTradeLogBlock;
-(void)pollOnMifareCard:(NSInteger)timeout dataBlock:(void(^)(NSDictionary *))dataBlock;
-(void)authenticateMifareCard:(MifareCardType)mifareCardType keyType:(MifareKeyType)keyType block:(NSString *)block keyValue:(NSString *)keyValue timeout:(NSInteger)timeout resultBlock:(void(^)(BOOL isSuccess))resultBlock;
-(void)operateMifareCardData:(MifareCardOperationType)operationType block:(NSString *)block data:(NSString *)data timeout:(NSInteger)timeout dataBlock:(void(^)(NSDictionary *))dataBlock;
-(void)readMifareCard:(MifareCardType)mifareCardType block:(NSString *)block timeout:(NSInteger)timeout dataBlock:(void(^)(NSDictionary *))dataBlock;
-(void)writeMifareCard:(MifareCardType)mifareCardType block:(NSString *)block data:(NSString *)data timeout:(NSInteger)timeout resultBlock:(void(^)(BOOL isSuccess))resultBlock;
-(void)finishMifareCard:(NSInteger)timeout resultBlock:(void(^)(BOOL isSuccess))resultBlock;
-(void)setIsOperateMifare:(BOOL)isOperateMifare;
-(void)setIsSupportClsSelectEmvApp:(BOOL)isSupportClsSelectEmvApp;
-(NSDictionary *)getEncryptDataDict;
-(void)sendCvmPin:(NSString *)pin isEncrypted:(BOOL)isEncrypted;
-(NSString *)getCvmKeyList;
-(NSArray *)getCvmKeyListArr;
-(NSInteger)getCvmPinTryLimit;
-(NSString *)buildCvmPinBlock:(NSDictionary *)encryptedDataDict pin:(NSString *)pin;
-(void)operateLEDByType:(LEDType)ledType colorValue:(NSString *)colorValue ledDirection:(LEDDirection)ledDirection ledStatus:(LEDStatus)ledStatus lightTime:(NSInteger)lightTime lightOffTime:(NSInteger)lightOffTime blinksTimes:(NSInteger)blinksTimes resultBlock:(void(^)(BOOL isSuccess))resultBlock;
-(void)playBuzzerByType:(BuzzerType)buzzerType buzzerOnTime:(NSInteger)buzzerOnTime buzzerOffTime:(NSInteger)buzzerOffTime buzzerTimes:(NSInteger)buzzerTimes resultBlock:(void(^)(BOOL isSuccess))resultBlock;
-(NSDictionary *)getEncryptedTrack2Data;
-(void)getEncryptedTrack2Data:(void(^)(NSString *ksn, NSString *track2Data))resultBlock;
-(void)setCustomLogoDisplay:(LcdModeAlign)alcdModeAlign customLogoStr:(NSString *)customLogoStr timeout:(NSInteger)timeout resultBlock:(void(^)(BOOL isSuccess))resultBlock;
-(NSString *)getRandomNumByLen:(NSInteger)length;
-(void)getRandomNumByLen:(NSInteger)length resultBlock:(void(^)(NSString *randomStr))resultBlock;
@end

