//
//  BomeansWifiToIR.h
//  IRLib
//
//  Created by ldj on 2017/1/18.
//  Copyright © 2017年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BIRIRBlaster.h"

@interface BomeansWifiToIR : NSObject<BIRIRBlaster>

-(id) init;

+(BOOL) setupWifiKitSSID : (NSString*)ssid
                passWord : (NSString*)password
                authMode : (int) authMode;


+(void) stopSetupWifiKitSSID;


// 取得 wifi to ir 是否有連線
-(int) wifiIRState;


// 對區域網路內的所有需要設定的小火山播送ssid 跟password
// 本funciton 會在backgroud 執行. 因此不會照成呼叫此method 的程式blcok 住
//  input :
//   ssid    :  欲連接的 ap ssid
//  password :  AP 的password
//  authMode :  認證加密方法
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
 * 設定小火山 電源開關 定時打開 時間
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
 * 設定小火山 電源開關 定時關 時間
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


-(int) wifiIR_SendUserCommand : (Byte)commandID
                  payLoad     : (NSData*) payLoad;


// 設定欲使用的wifi to ir 的ip
// input :
//  ip   wifi to ir 的ip
//  nil  取消ip 使用群播方法, 所有在同一個lan 下的wifi to ir 都會送出ir
-(void) setWifiToIrIP: (NSString*)ip;

// 取得目前使用中的wifiTo ir 的ip
//  return
//   wifi to ir 的ip
//   nil  使用群播的方法
-(NSString*) getWifiToIrIP;

@end
