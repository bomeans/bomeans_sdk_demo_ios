/*
 ============================================================================
 Name        : MP3OtherButtonsView.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : mp3扩展按键
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "Device.h"


@interface MP3OtherButtonsView : UIView

@property (nonatomic, strong) Device* device;
@property (nonatomic, strong) NSArray* mainKeyArray;

- (void)reloadData;

@end
