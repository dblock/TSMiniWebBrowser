//
//  DZScrollingInspector.m
//  TSMiniWebBrowserDemo
//
//  Created by Denis Zamataev on 9/2/13.
//
//

#import "DZScrollingInspector.h"

@implementation DZScrollingInspector

- (id)initWithObservedScrollView:(UIScrollView *)scrollView andTargetObject:(NSObject *)target andTargetPropertyKeyPath:(NSString *)keypath andSetterOption:(DZScrollingInspectorTargetPropertySetterOption)setterOption
{
    if (self = [super init])
    {
        _scrollDirection = DZScrollDirectionNone;
        _isSuspended = NO;
        _offset = 0.0f;
        _inset = 0.0f;
        
        _scrollView = scrollView;
        _targetObject = target;
        _targetKeyPath = keypath;
        _targetPropertySetterOption = setterOption;
        
        _targetPropertyInitialValue = 0.0f;
        
        switch (setterOption) {
            case DZScrollingInspectorTargetPropertySetterOptionNumber:
            {
                NSNumber *num = [target valueForKey:keypath];
                _targetPropertyInitialValue = num.floatValue;
            }
                break;
                
            case DZScrollingInspectorTargetPropertySetterOptionFrameOriginY:
            {
                NSValue *val = [target valueForKey:keypath];
                _targetPropertyInitialValue = val.CGRectValue.origin.y;
            }
                break;
                
            default:
                break;
        }
        
        [self registerAsObserver];
    }
    return self;
}

// Apple documentation about the observing https://developer.apple.com/library/ios/DOCUMENTATION/Cocoa/Conceptual/KeyValueObserving/Articles/KVOBasics.html
- (void)registerAsObserver {
    /*
     Register self to receive change notifications for the "_keypath_" property of
     the 'scrollView' object and specify that both the old and new values of "_keypath_"
     should be provided in the observe… method.
     */
    [_scrollView addObserver:self
                  forKeyPath: DZScrollingInspector_CONTENT_OFFSET_KEYPATH
                 options:(NSKeyValueObservingOptionNew |
                          NSKeyValueObservingOptionOld)
                 context:NULL];
    
    [_scrollView addObserver:self
                  forKeyPath: DZScrollingInspector_CONTENT_INSET_KEYPATH
                     options:(NSKeyValueObservingOptionNew |
                              NSKeyValueObservingOptionOld)
                     context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    CGFloat offset = 0.0f;
    CGFloat inset = 0.0f;
    
    BOOL offsetChanged = NO;
    BOOL insetChanged = NO;
    
    if ([keyPath isEqual:DZScrollingInspector_CONTENT_OFFSET_KEYPATH]) {
        NSValue *newValue = [change objectForKey:NSKeyValueChangeNewKey];
        offset = newValue.CGPointValue.y;
        NSLog(@"new offset %f", offset);
        
        offsetChanged = YES;
    }
    
    
    if ([keyPath isEqual:DZScrollingInspector_CONTENT_INSET_KEYPATH]) {
        NSValue *newValue = [change objectForKey:NSKeyValueChangeNewKey];
        inset = newValue.UIEdgeInsetsValue.top;
        NSLog(@"new inset %f", inset);
        
        insetChanged = YES;
    }
    
    
    if (offsetChanged) {
        inset = _inset;
    }
    if (insetChanged) {
        offset = _offset;
    }
    
    [self assumeShiftDeltaForTargetAccordingToOffset:offset andInset:inset];
    
    /*
     Be sure to call the superclass's implementation *if it implements it*.
     NSObject does not implement the method.
     
    [super observeValueForKeyPath:keyPath
                         ofObject:object
                           change:change
                          context:context];
     */
}

- (void)assumeShiftDeltaForTargetAccordingToOffset:(CGFloat)newOffset andInset:(CGFloat)newInset
{
    // assume scroll direction
    DZScrollDirection scrollDirection = DZScrollDirectionNone;
    if (_offset < newOffset)
        scrollDirection = DZScrollDirectionUp;
    else if (_offset > newOffset)
        scrollDirection = DZScrollDirectionDown;
    _scrollDirection = scrollDirection;
    
    // calculate movement delta
    CGFloat delta = (newInset + newOffset) - (_inset + _offset);
    
    if (delta > 0 && ((newInset + newOffset) > 0)) {
        NSLog(@"up");
        //CGFloat shiftedY = _trackedView.origin.y - yDelta;
        
    
    }


    // set stored values
    _offset = newOffset;
    _inset = newInset;
}


- (void)unregisterForChangeNotification {
    [_scrollView removeObserver:self forKeyPath:DZScrollingInspector_CONTENT_OFFSET_KEYPATH];
    [_scrollView removeObserver:self forKeyPath:DZScrollingInspector_CONTENT_INSET_KEYPATH];
}


-(void)suspend
{
    _isSuspended = YES;
}

-(void)resume
{
    _isSuspended = NO;
}

-(void)dealloc
{
    [self unregisterForChangeNotification];
}

@end
