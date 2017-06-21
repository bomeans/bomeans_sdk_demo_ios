/*
 ============================================================================
 Name        : AdsPage.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The advertisement page
 ============================================================================
 */

#import "AdsPage.h"


@interface AdsPage ()
{
    UIButton* _imageButton;
}
@end

@implementation AdsPage

@synthesize imageButton = _imageButton;

- (void)dealloc
{
}

- (id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
	if ((self = [super initWithReuseIdentifier:reuseIdentifier]))
    {
		_imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageButton.userInteractionEnabled = NO;
        _imageButton.frame = self.bounds;
		_imageButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:_imageButton];
	}
    
	return self;
}

@end
