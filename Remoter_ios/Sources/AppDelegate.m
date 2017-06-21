/*
 ============================================================================
 Name        : AppDelegate.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The app delegate class
 ============================================================================
 */

#import <TestinAgent/TestinAgent.h>

#import "AppDelegate.h"
#import "MainViewController.h"
#import "AppData.h"
#import "LocalizedStringTool.h"
#import "SplashViewController.h"
#import "UIUtil.h"
#import "NSConfig.h"
#import "Reachability.h"
#import "DeviceManager.h"
#import "TVRemoterViewController.h"


@interface AppDelegate () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>
{
    UIWindow* _window;
    UINavigationController* _navController;
}

@property (nonatomic, strong) NSString* updateURL;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;

@synthesize updateURL;

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    //[NSThread sleepForTimeInterval:1.5f];
    
#if !TARGET_IPHONE_SIMULATOR
    [TestinAgent init:@"e4188166d1ea229a25fb49bd1b4ae409"];
#endif
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MainViewController* viewController = [[MainViewController alloc] init];
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [navigationController setNavigationBarHidden:YES];
    self.navController = navigationController;
    self.navController.delegate = self;
    
    if ([self.navController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        //self.navController.interactivePopGestureRecognizer.delegate = self;
    }
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication*)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification object:nil];
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    _navController.navigationBarHidden = YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
    if ([self.navController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        if (gestureRecognizer == self.navController.interactivePopGestureRecognizer)
        {
            return [self.navController.viewControllers count] > 1;
        }
    }
    
    return YES;
}

@end
