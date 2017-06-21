/*
 ============================================================================
 Name        : NSConfig.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The config file
 ============================================================================
 */

#import "NSConfig.h"
#import "FileTool.h"

#define CONFIG_FILE_NAME @"Config"


@implementation NSConfig

+ (NSString*)readMainStringValueWithKey:(NSString*)key
{
	NSString* path = [[NSBundle mainBundle] pathForResource:CONFIG_FILE_NAME ofType:@"plist"];
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	NSString* object = [dict objectForKey:key];
    
	return object;
}

+ (NSInteger)readMainIntValueWithKey:(NSString*)key
{
    NSString* path = [[NSBundle mainBundle] pathForResource:CONFIG_FILE_NAME ofType:@"plist"];
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	NSNumber* object = [dict objectForKey:key];
    
	return object.integerValue;
}

+ (NSString*)readStringValueWithKey:(NSString*)key
{
	NSString* path = [NSString stringWithFormat:@"%@/%@%@", [FileTool getDocumentPath], CONFIG_FILE_NAME, @".plist"];
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	NSString* object = [dict objectForKey:key];
    
	return object;
}

+ (BOOL)setStringValue:(NSString*)value withKey:(NSString*)key
{
	NSString* path = [NSString stringWithFormat:@"%@/%@%@", [FileTool getDocumentPath], CONFIG_FILE_NAME, @".plist"];
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (nil == dict)
    {
        dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
	[dict setObject:value forKey:key];
    
	return [dict writeToFile:path atomically:YES];
}

@end
