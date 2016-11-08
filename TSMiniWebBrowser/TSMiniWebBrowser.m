//
//  TSMiniWebBrowser.m
//  TSMiniWebBrowserDemo
//
//  Created by Toni Sala Echaurren on 18/01/12.
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

#import "TSMiniWebBrowser.h"
#import "DZScrollingInspector.h"

@interface TSMiniWebBrowser ()
// Toolbar items
@property(nonatomic, readonly, strong) UIBarButtonItem *buttonGoBack;
@property(nonatomic, readonly, strong) UIBarButtonItem *buttonGoForward;
@property(nonatomic, readonly, strong) UIActivityIndicatorView *activityIndicator;
// Layout
@property(nonatomic, readonly, strong) UIWebView *webView;
@property(nonatomic, readonly, strong) UIToolbar *toolBar;
// Only used in modal mode
@property(nonatomic, readonly, strong) UINavigationBar *navigationBar;
// Customization
@property(nonatomic, readonly, strong) NSString *forcedTitleBarText;
// State control
@property(nonatomic, readonly, assign) UIBarStyle originalBarStyle;
@property(nonatomic, readonly, assign) UIStatusBarStyle originalStatusBarStyle;
@end

@implementation TSMiniWebBrowser

#define kToolBarHeight 44
#define kNavBarHeight 44
#define kTabBarHeight 49

enum actionSheetButtonIndex {
	kSafariButtonIndex,
	kChromeButtonIndex,
};

#pragma mark - Private Methods

- (void)setTitleBarText:(NSString*)pageTitle
{
    if (self.mode == TSMiniWebBrowserModeModal) {
        self.navigationBar.topItem.title = pageTitle;
    } else if (self.mode == TSMiniWebBrowserModeNavigation && pageTitle) {
        [[self navigationItem] setTitle:pageTitle];
    }
}

- (void)setHideTopBarAndBottomBarOnScrolling:(BOOL)hideTopBarAndBottomBarOnScrolling
{
    _hideTopBarAndBottomBarOnScrolling = hideTopBarAndBottomBarOnScrolling;
    if (hideTopBarAndBottomBarOnScrolling) {
        [_scrollingInspectorForTopBar suspend];
        [_scrollingInspectorForBottomBar suspend];
    }
    else {
        [_scrollingInspectorForTopBar resume];
        [_scrollingInspectorForBottomBar resume];
    }
}

- (void)toggleBackForwardButtons
{
    self.buttonGoBack.enabled = self.webView.canGoBack;
    self.buttonGoForward.enabled = self.webView.canGoForward;
}

- (void)showActivityIndicators
{
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)hideActivityIndicators
{
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)dismissController
{
    if (self.webView.loading ) {
        [self.webView stopLoading];
    }

	[self dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(tsMiniWebBrowserDidDismiss)]) {
        [self.delegate tsMiniWebBrowserDidDismiss];
    }
}

- (void)updateScrollingInspectorsLimits
{
    UIView *topBar = [self topBarForCurrentMode];
    UIView *bottomBar = [self bottomBarForCurrentMode];
     [self.scrollingInspectorForTopBar setLimits:[DZScrollingInspector DZScrollingInspectorTwoOrientationsLimitsMake:topBar.frame.origin.y
         portraitMax:topBar.frame.origin.y-topBar.frame.size.height
         landscapeMin:topBar.frame.origin.y
         landscapeMax:topBar.frame.origin.y-topBar.frame.size.height]];
    [self.scrollingInspectorForBottomBar setLimits:[DZScrollingInspector DZScrollingInspectorTwoOrientationsLimitsMake:bottomBar.frame.origin.y
         portraitMax:bottomBar.frame.origin.y+bottomBar.frame.size.height
         landscapeMin:bottomBar.frame.origin.y
         landscapeMax:bottomBar.frame.origin.y+bottomBar.frame.size.height]];
}

