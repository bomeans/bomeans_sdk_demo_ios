//
//  BomeansDelegate.h
//  IRLib
//
//  Created by ldj on 2015/6/17.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#ifndef IRLib_BomeansDelegate_h
#define IRLib_BomeansDelegate_h

// 給 BomeansIRKit -(int)  broadcastSSID : (NSString*)ssid  ... 使用的 Delegate
@protocol BIRBroadcastSSID_Delegate

@optional
// 通知還在進行broadcast SSID
//  參數:
//    obj  : 為一個 BomeansIRKit
//  second : 已進行了幾秒了
-(void) broadcastSSID : (id) obj
        process       : (int) second;

// 通知結束broadcast SSID
//    obj  : 為一個 BomeansIRKit
//   result : 設定結果
//     BIRResultTimeOut,       時間用光結束
//     BIRResultUserCancal     使用者中斷後結束
-(void) broadcastSSID : (id) obj
                end   : (int) result;

@end


#endif
