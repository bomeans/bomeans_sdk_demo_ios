//
//  BIRTVPicker.h
//  IRLib
//
//  Created by ldj on 2016/1/26.
//  Copyright (c) 2016年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BIRRemoteUID.h"

@protocol BIRTVPicker <NSObject>

// 開始smart picker
// return
//  提示給user 此次發碼送出的是哪一個key
-(NSString*) begin;

// 取得下一個要發的key
//  return
//   key id
-(NSString*) getNextKey;

// 送出目前必須送出的ir wave
// return
//  BIROK  送出正常
//  other  送出失敗
-(int) transmitIR;

// 設定當前測試的key 是否在目標機器上有動作
// input
//  haveWork : YES 有動作
//             FALSE 沒有動作
// return
//   BIR_PNext  必須再測試下一個key
//   BIR_PFind  找到remote
//   BIR_PFail  找不到remote
-(int) keyResult : (BOOL) haveWork;


// 取得選碼結果
// return
//  NSArray with object BIRRemoteUID
//  結果可能超過一個remote 
-(NSArray*) getPickerResult;



@end
