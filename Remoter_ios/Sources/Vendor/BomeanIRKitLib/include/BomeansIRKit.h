//
//  BomeansIRKit.h
//  IRLib
//
//  Created by ldj on 2015/6/3.
//  Copyright (c) 2015年 lin. All rights reserved.
//
//

#ifndef __BOMEANS_MODULE__H__
#define __BOMEANS_MODULE__H__

#import <Foundation/Foundation.h>
#import "BIRRemote.h"
#import "BIRReaderProtocol.h"
#include "BomeansConst.h"


@protocol BIRReadFirmwareVersionCallback;
@class BIRVoiceSearchResultItem;


@interface BomeansIRKit : NSObject

@property  (nonatomic) NSString* apiKey;

+(BomeansIRKit*) setupAPI : (NSString*) apiKey;

// 建立此物件
-(id) initWithKey : (NSString*) apiKey;

// 把cache 中的檔案清空
+(void) cleanCache;

// 設定是否使用中國大陸的bomeans web server
// input :
//   ch  : YES  是的. 使用中國大陸
//         NO   不是. (預設值為NO)
+(void) setUseChineseServer : (BOOL) ch;

/** 
 Set use server, the function can be instead of setUseChineseServer(Bool)
 @param BIRServer: if input invalid value, will be use BIR_TW
*/
+(void) setServer:(BIRServer)server;


#if defined(_KIT_SUPPORT_WIFI)
// 取得 wifi to ir 是否有連線
-(int) wifiIRState;

// 控制小火山的led 開關
//  input :
//    onOff  :
//      YES  led 亮
//      NO  led 不亮
//  return :
//   BIROK  設定成功
//   other  設定失敗..
-(int) wifiIRLed_OnOff : (BOOL) onOff;

// 控制小火山的led 顏色
//  input
//    red    :  1.0~0 之間 多紅
//    green  :  1.0~0 之間 多綠
//    blue   :  1.0~0 之間 多藍
//  return :
//   BIROK  設定成功
//   other  設定失敗..
-(int) wifiIRLed_Color : (float) red
            greenColor : (float) green
             blueColor : (float) blue;


// 設定小火山 目前的時間
//  input :
//    hour  : 小時
//    min   : 分
//    sec   : 秒
//  return :
//    BIROK 設定成功
//    other 設定失敗
-(int) wifiIR_SetNowTime : (int) hour
                     min : (int) min
                     sec : (int) sec;

// 設定小火山 LED 定時打開時間
//  input :
//    onOff : 啟用/停用 定時打開 功能
//       YES : 啟動
//       NO  : 停用
//    hour  : 小時
//    min   : 分
//    sec   : 秒
//  return :
//    BIROK 設定成功
//    other 設定失敗
-(int) wifiIRLed_SetOnTimer : (BOOL) onOff
                       hour : (int) hour
                        min : (int) min
                        sec : (int) sec;


// 設定小火山 LED 定時關掉時間
//  input :
//    onOff : 啟用/停用 定時關掉 功能
//       YES : 啟動
//       NO  : 停用
//    hour  : 小時
//    min   : 分
//    sec   : 秒
//  return :
//    BIROK 設定成功
//    other 設定失敗
-(int) wifiIRLed_SetOffTimer : (BOOL) onOff
                        hour : (int) hour
                         min : (int) min
                         sec : (int) sec;


// 關掉小火山 的wifi 功能
//  note : 關掉後.. 不能在操作它了.. 直到你手動開啟他
-(int) wifiIR_TuneOffWifi;


// 設定小火山 wifi功能 定時打開時間
//  input :
//    onOff : 啟用/停用 定時打開 功能
//       YES : 啟動
//       NO  : 停用
//    hour  : 小時
//    min   : 分
//    sec   : 秒
//  return :
//    BIROK 設定成功
//    other 設定失敗
-(int) wifiIR_SetOnTimer : (BOOL) onOff
                    hour : (int) hour
                     min : (int) min
                     sec : (int) sec;



