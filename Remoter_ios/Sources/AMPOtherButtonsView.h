/*
 ============================================================================
 Name        : AMPOtherButtonsView.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : AMP扩展按键
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "Device.h"


@interface AMPOtherButtonsView : UIView

@property (nonatomic, strong) Device* device;
@property (nonatomic, strong) NSArray* mainKeyArray;

- (void)reloadData;

@end
