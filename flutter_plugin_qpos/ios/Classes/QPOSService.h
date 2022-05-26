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
    PosType_BLUETOOTH_new, //new bluetooth mode
    PosType_BLUETOOTH_2mode //bluetooth 2 mode
};

typedef NS_ENUM(NSInteger, UpdateInformationResult) {
    UpdateInformationResult_UPDATE_SUCCESS,
    UpdateInformationResult_UPDATE_FAIL,
    UpdateInformationResult_UPDATE_PACKET_VEFIRY_ERROR,
    UpdateInformationResult_UPDATE_PACKET_LEN_ERROR,
    UpdateInformationResult_UPDATE_LOWPOWER,
    UpdateInformationResult_UPDATING
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

typedef NS_ENUM(NSInteger, EmvOption)
{
    EmvOption_START, EmvOption_START_WITH_FORCE_ONLINE
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
    Error_QPOS_MEMORY_OVERFLOW
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
    DHError_QPOS_MEMORY_OVERFLOW
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
    Display_MSR_DATA_READY
    
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
    TransactionResult_TRADE_LOG_FULL
    
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

typedef NS_ENUM(NSInteger, TransactionType) {
    TransactionType_GOODS, // GOODS
    TransactionType_SERVICES, // SERVICES
    TransactionType_CASH,//CASH
    TransactionType_CASHBACK, // CASH BACK
    TransactionType_INQUIRY, // INQUIRY
    TransactionType_TRANSFER, // TRANSFER
    TransactionType_ADMIN,// MANAGEMENT
    TransactionType_CASHDEPOSIT,//DEPOSIT
    TransactionType_PAYMENT,// PAYMENT
    
    //add 2014-04-02
    TransactionType_PBOCLOG,//        0x0A            /*PBOCLog(electronic cash log)*/
    TransactionType_SALE,//           0x0B            /*CONSUMPTION*/
    TransactionType_PREAUTH,//        0x0C            /*PRE-AUTHORIZATION*/
    TransactionType_ECQ_DESIGNATED_LOAD,//        0x10                /*Electronic cash Q designated account deposit*/
    TransactionType_ECQ_UNDESIGNATED_LOAD,//    0x11                /*Electronic cash fee is not specified in the account*/
    TransactionType_ECQ_CASH_LOAD,//    0x12    /*Electronic cash fee cash deposit*/
    TransactionType_ECQ_CASH_LOAD_VOID,//            0x13                /*Electronic cash deposit cancellation*/
    TransactionType_ECQ_INQUIRE_LOG,//    0x0A    /*Electronic cash log (same as PBOC log)*/
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
    CardTradeMode_SWIPE_TAP_INSERT_CARD_UNALLOWED_LOW_TRADE,  //no NFC, only swipe and chip.
    CardTradeMode_ONLY_TAP_CARD,
    CardTradeMode_SWIPE_TAP_INSERT_CARD_NOTUP,
    CardTradeMode_TAP_INSERT_CARD_NOTUP,//
    CardTradeMode_TAP_INSERT_CARD_TUP,//
    CardTradeMode_SWIPE_TAP_INSERT_CARD_Down,//下翻建
    CardTradeMode_SWIPE_TAP_INSERT_CARD_NOTUP_UNALLOWED_LOW_TRADE
};


typedef NS_ENUM(NSInteger, DoTradeMode) {
    DoTradeMode_COMMON,
    DoTradeMode_CHECK_CARD_NO_IPNUT_PIN,
    DoTradeMode_IS_DEBIT_OR_CREDIT
};

typedef NS_ENUM(NSInteger,EncryptType) {
    EncryptType_plaintext,
    EncryptType_encrypted
};
typedef NS_ENUM(NSInteger,EMVOperation) {
    EMVOperation_clear,
    EMVOperation_add,
    EMVOperation_delete,
    EMVOperation_getList,
    EMVOperation_update,
    EMVOperation_quickemv
};

typedef NS_ENUM(NSInteger,PanStatus) {
    PanStatus_DEFAULT,
    PanStatus_PLAINTEXT,
    PanStatus_ENCRYPTED
};

typedef NS_ENUM(NSInteger,SessionKeyType) {
    SessionKeyType_PINKEY,
    SessionKeyType_TRACKKEY,
    SessionKeyType_PINKEY_TRACKKEY
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
-(void)onRequestCvmApp:(NSDictionary *)dataArr;
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
-(void)startAudio;
-(void)stopAudio;
//start trade api
-(void)doTrade;
-(void)doTrade:(NSInteger) timeout;
-(void)doTrade:(NSInteger)keyIndex delays:(NSInteger)timeout;
-(void)doCheckCard;
-(void)doCheckCard:(NSInteger) timeout;
-(void)doCheckCard:(NSInteger) timeout keyIndex:(NSInteger) mKeyIndex;
//open quick emv
-(void)setIsQuickEMV:(BOOL)isQuickEMV;
-(BOOL)getQuickEMV;
-(void)doEmvApp: (EmvOption)aemvOption;
-(void)setAmount: (NSString *)aAmount aAmountDescribe:(NSString *)aAmountDescribe currency:(NSString *)currency transactionType:(TransactionType)transactionType;
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
//get ios sdk version
-(NSString *)getSdkVersion;
//get pos infomation
-(void)getQPosInfo;
-(void)getQPosId;

-(void)sendPinEntryResult:(NSString *)pin;
-(void)cancelPinEntry;
-(void)bypassPinEntry;

//Set the currency identifier displayed by the POS. For example: $
-(void)setAmountIcon:(NSString *)aAmountIcon;
-(void)setAmountIcon:(AmountType) amtType amtIcon:(NSString *)aAmountIcon;
//update emv configure api by bin file
-(void)updateEmvConfig:(NSString *)emvAppCfg emvCapk:(NSString*)emvCapkCfg;
-(void)readEmvAppConfig;
-(void)readEmvCapkConfig;
//update emv configure api by xml file
-(void)updateEMVConfigByXml:(NSString *)xmlStr;
//update emv configure api by TLV
-(void)updateEmvAPPByTlv:(EMVOperation)emvOperation appTlv:(NSString *)appTlv;//appTlv更新emv配置
-(void)updateEmvCAPKByTlv:(EMVOperation)emvOperation capkTlv:(NSString *)capkTlv;//capkTlv更新emv配置
//update emv app configure
-(void)updateEmvCAPK:(NSInteger )operationType data:(NSArray *)data  block:(void (^)(BOOL isSuccess, NSString *stateStr))updateCAPKBlock;
-(void)updateEmvAPP:(NSInteger )operationType data:(NSArray*)data  block:(void (^)(BOOL isSuccess, NSString *stateStr))updateEMVAPPBlock;

//update workkey api
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
//you can use this api to get pinblock and pinksn
-(void)getPin:(NSInteger)encryptType keyIndex:(NSInteger)keyIndex maxLen:(NSInteger)maxLen typeFace:(NSString *)typeFace cardNo:(NSString *)cardNo data:(NSString *)data delay:(NSInteger)timeout withResultBlock:(void (^)(BOOL isSuccess, NSDictionary * result))getPinBlock;
-(NSDictionary*)syncGetPin:(NSInteger)encryptType keyIndex:(NSInteger)keyIndex maxLen:(NSInteger)maxLen typeFace:(NSString *)typeFace cardNo:(NSString *)cardNo date:(NSString *)data delay:(NSInteger)timeout;

//you can use this api to get value of special emv tag.
-(NSDictionary *)getICCTag:(NSInteger) cardType tagCount:(NSInteger) mTagCount tagArrStr:(NSString*) mTagArrStr;
-(NSDictionary *)getICCTag:(EncryptType)encryTypeStr cardType:(NSInteger)cardType tagCount:(NSInteger) mTagCount tagArrStr:(NSString*)mTagArrStr;
-(NSDictionary *)getICCTagNew:(EncryptType)encryTypeStr cardType:(NSInteger)cardType tagCount:(NSInteger)mTagCount tagArrStr:(NSString *)mTagArrStr;
//you can use api to custom input on pos.
-(void)customInputDisplay:(NSInteger)operationType displayType:(NSInteger)dispType maxLen:(NSInteger)maxLen DisplayString:(NSString *)displayStr delay:(NSInteger)timeout withResultBlock:(void (^)(BOOL isSuccess, NSString * result))customInputDisplayResult;

-(void)isCardExist:(NSInteger)timeout withResultBlock:(void (^)(BOOL))isCardExistBlock;
-(void)isCardExistInOnlineProcess:(NSInteger)timeout withResultBlock:(void (^)(BOOL))isCardExistBlock;
#pragma mark init emv app
-(NSMutableDictionary *)getEMVAPPDict;
#pragma mark init emv capk
-(NSMutableDictionary *)EmvAppTag;
-(void)getKeyCheckValue:(CHECKVALUE_KEYTYPE)checkValueType keyIndex:(NSInteger)keyIndex;
-(void)setBuzzerStatus:(NSInteger)status;//Set whether the buzzer is muted, 0 is not muted, other values are muted
-(void)setAESKey:(NSString *)AESCiphertext CRC:(NSString *)CRC timeout:(NSInteger)timeout;
-(void)getAESTransmissionKey:(NSInteger)timeout;
-(void)getShutDownTime;
-(void)setPanStatus:(NSInteger )panStatus;
-(void)getDevicePublicKey:(NSInteger)timeout;
-(void)generateSessionKeys:(SessionKeyType)keyType;
-(void)updateRSA:(NSString *)pemFile;
-(void)sendCvmPin:(NSString *)pin isEncrypted:(BOOL)isEncrypted;
-(void)pollOnMifareCard:(NSInteger)timeout dataBlock:(void(^)(NSDictionary *))dataBlock;
-(void)authenticateMifareCard:(MifareCardType)mifareCardType keyType:(MifareKeyType)keyType block:(NSString *)block keyValue:(NSString *)keyValue timeout:(NSInteger)timeout resultBlock:(void(^)(BOOL isSuccess))resultBlock;
-(void)operateMifareCardData:(MifareCardOperationType)operationType block:(NSString *)block data:(NSString *)data timeout:(NSInteger)timeout dataBlock:(void(^)(NSDictionary *))dataBlock;
-(void)readMifareCard:(MifareCardType)mifareCardType block:(NSString *)block timeout:(NSInteger)timeout dataBlock:(void(^)(NSDictionary *))dataBlock;
-(void)writeMifareCard:(MifareCardType)mifareCardType block:(NSString *)block data:(NSString *)data timeout:(NSInteger)timeout resultBlock:(void(^)(BOOL isSuccess))resultBlock;
-(void)finishMifareCard:(NSInteger)timeout resultBlock:(void(^)(BOOL isSuccess))resultBlock;
-(void)setIsOperateMifare:(BOOL)isOperateMifare;
@end

