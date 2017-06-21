/*
 ============================================================================
 Name        : AppData.m
 Version     : 1.0.0
 Copyright   : aduo@live.com
 Description : The global application data class
 ============================================================================
 */

#import "AppData.h"
#import "NSConfig.h"
#import "LocalizedStringTool.h"

#define SERVER_KEY      @"server"
#define USERNAME_KEY    @"username"
#define PASSWORD_KEY    @"password"


@implementation AppData

static NSString* _deviceToken = nil;

/**
 * The runtime sends initialize to each class in a program exactly one time just before the class,
 * or any class that inherits from it, is sent its first message from within the program. (Thus the
 * method may never be invoked if the class is not used.) The runtime sends the initialize message to
 * classes in a thread-safe manner. Superclasses receive this message before their subclasses.
 *
 * This method may also be called directly (assumably by accident), hence the safety mechanism.
 */
+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
	}
}

+ (NSString*)server
{
    NSString* string = [NSConfig readStringValueWithKey:SERVER_KEY];
    if (nil == string)
    {
        string = [NSConfig readMainStringValueWithKey:@"Server"];
    }
    
    return string;
}

+ (void)setServer:(NSString*)server
{
    [NSConfig setStringValue:server withKey:SERVER_KEY];
}

+ (NSString*)username
{
    NSString* string = [NSConfig readStringValueWithKey:USERNAME_KEY];
    if (nil == string)
    {
        string = @"";
    }
    
	return string;
}

+ (void)setUsername:(NSString*)username
{
	[NSConfig setStringValue:username withKey:USERNAME_KEY];
}

+ (NSString*)password
{
    NSString* string = [NSConfig readStringValueWithKey:PASSWORD_KEY];
    if (nil == string)
    {
        string = @"";
    }
    
	return string;
}

+ (void)setPassword:(NSString*)password
{
	[NSConfig setStringValue:password withKey:PASSWORD_KEY];
}

+ (NSDictionary*)wifiList
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSData* data = [userDefaults objectForKey:@"WifiList"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (void)setWifiList:(NSDictionary*)wifiList
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:wifiList];
    [userDefaults setObject:data forKey:@"WifiList"];
    [userDefaults synchronize];
}

@end
