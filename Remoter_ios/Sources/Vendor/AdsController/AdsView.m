/*
 ============================================================================
 Name        : AdsView.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The advertisement view
 ============================================================================
 */

#import "AdsView.h"
#import "SYPageControl.h"


@implementation AdsView

- (void)dealloc
{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.pageControl setHidden:NO];
        self.pageControl.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:168/255.0f green:168/255.0f blue:168/255.0f alpha:1];
        self.pageControl.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:55/255.0f green:55/255.0f blue:55/255.0f alpha:1];
    }
    
    return self;
}

@end
