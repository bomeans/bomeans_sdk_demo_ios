/*
 ============================================================================
 Name        : TVOtherButtonsView.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : 电视扩展按键
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "Device.h"


@interface TVOtherButtonsView : UIView

@property (nonatomic, strong) Device* device;
@property (nonatomic, strong) NSArray* mainKeyArray;

- (void)reloadData;

@end