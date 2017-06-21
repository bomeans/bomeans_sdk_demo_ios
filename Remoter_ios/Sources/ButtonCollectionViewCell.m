/*
 ============================================================================
 Name        : ButtonCollectionViewCell.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : 扩展按键
 ============================================================================
 */

#import "ButtonCollectionViewCell.h"


@interface ButtonCollectionViewCell ()
{
    IBOutlet UILabel* __weak _nameLabel;
}

@end

@implementation ButtonCollectionViewCell

@synthesize nameLabel = _nameLabel;

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    [UIView beginAnimations:nil context:nil];
    
    if (highlighted)
    {
        self.layer.opacity = 0.5f;
    }
    else
    {
        self.layer.opacity = 1.0f;
    }
    
    [UIView commitAnimations];
}

@end