- (UIView*)topBarForCurrentMode
{
    UIView *topBar = nil;
    switch (self.mode) {
        case TSMiniWebBrowserModeNavigation:
            topBar = self.navigationController.navigationBar;
            break;
        case TSMiniWebBrowserModeModal:
            topBar = self.navigationBar;
            break;
        case TSMiniWebBrowserModeTabBar:
            topBar = self.toolBar;
            break;
        default:
            break;
    }
    return topBar;
}

- (UIView*)bottomBarForCurrentMode
{
    UIView *bottomBar = nil;
    switch (self.mode) {
        case TSMiniWebBrowserModeNavigation:
            bottomBar = self.toolBar;
            break;
        case TSMiniWebBrowserModeModal:
            bottomBar = self.toolBar;
            break;
        case TSMiniWebBrowserModeTabBar:
            break;
        default:
            break;
    }
    return bottomBar;
}

// Remove the webview delegate, because if you use this in a navigation controller, TSMiniWebBrowser can get deallocated while
// the page is still loading and the web view will call its delegate and the same can occur where the DZScrollingInspectors
// are still observing the scroll view while it's already being deallocated.
- (void)dealloc
{
    self.scrollingInspectorForTopBar = nil;
    self.scrollingInspectorForBottomBar = nil;
    [self.webView setDelegate:nil];
}

#pragma mark - Init

// This method is only used in modal mode
- (void)initNavigationBar
{
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithTitle:self.modalDismissButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(dismissController)];
    UINavigationItem *titleBar = [[UINavigationItem alloc] initWithTitle:@""];
    titleBar.leftBarButtonItem = buttonDone;
    
    CGFloat width = self.view.frame.size.width;
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, kNavBarHeight)];
    //self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.navigationBar.barStyle = self.barStyle;
    [self.navigationBar pushNavigationItem:titleBar animated:NO];
    
    [self.view addSubview:self.navigationBar];
}

- (void)initToolBar
{
    if (self.mode == TSMiniWebBrowserModeNavigation) {
        self.navigationController.navigationBar.barStyle = self.barStyle;
    }
    
    CGSize viewSize = self.view.frame.size;
    if (self.mode == TSMiniWebBrowserModeTabBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -1, viewSize.width, kToolBarHeight)];
    } else {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, viewSize.height - kToolBarHeight, viewSize.width, kToolBarHeight)];
    }
    
    self.toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.toolBar.barStyle = self.barStyle;
    [self.view addSubview:_toolBar];
    
    NSBundle *webBrowserBundle = [NSBundle bundleForClass:[TSMiniWebBrowser class]];
    
    _buttonGoBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon.png" inBundle:webBrowserBundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTouchUp:)];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 30;
    
    _buttonGoForward = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward_icon.png" inBundle:webBrowserBundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(forwardButtonTouchUp:)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *buttonReload = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload_icon.png" inBundle:webBrowserBundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(reloadButtonTouchUp:)];
    
    UIBarButtonItem *fixedSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace2.width = 20;
    
    UIBarButtonItem *buttonAction = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(buttonActionTouchUp:)];
    
    // Activity indicator is a bit special
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicator.frame = CGRectMake(11, 7, 20, 20);
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 43, 33)];
    [containerView addSubview:_activityIndicator];
    UIBarButtonItem *buttonContainer = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    // Add butons to an array
    NSMutableArray *toolBarButtons = [[NSMutableArray alloc] init];
    [toolBarButtons addObject:self.buttonGoBack];
    [toolBarButtons addObject:fixedSpace];
    [toolBarButtons addObject:self.buttonGoForward];
    [toolBarButtons addObject:flexibleSpace];
    [toolBarButtons addObject:buttonContainer];
    if (self.showReloadButton) {
        [toolBarButtons addObject:buttonReload];
    }
    if (self.showActionButton) {
        [toolBarButtons addObject:fixedSpace2];
        [toolBarButtons addObject:buttonAction];
    }
    
    // Set buttons to tool bar
    [self.toolBar setItems:toolBarButtons animated:YES];
	
	// Tint toolBar
	[self.toolBar setTintColor:self.barTintColor];
}