// 設定小火山 wifi功能 定時關掉時間
//  input :
//    onOff : 啟用/停用 定時關掉 功能
//       YES : 啟動
//       NO  : 停用
//    hour  : 小時
//    min   : 分
//    sec   : 秒
//  return :
//    BIROK 設定成功
//    other 設定失敗
-(int) wifiIR_SetOffTimer : (BOOL) onOff
                     hour : (int) hour
                      min : (int) min
                      sec : (int) sec;




/**
 * 設定小火山 電源開關 開啟/關閉
 * @param onOff :
 *   YES 打開
 *   NO 關掉
 * @return
 *   BIROK  設定成功
 */
-(int) wifiIRSwitch_OnOff : (BOOL) onOff;


/**
 * 設定小火山 電源開關 定時打開時間
 * @param onOff
 *   YES 打開
 *   NO 關掉
 * @param hour
 * @param min
 * @param sec
 * @return
 *   BIROK  設定成功
 */
-(int) wifiIRSwitch_SetOnTimer : (BOOL)onOff
                          hour : (int) hour
                           min : (int) min
                           sec : (int) sec;


/**
 * 設定小火山 電源開關 定時關時間
 * @param onOff
 *   YES 打開
 *   NO 關掉
 * @param hour
 * @param min
 * @param sec
 * @return
 *   BIROK  設定成功
 */
-(int) wifiIRSwitch_SetOffTimer : (BOOL)onOff
                           hour : (int) hour
                            min : (int) min
                            sec : (int) sec;



/**
 送出user command
 **/
-(int) wifiIR_SendUserCommand : (Byte)commandID
                  payLoad     : (NSData*) payLoad;



// 設定 wifi to ir 的 ssid 跟 password
// authmode 請參考 : enum BIRWifiAuthMode
-(BOOL) setupWifiKitSSID : (NSString*) ssid
                passWord : (NSString*) password
                authMode : (int)authMode;

-(void) stopSetWifiKitSSID;


// 設定欲使用的wifi to ir 的ip
// input :
//  ip   wifi to ir 的ip
//  nil  取消ip 使用群播方法, 所有在同一個lan 下的wifi to ir 都會送出ir
-(void) setWifiToIrIP: (NSString*)ip;


// 對區域網路內的所有需要設定的小火山播送ssid 跟password
// 本funciton 會在backgroud 執行. 因此不會照成呼叫此method 的程式blcok 住
//  input :
//   ssid    :  欲連接的 ap ssid
//  password :  AP 的password
//  authMode :  認證加密方法
//              請參考BIRWifiAuthMode
//  second   :  播送時間. 單位秒
//  delegate :  回call 的代理程式
//         請參考 @protocol BIRWifiToIRDiscoveryDelegate in BomeansDelegate.h
//  return :
//     BIROK   沒有錯誤. 開始發送.
//     other   沒有開始發送.
-(int)  broadcastSSID : (NSString*)ssid
             passWord : (NSString*)password
             authMode : (int) authMode
             waitTime : (NSInteger)second
             delegate : (id) __weak dg;



// 停止發送ssid 跟password
-(void) cancelBroadcastSSID;
#endif // of _KIT_SUPPORT_WIFI





// 建立一個Remote (不管是TV or AC 都是一樣的)
-(id <BIRRemote>) createRemoteType : (NSString*)type withBrand : (NSString*) brand andModel : (NSString*) model;

// 建立一個Remote (不管是TV or AC 都是一樣的)
-(id <BIRRemote>) createRemoteType : (NSString*)type withBrand : (NSString*) brand andModel : (NSString*) model
                            getNew : (BOOL) newData;


// 建立一個大萬能
// input :
//   type : remote type 如TV 為 "1"
//   brand : 廠牌 id
// return :
//   一個 BIRRemote
-(id<BIRRemote>) createBigCombineRemote : (NSString*)type withBrand : (NSString*) brand;


