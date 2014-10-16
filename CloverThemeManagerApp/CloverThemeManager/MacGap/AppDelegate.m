//
//  AppDelegate.m
//  MacGap
//
//  Created by Alex MacCaw on 08/01/2012.
//  Copyright (c) 2012 Twitter. All rights reserved.
//
//  Edited by Blackosx - October 2014
//
#import "AppDelegate.h"

@implementation AppDelegate

@synthesize windowController;

- (void) applicationWillFinishLaunching:(NSNotification *)aNotification
{

    
}

-(BOOL)applicationShouldHandleReopen:(NSApplication*)application
                   hasVisibleWindows:(BOOL)visibleWindows{
    if(!visibleWindows){
        [self.windowController.window makeKeyAndOrderFront: nil];
    }
    return YES;
}

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification { 
    self.windowController = [[WindowController alloc] initWithURL: kStartPage];
    [self.windowController showWindow: [NSApplication sharedApplication].delegate];
    self.windowController.contentView.webView.alphaValue = 1.0;
    self.windowController.contentView.alphaValue = 1.0;
    [self.windowController showWindow:self];
    
    // blackosx added to run bash script on launch
    NSTask *task = [[NSTask alloc] init];
    NSString *taskPath =
    [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"public/bash/script.sh"];
    [task setLaunchPath: taskPath];
    [task launch];
    //[task waitUntilExit];
    
    // blackosx add redirect the nslog output to file instead of console
    // Create a directory in tmp
    // http://www.techotopia.com/index.php/Working_with_Directories_in_Objective-C
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    NSURL *newDir = [NSURL fileURLWithPath:@"/tmp/CloverThemeManager"];
    [filemgr createDirectoryAtURL: newDir withIntermediateDirectories:YES attributes: nil error:nil];
    
    // Changing to a Different Directory
    NSString *currentpath;
    filemgr = [NSFileManager defaultManager];
    currentpath = [filemgr currentDirectoryPath];
    NSLog (@"Current directory is %@", currentpath);
    if ([filemgr changeCurrentDirectoryPath: @"/tmp/CloverThemeManager"] == NO)
        NSLog (@"Cannot change directory.");
    currentpath = [filemgr currentDirectoryPath];
    NSLog (@"Current directory is %@", currentpath);
    
    // Set log path
    // http://stackoverflow.com/questions/3184235/how-to-redirect-the-nslog-output-to-file-instead-of-console
    NSString *logPath = [currentpath stringByAppendingPathComponent:@"CloverThemeManager_JsToBash.log"];
    freopen([logPath fileSystemRepresentation],"a+",stderr);
}

// blackosx added to quit application on window close.
// http://stackoverflow.com/questions/14449986/quitting-an-app-using-the-red-x-button
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix
{
    NSString *  result;
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", prefix, uuidStr]];
    assert(result != nil);
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

@end
