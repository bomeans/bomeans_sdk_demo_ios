//
//  BIRIpAndMac.h
//  IRLib
//
//  Created by ldj on 2015/6/13.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BIRIpAndMac : NSObject

@property (setter= setMac:,getter=getMac)NSString* mac;   // mac address like aa.bb.cc.dd.ee.11.22
@property (setter= setIp:,getter=getIp) NSString* ip;     // ip address like 192.168.100.10
@property NSString* version;                              // 版本號碼
@property NSString* extraInfo;                            // 額外資訊

// 取得 ip .
// example 192.168.1.1
// return 為 a[0]=192 a[1]=168 a[2]=1 a[3]=1
-(const unsigned char*) getIPNumber;

// 取得mac .
// example aa:bb:cc:dd
// return
//  為a[0]=0xaa a[1]=0xbb a[2]=0xcc a[3]=0xdd ...
-(const unsigned char*) getMacNumber;


@end
