//
//  ARMasterViewControllerTests.m
//  ARTiledImageView
//
//  Created by Daniel Doubrovkine on 3/15/14.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import "ViewController.h"

SpecBegin(ViewController)

__block ViewController *vc;
__block UIWindow *window;

beforeEach(^{
    window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    vc = [[ViewController alloc] init];
    window.rootViewController = vc;
    [window makeKeyAndVisible];
    expect(vc.view).willNot.beNil();
});

it(@"displays a list of options", ^{
    expect(window).to.haveValidSnapshotNamed(@"default");
});

it(@"openBrowserModalMode", ^{
    [vc openBrowserModalMode:nil];
    expect(window).will.haveValidSnapshotNamed(@"openBrowserModalMode");
});

SpecEnd
