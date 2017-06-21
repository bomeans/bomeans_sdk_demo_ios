/*
 ============================================================================
 Name        : ACRemoterMatchViewController.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : 空调匹配
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "ACDevice.h"


@interface ACRemoterMatchViewController : UIViewController
{
}

@property (nonatomic, strong) ACDevice* device;
@property (nonatomic, strong) NSArray* modelArray;

@end
