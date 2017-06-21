/*
 ============================================================================
 Name        : AMPRemoterMatchViewController.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The AMP remoter match view controller
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "Device.h"


@interface AMPRemoterMatchViewController : UIViewController
{
}

@property (nonatomic, strong) Device* device;
@property (nonatomic, strong) NSArray* modelArray;

@end
