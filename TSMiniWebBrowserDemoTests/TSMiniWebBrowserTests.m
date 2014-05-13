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
__block TSMiniWebBrowser *webBrowser;

beforeEach(^{
    window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    NSURL *url = [NSURL URLWithString:@"http://www.example.org/"];
    webBrowser = [[TSMiniWebBrowser alloc] initWithURL:url];
    window.rootViewController = webBrowser;
});

it(@"sets url", ^{
    expect(webBrowser.currentURL).to.equal([NSURL URLWithString:@"http://www.example.org/"]);
});

it(@"modal style", ^AsyncBlock {
    webBrowser.mode = TSMiniWebBrowserModeModal;
    webBrowser.barStyle = UIBarStyleBlack;
    [window makeKeyAndVisible];
    [Specta activelyWaitFor:3 completion:^{
        expect(window).will.haveValidSnapshotNamed(@"modeModal");
        done();
    }];
});

it(@"without a toolbar and a white background", ^AsyncBlock {
    webBrowser.showToolBar = NO;
    webBrowser.backgroundColor = [UIColor whiteColor];
    webBrowser.opaque = NO;
    [window makeKeyAndVisible];
    [Specta activelyWaitFor:3 completion:^{
        expect(window).will.haveValidSnapshotNamed(@"showToolBarNO");
        done();
    }];
});

SpecEnd
