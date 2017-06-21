/*
 ============================================================================
 Name        : DVDChannelNumberView.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The dvd channel number view
 ============================================================================
 */

#import <QuartzCore/QuartzCore.h>

#import "DVDChannelNumberView.h"


@interface DVDChannelNumberView ()
{
    IBOutlet UIButton* __weak _dig00Button;
    IBOutlet UIButton* __weak _dig01Button;
    IBOutlet UIButton* __weak _dig02Button;
    IBOutlet UIButton* __weak _dig03Button;
    IBOutlet UIButton* __weak _dig04Button;
    IBOutlet UIButton* __weak _dig05Button;
    IBOutlet UIButton* __weak _dig06Button;
    IBOutlet UIButton* __weak _dig07Button;
    IBOutlet UIButton* __weak _dig08Button;
    IBOutlet UIButton* __weak _dig09Button;
    IBOutlet UIButton* __weak _dig100Button;
    IBOutlet UIButton* __weak _lookBackButton;
    
    NSMutableArray* _keyArray;
}

@end

@implementation DVDChannelNumberView

@synthesize device;
@synthesize keyArray = _keyArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _keyArray = [[NSMutableArray alloc] initWithCapacity:1];
}

- (void)reloadData
{
    [_keyArray removeAllObjects];
    
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_DIG_0", @"key", _dig00Button, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_DIG_1", @"key", _dig01Button, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_DIG_2", @"key", _dig02Button, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_DIG_3", @"key", _dig03Button, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_DIG_4", @"key", _dig04Button, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_DIG_5", @"key", _dig05Button, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_DIG_6", @"key", _dig06Button, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_DIG_7", @"key", _dig07Button, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_DIG_8", @"key", _dig08Button, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_DIG_9", @"key", _dig09Button, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_DIG_100", @"key", _dig100Button, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_LOOK_BACK", @"key", _lookBackButton, @"value", nil]];
    
    for (NSDictionary* dict in _keyArray)
    {
        BOOL isFound = NO;
        
        NSString* strKey = [dict objectForKey:@"key"];
        for (NSString* strKey2 in self.device.keys)
        {
            if (NSOrderedSame == [strKey caseInsensitiveCompare:strKey2])
            {
                isFound = YES;
                break;
            }
        }
        
        if (isFound)
        {
            [[dict objectForKey:@"value"] setHidden:NO];
            [[dict objectForKey:@"value"] setEnabled:YES];
            [[dict objectForKey:@"value"] setAlpha:1.0f];
        }
        else
        {
            //[[dict objectForKey:@"value"] setHidden:YES];
            [[dict objectForKey:@"value"] setEnabled:NO];
            [[dict objectForKey:@"value"] setAlpha:0.6f];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (IBAction)backgroundButtonClicked:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)keyButtonClicked:(id)sender
{
    for (NSDictionary* dict in _keyArray)
    {
        if (sender == [dict objectForKey:@"value"])
        {
            [self.device.remoter transmitIR:[dict objectForKey:@"key"] withOption:nil];
            break;
        }
    }
}

@end
