/*
 ============================================================================
 Name        : DeviceBrandItemCell.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device brand item cell
 ============================================================================
 */

#import "DeviceBrandItemCell.h"
#import "LocalizedStringTool.h"


@interface DeviceBrandItemCell ()
{
    IBOutlet UILabel* _nameLabel;
}

@end

@implementation DeviceBrandItemCell

- (void)setupSelf
{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupSelf];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setupSelf];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellWithBrand:(BIRBrandItem*)brand
{
    _nameLabel.text = brand.locationName;
}

@end
