//
//  ViewController.m
//  TSMiniWebBrowserDemo
//
//  Created by Toni Sala Echaurren on 17/01/12.
//  Copyright 2012 Toni Sala. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "ViewController.h"

@implementation ViewController

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)openBrowserNavigationMode:(id)sender
{
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithURL:[NSURL URLWithString:DEMO_URL]];
    webBrowser.delegate = self;

    //    webBrowser.showURLStringOnActionSheetTitle = YES;
    //    webBrowser.showPageTitleOnTitleBar = YES;
    //    webBrowser.showActionButton = YES;
    //    webBrowser.showReloadButton = YES;
    //    [webBrowser setFixedTitleBarText:@"Test Title Text"]; // This has priority over "showPageTitleOnTitleBar".
    
    webBrowser.mode = TSMiniWebBrowserModeNavigation;
    
    webBrowser.barStyle = UIBarStyleBlack;
    
    [self.navigationController pushViewController:webBrowser animated:YES];
}

- (IBAction)openBrowserModalMode:(id)sender
{
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithURL:[NSURL URLWithString:DEMO_URL]];
    webBrowser.delegate = self;
    webBrowser.mode = TSMiniWebBrowserModeModal;
    
    webBrowser.barStyle = UIBarStyleBlack;
    
    webBrowser.modalDismissButtonTitle = @"Home";
   
    webBrowser.showToolBar = NO;
    
    [self presentViewController:webBrowser animated:YES completion:nil];
}

- (IBAction)openBrowserTabbarModeOne:(id)sender
{
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithURL:[NSURL URLWithString:DEMO_URL]];
    webBrowser.delegate = self;
    webBrowser.mode = TSMiniWebBrowserModeTabBar;
    webBrowser.barStyle = UIBarStyleBlack;
    
    UIViewController *fooController = [[UIViewController alloc] init];
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    [tabBarController addChildViewController:webBrowser];
    [tabBarController addChildViewController:fooController];
    
    [[UIApplication sharedApplication] keyWindow].rootViewController = tabBarController;
    
}

- (IBAction)openBrowserTabbarModeTwo:(id)sender
{
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithURL:[NSURL URLWithString:DEMO_URL]];
    webBrowser.delegate = self;
    webBrowser.mode = TSMiniWebBrowserModeTabBar;
    webBrowser.barStyle = UIBarStyleBlack;
    
    UIViewController *fooController = [[UIViewController alloc] init];
    UITabBarController *tabBarController = [[UITabBarController alloc] init];

    [tabBarController addChildViewController:webBrowser];
    [tabBarController addChildViewController:fooController];
    
    [self.navigationController pushViewController:tabBarController animated:YES];
}

#pragma mark - TSMiniWebBrowserDelegate

- (void)tsMiniWebBrowserDidDismiss
{
    NSLog(@"TSMiniWebBrowser was dismissed");
}

@end
