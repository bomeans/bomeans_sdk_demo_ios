/*
 ============================================================================
 Name        : FileTool.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The file tool file
 ============================================================================
 */

#import "FileTool.h"


@implementation FileTool

+ (BOOL)initDirectoryForFile:(NSString*)filename
{
	return [self createDirectory:[filename stringByDeletingLastPathComponent]];
}

+ (BOOL)createDirectory:(NSString*)dir
{
    NSFileManager* fm = [NSFileManager defaultManager];
	dir = [dir stringByExpandingTildeInPath];
    if ([fm fileExistsAtPath:dir])
    {
		return YES;
    }
    else
    {
        return [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
	}
    
	return NO;
}

+ (BOOL)createFile:(NSString*)path withData:(NSData*)data
{
	return [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
}

+ (BOOL)isFileExist:(NSString*)filepath
{
	return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

+ (BOOL)deleteFile:(NSString*)path
{
	if ([self isFileExist:path])
    {
		return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
	else
    {
		return YES;
    }
}

+ (NSString*)getDocumentPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* directoryPath = [paths objectAtIndex:0];
    
    return directoryPath;
}

+ (NSString*)getSubDocumentPath:(NSString*)dir
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* directoryPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:dir];
    
    return directoryPath;
}

+ (NSString*)generateGuid
{
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef cfStr = CFUUIDCreateString(NULL, uuid);
	
	NSString* ret = [NSString stringWithString:CFBridgingRelease(cfStr)];
	
	CFRelease(uuid);
	
	return ret;
}

@end
