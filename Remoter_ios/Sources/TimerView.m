/*
 ============================================================================
 Name        : TimerView.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : 定时
 ============================================================================
 */

#import <QuartzCore/QuartzCore.h>

#import "TimerView.h"
#import "FlatDatePicker.h"


@interface TimerView ()
{
    IBOutlet UIView* __weak _beginTimeView;
    IBOutlet UIView* __weak _endTimeView;
    
    FlatDatePicker* _beginTimePicker;
    FlatDatePicker* _endTimePicker;
}

@end

@implementation TimerView

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
    _beginTimePicker = [[FlatDatePicker alloc] initWithParentView:_beginTimeView];
    _beginTimePicker.datePickerMode = FlatDatePickerModeTime;
    [_beginTimePicker show];
    
    _endTimePicker = [[FlatDatePicker alloc] initWithParentView:_endTimeView];
    _endTimePicker.datePickerMode = FlatDatePickerModeTime;
    [_endTimePicker show];
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

- (IBAction)cancelButtonClicked:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)doneButtonClicked:(id)sender
{
    if (nil != _delegate && [self.delegate respondsToSelector:@selector(TimerViewSelected: endDate:)])
    {
        [self.delegate TimerViewSelected:[_beginTimePicker getDate] endDate:[_endTimePicker getDate]];
    }
    
    [self removeFromSuperview];
}

@end
