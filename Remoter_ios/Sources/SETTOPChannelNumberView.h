/*
 ============================================================================
 Name        : SETTOPChannelNumberView.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : 机顶盒数字选择界面
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "Device.h"


@interface SETTOPChannelNumberView : UIView

@property (nonatomic, strong) Device* device;
@property (nonatomic, readonly) NSArray* keyArray;

- (void)reloadData;

@end