- (UIEdgeInsets)webViewContentInset
{
    UIEdgeInsets webViewContentInset = UIEdgeInsetsMake(self.showNavigationBar ? kNavBarHeight : 0, 0, self.showToolBar ? kToolBarHeight : 0, 0);
    if(self.mode == TSMiniWebBrowserModeNavigation) {
        if (([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)) {
            // On iOS7 the webview can be seen through the navigationbar
        } else {
            // On iOS below 7 we should make webView be under the navigationbar
            CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
            webViewContentInset = UIEdgeInsetsMake(self.showNavigationBar ? navBarHeight : 0, 0, self.showToolBar ? kToolBarHeight : 0, 0);
        }
    }
    return webViewContentInset;
}

- (UIEdgeInsets)webViewScrollIndicatorsInsets
{
    return UIEdgeInsetsMake(self.showNavigationBar ? kNavBarHeight : 0, 0, 0, 0);
}

- (void)initWebView
{
    CGRect webViewFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    _webView = [[UIWebView alloc] initWithFrame:webViewFrame];
    [self.view addSubview:self.webView];

    self.webView.scrollView.contentInset = [self webViewContentInset];
    self.webView.scrollView.scrollIndicatorInsets = [self webViewScrollIndicatorsInsets];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    
    if (self.backgroundColor) {
        self.webView.backgroundColor = self.backgroundColor;
    }

    self.webView.opaque = self.opaque;
    
    // Load the URL in the webView
    NSURLRequest *request = [self requestWithURL:self.currentURL];
    [self.webView loadRequest:request];
}

#pragma mark -

- (id)initWithURL:(NSURL*)url
{
    self = [self init];
    if (!self) return nil;

    _currentURL = url;
    
    // Defaults
    _mode = TSMiniWebBrowserModeNavigation;
    _showURLStringOnActionSheetTitle = YES;
    _showPageTitleOnTitleBar = YES;
    _showReloadButton = YES;
    _showActionButton = YES;
    _showToolBar = YES;
    _showNavigationBar = YES;
    _modalDismissButtonTitle = NSLocalizedString(@"Done", nil);
    _barStyle = UIBarStyleDefault;
    _statusBarStyle = UIStatusBarStyleBlackOpaque;
    _opaque = YES;
    _hideTopBarAndBottomBarOnScrolling = YES;

    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Main view frame.
    if (self.mode == TSMiniWebBrowserModeTabBar) {
        CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height - kTabBarHeight;
        if (![UIApplication sharedApplication].statusBarHidden) {
            viewHeight -= [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        self.view.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    }
    
    // Store the current navigationBar bar style to be able to restore it later.
    if (self.mode == TSMiniWebBrowserModeNavigation) {
        _originalBarStyle = self.navigationController.navigationBar.barStyle;
    }
    
    _originalStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    
    // Init web view
    [self initWebView];
    
    // Init tool bar
    if (self.showToolBar) {
        [self initToolBar];
    }
    
    // Init title bar if presented modally
    if (self.mode == TSMiniWebBrowserModeModal && self.showNavigationBar) {
        [self initNavigationBar];
    }
    
    if (self.hideTopBarAndBottomBarOnScrolling) {
        [self performSelector:@selector(initScrollingInspectors) withObject:self afterDelay:0.1f];
    }
    
    // Status bar style
    [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle animated:YES];
    
    // UI state
    self.buttonGoBack.enabled = NO;
    self.buttonGoForward.enabled = NO;
    if (self.forcedTitleBarText) {
        [self setTitleBarText:self.forcedTitleBarText];
    }
}

- (void)initScrollingInspectors
{
    UIView *topBar = [self topBarForCurrentMode];
    UIView *bottomBar = [self bottomBarForCurrentMode];
    
    if (topBar) {
        _scrollingInspectorForTopBar = [[DZScrollingInspector alloc] initWithObservedScrollView:self.webView.scrollView
            andOffsetKeyPath:@"y"
            andInsetKeypath:@"top"
            andTargetObject:topBar
            andTargetFramePropertyKeyPath:@"origin.y"
            andLimits:[DZScrollingInspector DZScrollingInspectorTwoOrientationsLimitsMake:topBar.frame.origin.y
                portraitMax:topBar.frame.origin.y-topBar.frame.size.height
                landscapeMin:topBar.frame.origin.y
                landscapeMax:topBar.frame.origin.y-topBar.frame.size.height
            ]];
    }
    
    if (bottomBar) {
        _scrollingInspectorForBottomBar = [[DZScrollingInspector alloc] initWithObservedScrollView:self.webView.scrollView
            andOffsetKeyPath:@"y"
            andInsetKeypath:@"top"
            andTargetObject:bottomBar
            andTargetFramePropertyKeyPath:@"origin.y"
            andLimits:[DZScrollingInspector DZScrollingInspectorTwoOrientationsLimitsMake:bottomBar.frame.origin.y
                portraitMax:bottomBar.frame.origin.y+bottomBar.frame.size.height
                landscapeMin:bottomBar.frame.origin.y
                landscapeMax:bottomBar.frame.origin.y+bottomBar.frame.size.height
            ]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
	for (id subview in self.view.subviews) {
		if ([subview isKindOfClass: [UIWebView class]]) {
			UIWebView *sv = subview;
			[sv.scrollView setScrollsToTop:NO];
		}
	}
	
	[self.webView.scrollView setScrollsToTop:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Restore navigationBar bar style.
    if (self.mode == TSMiniWebBrowserModeNavigation) {
        self.navigationController.navigationBar.barStyle = self.originalBarStyle;
    }
    
    // Restore Status bar style
    [[UIApplication sharedApplication] setStatusBarStyle:self.originalStatusBarStyle animated:NO];
    
    // Stop loading
    [self.webView stopLoading];
}

#pragma mark - Support different interface orientations

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_scrollingInspectorForTopBar resetTargetToMinLimit];
    [_scrollingInspectorForBottomBar resetTargetToMinLimit];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateScrollingInspectorsLimits];
}

#pragma mark - Action Sheet

- (void)showActionSheet
{
    NSString *urlString = @"";
    if (self.showURLStringOnActionSheetTitle) {
        NSURL* url = [self.webView.request URL];
        urlString = [url absoluteString];
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.title = urlString;
    actionSheet.delegate = self;
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Open in Safari", nil)];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome://"]]) {
        // Chrome is installed, add the option to open in chrome.
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Open in Chrome", nil)];
    }
    
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    if (self.mode == TSMiniWebBrowserModeTabBar) {
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
    // else if (mode == TSMiniWebBrowserModeNavigation && [self.navigationController respondsToSelector:@selector(tabBarController)]) {
    else if (self.mode == TSMiniWebBrowserModeNavigation && self.navigationController.tabBarController) {
        [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    }
    else if (self.showActionButton && (self.mode == TSMiniWebBrowserModeModal)) {
        UIBarButtonItem* actionButton = [[self.toolBar items] lastObject];
        [actionSheet showFromBarButtonItem:actionButton animated:YES];
    }
    else {
        [actionSheet showInView:self.view];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [actionSheet cancelButtonIndex]) return;
    
    NSURL *url = [self.webView.request URL];
    if (url == nil || [url isEqual:[NSURL URLWithString:@""]]) {
        url = self.currentURL;
    }
    
    if (buttonIndex == kSafariButtonIndex) {
        [[UIApplication sharedApplication] openURL:url];
    } else if (buttonIndex == kChromeButtonIndex) {
        NSString *scheme = url.scheme;
        
        // Replace the URL Scheme with the Chrome equivalent.
        NSString *chromeScheme = nil;
        if ([scheme isEqualToString:@"http"]) {
            chromeScheme = @"googlechrome";
        } else if ([scheme isEqualToString:@"https"]) {
            chromeScheme = @"googlechromes";
        }
        
        // Proceed only if a valid Google Chrome URI Scheme is available.
        if (chromeScheme) {
            NSString *absoluteString = [url absoluteString];
            NSRange rangeForScheme = [absoluteString rangeOfString:@":"];
            NSString *urlNoScheme = [absoluteString substringFromIndex:rangeForScheme.location];
            NSString *chromeURLString = [chromeScheme stringByAppendingString:urlNoScheme];
            NSURL *chromeURL = [NSURL URLWithString:chromeURLString];
            
            // Open the URL with Chrome.
            [[UIApplication sharedApplication] openURL:chromeURL];
        }
    }
}

#pragma mark - Actions

- (void)backButtonTouchUp:(id)sender
{
    [self.webView goBack];
    
    [self toggleBackForwardButtons];
}

- (void)forwardButtonTouchUp:(id)sender
{
    [self.webView goForward];
    
    [self toggleBackForwardButtons];
}

- (void)reloadButtonTouchUp:(id)sender
{
    [self.webView reload];
    
    [self toggleBackForwardButtons];
}

- (void)buttonActionTouchUp:(id)sender
{
    [self showActionSheet];
}

#pragma mark - Public Methods

- (void)setFixedTitleBarText:(NSString*)newTitleBarText
{
    _forcedTitleBarText = newTitleBarText;
    _showPageTitleOnTitleBar = NO;
}

- (void)loadURL:(NSURL*)url
{
    if (!self.webView) {
        _currentURL = url;
        [self initWebView];
    } else {
        NSURLRequest *request = [self requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

- (NSURLRequest *)requestWithURL:(NSURL *)url
{
    return [NSURLRequest requestWithURL: url];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[request.URL absoluteString] hasPrefix:@"sms:"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    } else {
		if ([[request.URL absoluteString] hasPrefix:@"http://www.youtube.com/v/"] ||
            [[request.URL host] isEqualToString:@"itunes.apple.com"] ||
            [[request.URL host] isEqualToString:@"phobos.apple.com"]) {
			[[UIApplication sharedApplication] openURL:request.URL];
			return NO;
		} else {
            if (!self.domainLockList || [self.domainLockList isEqualToString:@""]) {
				if (navigationType == UIWebViewNavigationTypeLinkClicked) {
					_currentURL = request.URL;
				}
                return YES;
            } else {
                NSArray *domainList = [self.domainLockList componentsSeparatedByString:@","];
                BOOL sendToSafari = YES;
                
                for (int x = 0; x < domainList.count; x++) {
                    if ([[request.URL absoluteString] hasPrefix:(NSString *)[domainList objectAtIndex:x]] == YES) {
                        sendToSafari = NO;
                    }
                }
				
                if (sendToSafari == YES) {
                    [[UIApplication sharedApplication] openURL:[request URL]];
                    return NO;
                } else {
					if (navigationType == UIWebViewNavigationTypeLinkClicked) {
						_currentURL = request.URL;
					}
                    return YES;
                }
            }
		}
	}
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self toggleBackForwardButtons];
    [self showActivityIndicators];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Show page title on title bar?
    if (self.showPageTitleOnTitleBar) {
        NSString *pageTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        [self setTitleBarText:pageTitle];
    }
    
    [self hideActivityIndicators];
    [self toggleBackForwardButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideActivityIndicators];
    
    // To avoid getting an error alert when you click on a link
    // before a request has finished loading.
    if ([error code] == NSURLErrorCancelled) {
        return;
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not load page", nil)
        message:error.localizedDescription
        delegate:self
        cancelButtonTitle:nil
        otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
	[alert show];
}

- (void)setBackgroundColor:(UIColor *)color
{
    _backgroundColor = color;
    self.webView.backgroundColor = color;
}

- (void)setOpaque:(BOOL)value
{
    _opaque = value;
    self.webView.opaque = value;
}

@end
