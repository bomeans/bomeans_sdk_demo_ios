//
//  BIRReadFirmwareVersionCallback.h
//  IRLib
//
//  Created by ldj on 2017/1/25.
//  Copyright © 2017年 lin. All rights reserved.
//
//  用來回應 getIrBlasterFirmwareVersion 使用的call back

#ifndef BIRReadFirmwareVersionCallback_h
#define BIRReadFirmwareVersionCallback_h

@protocol BIRReadFirmwareVersionCallback <NSObject>

@required

-(void) onFirmwareVersionReceived : (NSString*)versionString;

// when error happend

-(void) onError : (int)errorCode;



@end


#endif /* BIRReadFirmwareVersionCallback_h */
