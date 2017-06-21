/*
 ============================================================================
 Name        : ACDevice.h
 Version     : 1.0.0
 Copyright   : www.keruiyun
 Description : 空调
 ============================================================================
 */

#import <Foundation/Foundation.h>

#import "Device.h"


@interface ACDevice : Device
{
}

@property (nonatomic, strong) NSString* power;
@property (nonatomic, strong) NSString* mode;
@property (nonatomic, strong) NSString* temperature;
@property (nonatomic, strong) NSString* swingUpDown;
@property (nonatomic, strong) NSString* swingLeftRight;
@property (nonatomic, strong) NSString* timer;
@property (nonatomic, strong) NSString* fanspeed;
@property (nonatomic, strong) NSString* turbo;
@property (nonatomic, strong) NSString* airSwap;
@property (nonatomic, strong) NSString* light;
@property (nonatomic, strong) NSString* warmUp;
@property (nonatomic, strong) NSString* sleep;
@property (nonatomic, strong) NSString* airClean;

@end
