//
//  ViewControllerTests.m
//  TSMiniWebBrowser
//
//  Created by Daniel Doubrovkine on 5/12/14.
//  Copyright 2012 Toni Sala. All rights reserved.
//

#import "ViewController.h"

SpecBegin(ViewController)

__block UIWindow *window;

beforeEach(^{
    window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
});

it(@"displays a list of options", ^{
    ViewController *vc = [[ViewController alloc] init];
    window.rootViewController = vc;
    [window makeKeyAndVisible];
    expect(vc.view).willNot.beNil();
    expect(window).to.haveValidSnapshotNamed(@"default");
});

SpecEnd
