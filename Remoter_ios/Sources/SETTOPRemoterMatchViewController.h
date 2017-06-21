/*
 ============================================================================
 Name        : SETTOPRemoterMatchViewController.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : 机顶盒匹配界面
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "Device.h"


@interface SETTOPRemoterMatchViewController : UIViewController
{
}

@property (nonatomic, strong) Device* device;
@property (nonatomic, strong) NSArray* modelArray;

@end
