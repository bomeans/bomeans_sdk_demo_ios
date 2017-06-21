/*
 ============================================================================
 Name        : SplashViewController.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The splash view controller
 ============================================================================
 */

#import "SplashViewController.h"


@interface SplashViewController ()
{
    IBOutlet UIImageView* _backgroundImageView;
}

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IS_IPHONE5)
    {
        _backgroundImageView.image = [UIImage imageNamed:@"Default-568h.png"];
    }
    else
    {
        _backgroundImageView.image = [UIImage imageNamed:@"Default.png"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
