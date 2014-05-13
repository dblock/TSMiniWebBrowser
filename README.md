## TSMiniWebBrowser

In-app web browser control for iOS apps.

[![Build Status](https://travis-ci.org/dblock/TSMiniWebBrowser.svg)](https://travis-ci.org/dblock/TSMiniWebBrowser)

![Demo](Screenshots/demo.gif "Demo animation")

## Screenshots

[![Alt][screenshot1_thumb]][screenshot1]    [![Alt][screenshot2_thumb]][screenshot2]    [![Alt][screenshot3_thumb]][screenshot3]
[screenshot1_thumb]: Screenshots/shot_01_thumb.png
[screenshot1]: Screenshots/shot_01.png
[screenshot2_thumb]: Screenshots/shot_02_thumb.png
[screenshot2]: Screenshots/shot_02.png
[screenshot3_thumb]: Screenshots/shot_03_thumb.png
[screenshot3]: Screenshots/shot_03.png

## Features

TSMiniWebBrowser offers the following **features**:

* Back and forward buttons.
* Reload button (*optional*).
* Activity indicator while page is loading.
* Action button to open the current page in Safari (*optional*).
* Displays the page title at the navigation bar (*optional*).
* Displays the current URL at the top of the “Open in Safari” action sheet (*optional*).
* Customizable bar style: default, black, black translucent.

TSMiniWebBrowser **supports 3 presentation modes**:

* **Navigation controller mode**. Using this mode you can push the browser to your navigation controller.
* **Modal mode**. Using this mode you can present the browser modally. A title bar with a dismiss button will be automatically added.
* **Tab bar mode**. Using this mode you can show the browser as a tab of a tab bar view controller. The toolbar with the navigation controls will be positioned at the top of the view automatically.

## Usage

Create and display the browser with defaults:

```objc
TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithURL:[NSURL URLWithString:@"http://indiedevstories.com"]];
[self.navigationController pushViewController:webBrowser animated:YES];
```

Try the [TSMiniWebBrowserDemo](TSMiniWebBrowserDemo) application. To test the tab bar mode go to the `application: didFinishLaunchingWithOptions:` method in `AppDelegate.m` and set the `BOOL wantTabBarDemo = NO;` value to `YES`.

```objc
TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithURL:[NSURL URLWithString:@"http://indiedevstories.com"]];
webBrowser.showURLStringOnActionSheetTitle = YES;
webBrowser.showPageTitleOnTitleBar = YES;
webBrowser.showActionButton = YES;
webBrowser.showReloadButton = YES;
webBrowser.mode = TSMiniWebBrowserModeNavigation;

webBrowser.barStyle = UIBarStyleBlack;

if (webBrowser.mode == TSMiniWebBrowserModeModal) {
    webBrowser.modalDismissButtonTitle = @"Home";
    [self presentModalViewController:webBrowser animated:YES];
} else if(webBrowser.mode == TSMiniWebBrowserModeNavigation) {
    [self.navigationController pushViewController:webBrowser animated:YES];
}
```

## History

This is the maintained fork of [TSMiniWebBrowser](https://github.com/tonisalae/TSMiniWebBrowser), available via CocoaPods. It contains all the improvements from [DZTSMiniWebBrowser](https://github.com/DZamataev/DZTSMiniWebBrowser). Thanks to Toni Sala and Denis Zamataev for all the hard work. See [CHANGELOG](CHANGELOG.md) for details.

## License

MIT License, see [LICENSE](LICENSE) for details.
