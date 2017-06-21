/*
 ============================================================================
 Name        : DVDOtherButtonsView.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : DVD扩展按键
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "Device.h"


@interface DVDOtherButtonsView : UIView

@property (nonatomic, strong) Device* device;
@property (nonatomic, strong) NSArray* mainKeyArray;

- (void)reloadData;

@end
