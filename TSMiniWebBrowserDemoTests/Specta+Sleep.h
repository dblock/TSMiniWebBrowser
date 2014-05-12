//
//  Specta+Sleep.h
//  TSMiniWebBrowserDemo
//
//  Created by Daniel Doubrovkine on 5/12/14.
//  Copyright 2012 Toni Sala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Specta (Sleep)
+ (void)activelyWaitFor:(NSInteger)seconds completion:(void (^)(void))completion;
@end


