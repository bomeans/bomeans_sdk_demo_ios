//
//  BomeansWifiToIRDiscovery.h
//  IRLib
//
//  Created by ldj on 2015/6/12.
//  Copyright (c) 2015年 lin. All rights reserved.
//
/*  2016 07/29
//    加入 -(BOOL) discoryTryTime:withIP:andDelegate:    找特定ip 的device
//    -(BOOL) discoryBlockTryTime: withIP : (NSString*)ip; 找特定ip 的device
//    -(BOOL) discoryBlockTryTime: filterMac:              過濾出特定的mac
*/

#import <Foundation/Foundation.h>

//#import "../GCDAsyncUdpSocket.h"

@class BIRIpAndMac;
@protocol GCDAsyncUdpSocketDelegate;


@interface BomeansWifiToIRDiscovery : NSObject//<GCDAsyncUdpSocketDelegate>

@property NSMutableDictionary *allWifiToIr;    // 所有找到的wifiToIr
                                                        // 其中. key 是String 為mac address
                                                        // value 是BIRIpAndMac object

-(id) init;

/**
 在背景找尋WifiToIR Device
 input :
   tryMaxCount : 嘗試找尋次數
   delegate    : 你的callback 設計必須合乎 @protocol BIRWifiToIRDiscoveryDelegate
 return
  YES 只是表示. discory 有開始. 並非正的有找到
 note :
   本method 會每0.2 秒送出一次找尋wifiToIR 設備的指令. 最多送出tryMaxCount 次數
   呼叫本method 不會讓你的呼叫者block 住. 會透過delegate 通知你找尋的結果
**/
-(BOOL) discoryTryTime : (int) tryMaxCount
           andDelegate : (id) delegate;


-(BOOL) discoryTryTime:(int)tryMaxCount
               withIP : (NSString*)ip
           andDelegate:(id)delegate;

/**
 找尋WifiToIR Device 
 input :
    tryMaxCount : 嘗試找尋次數
 return :
    YES  有找到wifiToIR 結果存放在property allWifiToIr 當中
    NO   沒有找到.
 note :
  本method 會每0.05 秒送出一次找尋wifiToIR 設備的指令. 最多送出tryMaxCount 次數
  呼叫本method 會讓你的呼叫者block 住.
 **/
-(BOOL) discoryBlockTryTime : (int) tryMaxCount;
/**
找尋特定IP 的wifiToIR Device
input :
    tryMaxCount : 嘗試找尋次數
    ip          : 預找尋的IP
 return :
    YES  有找到wifiToIR 結果存放在property allWifiToIr 當中
    NO   沒有找到.
**/
-(BOOL) discoryBlockTryTime : (int) tryMaxCount
                     withIP : (NSString*)ip;

/**
 找尋WifiToIR Device 過濾特定mac address
 input :
   tryMaxCount : 嘗試找尋次數
   mac         : 預過濾的mac address
 return :
    YES  有找到特定的mac address
    NO   沒有找到.
 
 note :
   這個方法會去找出所有在網路上的wifiToIR . 然後過濾出某個mac . 如此mac 存在. return YES, 不存在. return NO
 **/
-(BOOL) discoryBlockTryTime:(int)tryMaxCount
                 filterMac : (NSString*)mac;


/**
 停止找尋. 呼叫 discoryTryTime : andDelegate :  後如要中斷找尋可以呼叫此method
 **/
-(void) cancelNext;

/**
 是否有找到wifiToIR
 return :
   YES  有找到
   NO   沒有找到
 **/
-(BOOL) isFind;


@end


// 給 BomeansWifiToIRDiscovery 用的 Delegate
@protocol BIRWifiToIRDiscoveryDelegate

@optional
// 找到新的 wifitToIR
//  參數:
//    obj           : 一個 BomeansWifiToIRDiscovery obj
//    ipAndMac      : 找到新的WifiToIR 的ip 跟mac address
-(void)      wifiToIR : (id)obj
      discoryWifiToIr : (BIRIpAndMac*) ipAndMac;

// 持續找尋中
//  參數:
//    obj           : 一個 BomeansWifiToIRDiscovery obj
//    step          : 第幾次找尋
-(void)       wifiToIR : (id)obj
               process : (int)step;

// 找尋結果
//  參數:
//    obj           : 一個 BomeansWifiToIRDiscovery obj
//  result          : 結果
//                     YES  有找到WifiToIR
//                     NO   沒有找到wifiToIR
-(void)       wifiToIR : (id)obj
            endDiscory : (BOOL)result;

@end



