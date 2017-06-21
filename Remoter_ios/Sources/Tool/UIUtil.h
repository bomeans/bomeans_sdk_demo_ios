/*
 ============================================================================
 Name        : UIUtil.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : UI util functions
 ============================================================================
 */

#import <UIKit/UIKit.h>


@interface UIUtil : NSObject
{
}

// alert
+ (UIAlertView*)showWarning:(NSString*)message title:(NSString*)title delegate:(id)delegate;
+ (UIAlertView*)showQuestion:(NSString*)message title:(NSString*)title delegate:(id)delegate;

+ (BOOL)isValidEmail:(NSString*)email;
+ (BOOL)isValidMobile:(NSString*)mobile;
+ (BOOL)isValidPhone:(NSString*)phone;
+ (BOOL)isValidCarNumber:(NSString*)carNumber;
+ (BOOL)isValidPassword:(NSString*)password;

+ (NSString*)convertToStringTime:(int)time;

+ (void)showProgressHUD:(NSString*)text inView:(UIView*)view;
+ (void)hideProgressHUD;

+ (void)startHealthPlan;
+ (void)stopHealthPlan;

+ (void)showShareDialogWithString:(NSString*)content;

+ (void)showShareDialogWithImage:(UIImage*)image;

+ (void)checkTestEnd:(NSString*)url;

@end
