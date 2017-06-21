/*
 ============================================================================
 Name        : ColorView.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : 选色板
 ============================================================================
 */

#import <UIKit/UIKit.h>

@protocol ColorViewDelegate <NSObject>

- (void)colorViewSelected:(UIColor*)color;

@end

@interface ColorView : UIImageView

@property (nonatomic, weak) id<ColorViewDelegate> delegate;
@property (nonatomic, assign) CGFloat bright;

- (void)increaseBright;
- (void)decreaseBright;

@end
