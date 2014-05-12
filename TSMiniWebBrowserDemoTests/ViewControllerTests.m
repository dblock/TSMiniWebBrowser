//
//  ARMasterViewControllerTests.m
//  ARTiledImageView
//
//  Created by Daniel Doubrovkine on 3/15/14.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import "ViewController.h"

SpecBegin(ViewController)

it(@"displays a browser", ^{
    ViewController *vc = [[ViewController alloc] init];
    expect(vc.view).willNot.beNil();
    expect(vc.view).to.haveValidSnapshotNamed(@"default");
});

SpecEnd
