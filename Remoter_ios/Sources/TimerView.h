/*
 ============================================================================
 Name        : TimerView.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : 定时
 ============================================================================
 */

#import <UIKit/UIKit.h>

@protocol TimerViewDelegate <NSObject>

- (void)TimerViewSelected:(NSDate*)beginTime endDate:(NSDate*)endTime;

@end

@interface TimerView : UIView

@property (nonatomic, weak) id<TimerViewDelegate> delegate;

@end
