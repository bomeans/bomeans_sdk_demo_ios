/*
 ============================================================================
 Name        : DeviceTypeItemCell.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device type item cell
 ============================================================================
 */

#import "DeviceTypeItemCell.h"
#import "LocalizedStringTool.h"


@interface DeviceTypeItemCell ()
{
    IBOutlet UIImageView* _iconImageView;
    IBOutlet UILabel* _nameLabel;
}

@end

@implementation DeviceTypeItemCell

- (void)setupSelf
{
    self.expandable = YES;
    self.expanded = NO;
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

- (void)setupCellWithType:(BIRTypeItem*)type
{
    _nameLabel.text = type.locationName;
    
    if (NSOrderedSame == [type.typeId compare:@"1"])
    {
        _iconImageView.image = [UIImage imageNamed:@"ico-摇控器类型-电视机.png"];
    }
    else if (NSOrderedSame == [type.typeId compare:@"2"])
    {
        _iconImageView.image = [UIImage imageNamed:@"ico-摇控器类型-空调.png"];
    }
    else if (NSOrderedSame == [type.typeId compare:@"3"])
    {
        _iconImageView.image = [UIImage imageNamed:@"ico-摇控器类型-机顶盒.png"];
    }
    else if (NSOrderedSame == [type.typeId compare:@"5"])
    {
        _iconImageView.image = [UIImage imageNamed:@"ico-摇控器类型-DVD.png"];
    }
    else if (NSOrderedSame == [type.typeId compare:@"6"])
    {
        _iconImageView.image = [UIImage imageNamed:@"ico-摇控器类型-MP3.png"];
    }
    else if (NSOrderedSame == [type.typeId compare:@"4"])
    {
        _iconImageView.image = [UIImage imageNamed:@"ico-摇控器类型-扩大机.png"];
    }
    else if (NSOrderedSame == [type.typeId compare:@"8"])
    {
        _iconImageView.image = [UIImage imageNamed:@"ico-摇控器类型-风扇.png"];
    }
    else
    {
        _iconImageView.image = [UIImage imageNamed:@"5.1.1_节目介绍-收藏.png"];
    }
}

@end
