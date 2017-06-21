/*
 ============================================================================
 Name        : DeviceSubBrandCell.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device sub brand cell
 ============================================================================
 */

#import "DeviceSubBrandCell.h"
#import "BIRBrandItem.h"
#import "FlatUIKit.h"

#define COLUMN    4


@interface DeviceSubBrandCell ()
{
    IBOutlet UIView* _contentView;
}

@end

@implementation DeviceSubBrandCell

@synthesize subCates = _subCates;
@synthesize cateVC = _cateVC;

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

- (void)setupCell
{
    for (UIView* view in _contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger total = self.subCates.count + 1;
    
#define ROWHEIHT 38
    int rows = (total / COLUMN) + ((total % COLUMN) > 0 ? 1 : 0);
    
    for (int i = 0; i < total; i++)
    {
        int row = i / COLUMN;
        int column = i % COLUMN;
        
        FUIButton* btn = [[FUIButton alloc] initWithFrame:CGRectZero];
        btn.frame = CGRectMake(0, 0, 78, ROWHEIHT);
        btn.tag = i;
        [btn addTarget:self.cateVC action:@selector(subCateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [btn setButtonColor:[UIColor colorFromHexCode:@"ecedee"]];
        btn.titleLabel.numberOfLines = 1;
        btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        if (i == total - 1)
        {
            [btn setTitle:@"..." forState:UIControlStateNormal];
        }
        else
        {
            BIRBrandItem* data = [self.subCates objectAtIndex:i];
            [btn setTitle:data.locationName forState:UIControlStateNormal];
        }
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(78*column, ROWHEIHT*row, 78, ROWHEIHT)];
        view.backgroundColor = [UIColor clearColor];
        
        [view addSubview:btn];
        
        [_contentView addSubview:view];
    }
    
    CGRect viewFrame = self.frame;
    viewFrame.size.height = ROWHEIHT*rows;
    self.frame = viewFrame;
}

@end
