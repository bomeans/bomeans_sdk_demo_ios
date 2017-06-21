/*
 ============================================================================
 Name        : NSConfig.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The config file
 ============================================================================
 */

#import <Foundation/Foundation.h>


@interface NSConfig : NSObject
{
}

+ (NSString*)readMainStringValueWithKey:(NSString*)key;
+ (NSInteger)readMainIntValueWithKey:(NSString*)key;

+ (NSString*)readStringValueWithKey:(NSString*)key;
+ (BOOL)setStringValue:(NSString*)value withKey:(NSString*)key;

@end
