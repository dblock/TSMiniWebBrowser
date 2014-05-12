//
//  Specta+Sleep.m
//  TSMiniWebBrowserDemo
//
//  Created by Daniel Doubrovkine on 5/12/14.
//  Copyright 2012 Toni Sala. All rights reserved.
//

#import "Specta+Sleep.h"

@implementation Specta (Sleep)

+ (void) activelyWaitFor:(NSInteger)seconds completion:(void (^)(void))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [NSThread sleepForTimeInterval:seconds];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    });
}

@end