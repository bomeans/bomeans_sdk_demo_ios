//
//  IRRemote.h
//  IRLib
//
//  Created by ldj on 2015/6/3.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#ifndef IRLib_IRRemote_h
#define IRLib_IRRemote_h

#import <Foundation/Foundation.h>

@class BIRKeyOption;
@class BIRGUIFeature;

// the protected def ir function
@protocol BIRRemote

@required
// 取得所有的key .. data in array is NSString
-(NSArray*) getAllKeys;

// 送出一個key
// for TV option 不使用
// for AC option can be nil 會自動切換到下一個選項
//     不是nil 直接設定成選項
// 小萬能的 AC
//  option 對 溫度來說 IR_ACKEY_TEMP 可設定成"UP" 溫度上升 or "DOWN"  溫度下降
-(int) transmitIR : (NSString*) keyId withOption :(NSString*) option;

// set the internal remote state, without sending out the IR data
-(int) setKeyOption : (NSString*) keyId withOption : (NSString*) option;

// 連續送出key 直到endTransmitIR
-(int) beginTransmitIR : (NSString*) keyId;
-(void) endTransmitIR;

// 取得module name
-(NSString*) getModuleName;
// 取得 brand name
-(NSString*) getBrandName;



@optional
// for AC use 取得所有的key
// return NSArray with NSString
-(NSArray*) getActiveKeys;

// 取得key 的options
-(BIRKeyOption*) getKeyOption: (NSString*) keyId;


// 設定要repreat 次數. 只對TV 有用. 小萬能無用
-(void) setRepeatCount : (int)count;
-(int) getRepeatCount;

// 取得AC 的GUI Feature
-(BIRGUIFeature*) getGuiFeature;

// 取得AC 的timer key
-(NSArray*) getTimerKeys;

// 設定冷氣的 off time
-(void) setOffTimeHour : (int)h minute :(int) m  second : (int) s;
// 設定冷氣的 on tim
-(void) setOnTimeHour : (int)h minute :(int) m  secode : (int) s;

// 取得AC 的狀態資料
// return :
//     array 中的每一個原素是BIRACStoreDataItem
// 此funciotn 會把AC remote 目前的狀態資訊通通儲存到Array 中
// 你必須把array 中的每一個元素的資料存放到磁碟中. 在你下次建立起同一個AC remote 時, 利用restoreACStoreDatas 來把AC 的狀態回復
// note :
//  適用於AC remote 跟AC 小萬能, 其他類都不適用
-(NSArray*) getACStoreDatas;


// 回復AC 的狀態
//  input :
//   sotreData 回復資料Array , Array 中的每一個原素必須是BIRACStoreDataItem
//  return :
//   YES 回復成功
//   NO  回復失敗, 原因是給的restore 跟此AC 並不吻合
// note :
//  適用於AC remote 跟AC 小萬能, 其他類都不適用
-(BOOL) restoreACStoreDatas : (NSArray*)storeData;


@end

#endif   // IRLib_IRRemote_h