// 建立一個大萬能
// input :
//   type : remote type 如TV 為 "1"
//   brand : 廠牌 id
//   newData  : YES 抓取新的資料
//              NO  抓取catch 在local 端的資料, 如無cache 資料..抓取新的
// return :
//   一個 BIRRemote
-(id<BIRRemote>) createBigCombineRemote : (NSString*)type withBrand : (NSString*)brand getNew:(BOOL)newData;


// 建立智慧選碼器
// input  :
//   type : remote type 如TV 為 "1"
//   brand : 廠牌 id
//   newData  : YES 抓取新的資料
//              NO  抓取catch 在local 端的資料, 如無cache 資料..抓取新的
// return
//    一個object 符合BIRTVPicker protocol 設計, 如回傳是nil 表示建立失敗
//  note :
//   目前只能用在TV 類別, 其他類別都不能使用.
-(id) createSmartPicker : (NSString*)type withBrand : (NSString*)brand getNew:(BOOL)newData;


// 建立自訂key組智慧選碼器
// input  :
//   type : remote type 如TV 為 "1"
//   brand : 廠牌 id
//   keyArray : 自定義測試key組
//   newData  : YES 抓取新的資料
//              NO  抓取catch 在local 端的資料, 如無cache 資料..抓取新的
// return
//    一個object 符合BIRTVPicker protocol 設計, 如回傳是nil 表示建立失敗
//  note :
//   目前只能用在TV 類別, 其他類別都不能使用.
-(id) createSmartPicker : (NSString*)type withBrand : (NSString*)brand withKey : (NSArray*)keyArray getNew:(BOOL)newData;


/**
 * Create IR Reader for TV
 * @param newData 
    true: force to re-download the required data from the server;
    false: use cached data without pulling from the server again
 * @return
    a instrence object confim protocol BIRReader
 
    note :
     sell BIRReaderProtocol.h
 */
-(id<BIRReader>) createIRReader : (BOOL)newData;



// 設定repate count
-(void) setRepeatCount : (int) count;
-(int) getRepeatCount;

// 取得最後一次動作的error code
-(int) getLastErrorCode;

///
/// web api
///

// 取得type list
// input :
//  laguage  : 使用的語言 只有 cn tw en 可選用
// return :
//  nil     錯誤
//  other   正常. array 中的元素為 BIRTypeItem
-(NSArray*) webGetTypeList : (NSString*)language;

// 取得type list
// input :
//  laguage  : 使用的語言 只有 cn tw en 可選用
//   newData  : YES 抓取新的資料
//              NO  抓取catch 在local 端的資料, 如無cache 資料..抓取新的
// return :
//  nil     錯誤
//  other   正常. array 中的元素為 BIRTypeItem
-(NSArray*) webGetTypeList : (NSString*)language
                    getNew : (BOOL) newData;


// 取得廠牌list
// input :
//   typeId : 由 webGetTypeList 取得(Remote type)
//    start : 開始位置
//    num   : 共取得最多幾筆
//   language : 語言代號 只有 cn tw en 可選用
//  brandName : search 廠牌名稱. 給nil 表示不搜尋.. 列出所有的廠牌
// return :
//   nil   錯誤
//  other  正常, array 中的元素為 BIRBrandItem
-(NSArray*) webGetBrandList : (NSString*)typeId
                      start : (int)start
                     number : (int)number
                   language : (NSString*)language
                  brandName : (NSString*)brandName;


// 取得廠牌list
// input :
//   typeId : 由 webGetTypeList 取得(Remote type)
//    start : 開始位置
//    num   : 共取得最多幾筆
//   language : 語言代號 只有 cn tw en 可選用
//  brandName : search 廠牌名稱. 給nil 表示不搜尋.. 列出所有的廠牌
//   newData  : YES 抓取新的資料
//              NO  抓取catch 在local 端的資料, 如無cache 資料..抓取新的
-(NSArray*) webGetBrandList : (NSString*)typeId
                      start : (int)s
                     number : (int)num
                   language : (NSString*)lang
                  brandName : (NSString*)brandName
                     getNew : (BOOL) newData;


