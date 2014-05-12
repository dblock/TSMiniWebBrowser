//
//  TSMiniWebBrowserTests.m
//  TSMiniWebBrowser
//
//  Created by Daniel Doubrovkine on 5/12/14.
//  Copyright 2012 Toni Sala. All rights reserved.
//

#import "ViewController.h"

SpecBegin(TSMiniWebBrowser)

__block UIWindow *window;

beforeEach(^{
    window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
});

it(@"browser modal style", ^{
    NSURL *url = [NSURL URLWithString:@"http://www.example.org/"];
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:url];
    webBrowser.mode = TSMiniWebBrowserModeModal;
    webBrowser.barStyle = UIBarStyleBlack;
    window.rootViewController = webBrowser;
    [window makeKeyAndVisible];
    expect(window).will.haveValidSnapshotNamed(@"modal");
});

SpecEnd
