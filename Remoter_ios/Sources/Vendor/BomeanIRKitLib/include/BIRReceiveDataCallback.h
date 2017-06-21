//
//  BIRReceiveDataCallback.h
//
//
//  Created by ldj on 2016/11/22.
//  Copyright © 2016年 lin. All rights reserved.
//

#ifndef __BIRReceiveDataCallback_H__
#define __BIRReceiveDataCallback_H__



@protocol  BIRReceiveDataCallback2

@required
// 當有資料取得
// NSData
//  data in byte (8bit data)
-(void) onDataReceived : (NSData*) receivedDataBytes;

-(void) onLearningDataReceived : (NSData*)receivedDataBytes  withFrequency : (int) carrierFrequency ;

-(void) onLearningFailed;


@end


@protocol BIRReceiveDataCallback

// 當有資料取得
// NSData
//  data in byte (8bit data)
-(void) onDataReceived : (NSData*) receivedDataBytes;

@end








#endif /* BIRReceiveDataCallback_h */