// 取得廠牌 list 依廠牌知名度排序
// input :
//   typeId : 由 webGetTypeList 取得(Remote type)
//    start : 開始位置
//    num   : 共取得最多幾筆
//   language : 語言代號 只有 cn tw en 可選用
//   newData  : YES 抓取新的資料
//              NO  抓取catch 在local 端的資料, 如無cache 資料..抓取新的
-(NSArray*) webGetTopBrandList : (NSString*)typeId
                         start : (int)s
                        number : (int)num
                      language : (NSString*)lang
                        getNew : (BOOL) newData;



// 取得某類型, 某廠牌下的所有Remote model
// input :
//   typeId  : 種類id 由取得type list 得到
//   brandId : 廠牌id 由取得廠牌list 得到
// return :
//   nil 錯誤
//   other 正常, array 中的元素為 BIRModelItem
-(NSArray*) webGetRemoteModelList : (NSString*)typeId
                         andBrand : (NSString*)brandId;


// 取得某類型, 某廠牌下的所有Remote model
// input :
//   typeId  : 種類id 由取得type list 得到
//   brandId : 廠牌id 由取得廠牌list 得到
//   newData  : YES 抓取新的資料
//              NO  抓取catch 在local 端的資料, 如無cache 資料..抓取新的
// return :
//   nil 錯誤
//   other 正常, array 中的元素為 BIRModelItem
-(NSArray*) webGetRemoteModelList : (NSString*)typeId
                         andBrand : (NSString*)brandId
                        getNew : (BOOL) newData;



// 取得某類型remote 所包含的key list
// input :
//     typeId  : 種類id 由取得type list 得到
//     language : 語言代號 只有 cn tw en 可選用
//   newData  : YES 抓取新的資料
//              NO  抓取catch 在local 端的資料, 如無cache 資料..抓取新的
// return :
//   nil 錯誤
//   other 正常, array 中的元素為 BIRKeyName
-(NSArray*) webGetKeyName : (NSString*)typeId
                 language : (NSString*)lang
                   getNew : (BOOL) newData;

// 自然語言搜尋
//  input :
//    voiceCommand : 自然語言字串 example "打看電視"
//    lang : 語言代號 只有 cn tw en 可選用
//  return :
//    nil 錯誤
//    other 搜尋結果
-(BIRVoiceSearchResultItem*) webVSearch : (NSString*)voiceCommand
                               language : (NSString*)lang;


// 取得smart picker 中用到的key list
// input :
//   typeId  : 種類id 由取得type list 得到
//   newData  : YES 抓取新的資料
//              NO  抓取catch 在local 端的資料, 如無cache 資料..抓取新的
// return :
//   nil 錯誤
//   other 正常, array 中的元素為 NSString
-(NSArray*) webGetSmartPickerKeyList : (NSString*)typeId
                              getNew : (BOOL)newData;


// 設定你的IR HW 介面
//  input :
//    yourHW  你的IR HW class , 必須設計 @protocol BIRIRBlaster
//    如輸入是nil 使用Bomeans 的wifiToIR
//    其他. .你的IR HW
//    20170126改 取消輸入nil時使用Bomeans的wifiToIR設定，近端請改設定為 BomeansWifiToIR object 
-(void) setIRHW : (id)yourHW;
+(void) setIRHW : (id)yourHW;


// 取得發碼mcu FW version
// input
//  dg 回呼通知
//  timeOut in seconde
//  建議timeOut .. wifiToIR 透過網路抓取FW timeOut 建議 5 sec 以上
+(void) getFWVersion : (id<BIRReadFirmwareVersionCallback>) dg
            timerOut : (double)timeOut;



// 取得最後一次動作的error code
// input :
//   *msgPtr  存放錯誤訊息字串
//     如是nil 表示不取得此字串
// return :
//   error code
// error code 請參考BomeansConst.h 中的
// emun BIRError { .... }
-(int) getErrorCode : (NSString**)msgPtr;


// 取得目前正在使用的IR HW
// -(id<BIRIrHW>) getIRHW;



@end    // of BomeansModule




#endif // of __BOMEANS_MODULE__H__



