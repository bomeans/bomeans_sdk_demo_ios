/*
 ============================================================================
 Name        : TVRemoterMatchViewController.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The tv remoter match view controller
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "Device.h"


@interface TVRemoterMatchViewController : UIViewController
{
}

@property (nonatomic, strong) Device* device;
@property (nonatomic, strong) NSArray* modelArray;

@end
