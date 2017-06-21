/*
 ============================================================================
 Name        : FanRemoterMatchViewController.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : 风扇匹配
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "Device.h"


@interface FanRemoterMatchViewController : UIViewController
{
}

@property (nonatomic, strong) Device* device;
@property (nonatomic, strong) NSArray* modelArray;

@end
