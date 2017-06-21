/*
 ============================================================================
 Name        : AppData.h
 Version     : 1.0.0
 Copyright   : aduo@live.com
 Description : The global application data class
 ============================================================================
 */

#import <Foundation/Foundation.h>


@interface AppData : NSObject
{
    
}

+ (NSString*)server;
+ (void)setServer:(NSString*)server;

+ (NSString*)username;
+ (void)setUsername:(NSString*)username;

+ (NSString*)password;
+ (void)setPassword:(NSString*)password;

+ (NSDictionary*)wifiList;
+ (void)setWifiList:(NSDictionary*)wifiList;

@end
