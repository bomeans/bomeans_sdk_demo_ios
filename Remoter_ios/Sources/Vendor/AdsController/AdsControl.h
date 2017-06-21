/*
 ============================================================================
 Name        : AdsControl.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The advertisement control
 ============================================================================
 */

#import <UIKit/UIKit.h>


@interface AdsControl : UIView
{
}

@property (nonatomic, readonly) NSMutableArray* imageArray;
@property (nonatomic, readonly) NSMutableArray* adsUrlArray;

- (void)reloadData;

- (void)startAnimationWithTimeInterval:(NSTimeInterval)interval;
- (void)stopAnimation;

@end
