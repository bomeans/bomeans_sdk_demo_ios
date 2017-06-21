/*
 ============================================================================
 Name        : UIUtil.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : UI util functions
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "UIUtil.h"
#import "LocalizedStringTool.h"
#import "MBProgressHUD.h"


@implementation UIUtil

static MBProgressHUD* _hud = nil;

+ (UIAlertView*)showWarning:(NSString*)message title:(NSString*)title delegate:(id)delegate
{
	UIAlertView* alertSheet = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:L(@"OK") otherButtonTitles:nil];
	[alertSheet show];
    
    return alertSheet;
}

+ (UIAlertView*)showQuestion:(NSString*)message title:(NSString*)title delegate:(id)delegate
{
	UIAlertView* alertSheet = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:L(@"Cancel") otherButtonTitles:L(@"OK"), nil];
	[alertSheet show];
    
    return alertSheet;
}

+ (BOOL)isValidEmail:(NSString*)email
{
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}


+ (BOOL)isValidMobile:(NSString*)mobile
{
    NSString* phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)isValidPhone:(NSString*)phone
{
    NSString* phoneRegex = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:phone];
}

+ (BOOL)isValidCarNumber:(NSString*)carNumber
{
    NSString* carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate* carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];

    return [carTest evaluateWithObject:carNumber];
}

+ (BOOL)isValidPassword:(NSString*)password
{
    return password.length >= 6;
}

+ (NSString*)convertToStringTime:(int)time
{
    int intervalTime = [[NSDate date] timeIntervalSince1970] - time;
    if (intervalTime <= 0)
    {
        return [NSString stringWithFormat:L(@"MinuteAgo"), 0];
    }
    
	int inputSeconds = (int)intervalTime;
    int days = inputSeconds / (3600*24);
	int hours = (inputSeconds - days*3600*24) / 3600;
	int minutes = (inputSeconds - days*3600*24 - hours*3600) / 60;
    
	NSString* strTime = nil;
    if (days > 0)
    {
        if (1 == days)
        {
            strTime = L(@"Yesterday");
        }
        else
        {
           strTime = [NSString stringWithFormat:L(@"DayAgo"), days];
        }
    }
	else if (hours > 0)
    {
        strTime = [NSString stringWithFormat:L(@"HourAgo"), hours];
    }
    else
    {
        strTime = [NSString stringWithFormat:L(@"MinuteAgo"), minutes];
    }
    
	return strTime;
}

+ (void)showProgressHUD:(NSString*)text inView:(UIView*)view
{
    if (nil != _hud)
    {
        [_hud hide:YES];
        
        _hud = nil;
    }
    
    _hud = [[MBProgressHUD alloc] initWithView:view];
    _hud.labelText = text;
    [view addSubview:_hud];
    [_hud show:YES];
}

+ (void)hideProgressHUD
{
    if (nil != _hud)
    {
        [_hud hide:YES];
        
        _hud = nil;
    }
}

+ (void)startHealthPlan
{
    [self innerHealthPlan:@"06:30" text:L(@"Plan01")];
    [self innerHealthPlan:@"09:00" text:L(@"Plan02")];
    [self innerHealthPlan:@"11:00" text:L(@"Plan03")];
    [self innerHealthPlan:@"12:50" text:L(@"Plan04")];
    [self innerHealthPlan:@"15:00" text:L(@"Plan05")];
    [self innerHealthPlan:@"18:00" text:L(@"Plan06")];
    [self innerHealthPlan:@"19:00" text:L(@"Plan07")];
    [self innerHealthPlan:@"21:30" text:L(@"Plan08")];
}

+ (void)innerHealthPlan:(NSString*)strDate text:(NSString*)text
{
    UILocalNotification* notification = [[UILocalNotification alloc] init];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSDate* date = [formatter dateFromString:strDate];
    
    notification.fireDate = date;
    notification.repeatInterval = NSCalendarUnitDay;
    notification.alertBody = text;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

+ (void)stopHealthPlan
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
