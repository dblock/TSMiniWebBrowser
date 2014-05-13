### Next

* Added `TSMiniWebBrowser:showToolBar`, `opaque` and `backgroundColor` - [@dblock](https://github.com/dblock).
* Renamed `TSMiniWebBrowser:initWithUrl` to `initWithURL` - [@dblock](https://github.com/dblock).
* Exposed `TSMiniWebBrowser:requestWithURL:(NSURL *)url` for subclasses of `TSMiniWebBrowser` - [@dblock](https://github.com/dblock).

### 1.1 (5/12/2014)

* Initial maintined CocoaPods release, fork off [DZamataev/DZTSMiniWebBrowser](https://github.com/DZamataev/DZTSMiniWebBrowser) and [tonisalae/TSMiniWebBrowser](https://github.com/tonisalae/TSMiniWebBrowser) - [@dblock](https://github.com/dblock).
* Interface orientation changes reflect on the scrolling inspectors as limits - [@dzamataev](https://github.com/DZamataev).
* Added support for hiding top bar on scroll - [@dzamataev](https://github.com/DZamataev).
* Added storyboard support - [@simonrice](https://github.com/simonrice), [@dzamataev](https://github.com/DZamataev).
* Fix: cropped content when the content of the scrollview is smaller than the frame of the scrollview - [@dzamataev](https://github.com/DZamataev).
* Animation duration now respects left distance - [@dzamataev](https://github.com/DZamataev).
* Added scroll view pan gesture recognizer state detection via KVO in order to know when touch (dragging) ended - [@dzamataev](https://github.com/DZamataev).
* Corrected animation for target reaching limit if it was left half-way up or down - [@dzamataev](https://github.com/DZamataev).
* Implemented webView contentInset setting according to browser presentation mode - [@dzamataev](https://github.com/DZamataev).
* Added statusBarStyle property - [@dzamataev](https://github.com/DZamataev).
* Added podspec - [@neoneye](https://github.com/neoneye).
* Open actionsheet from action button - [@pj4533](https://github.com/pj4533).
