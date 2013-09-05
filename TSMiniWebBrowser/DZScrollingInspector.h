//
//  DZScrollingInspector.h
//  TSMiniWebBrowserDemo
//
//  Created by Denis Zamataev on 9/2/13.
//
//

#import <Foundation/Foundation.h>

/* 
 the used UIView and UIScrollView properties keypaths defined here
 in order to accomodate future possible renaming of these properties
 */
#define DZScrollingInspector_CONTENT_OFFSET_KEYPATH @"contentOffset"
#define DZScrollingInspector_CONTENT_INSET_KEYPATH @"contentInset"
#define DZScrollingInspector_FRAME_KEYPATH @"frame"
#define DZScrollingInspector_IS_DRAGGING_KEYPATH @"isDragging"

typedef enum {
    DZScrollDirectionNone,
    DZScrollDirectionUp,
    DZScrollDirectionDown
} DZScrollDirection;

typedef enum {
    DZScrollingInspectorTargetPropertySetterOptionNumber,
    DZScrollingInspectorTargetPropertySetterOptionFrameOriginY
} DZScrollingInspectorTargetPropertySetterOption;

typedef struct {
    CGFloat max;
    CGFloat min;
} DZScrollingInspectorLimit;

typedef struct {
    DZScrollingInspectorLimit portraitLimit;
    DZScrollingInspectorLimit landscapeLimit;
} DZScrollingInspectorTwoOrientationsLimits;



@interface DZScrollingInspector : NSObject
{
    UIScrollView *_scrollView;
    BOOL _scrollViewIsDragging;
    
    NSObject *_targetObject;
    NSString *_targetFramePropertyKeyPath;
    CGFloat _targetFramePropertyInitialValue;
    BOOL _isAnimatingTargetObject;
    
    DZScrollingInspectorTwoOrientationsLimits _limits;
    
    NSString *_insetKeypath;
    NSString *_offsetKeypath;
    CGFloat _inset;
    CGFloat _offset;
    
    BOOL _isSuspended;
    DZScrollDirection _scrollDirection;
    DZScrollDirection _lastScrollDirectionThatWasntNone;
}
-(id)initWithObservedScrollView:(UIScrollView*)scrollView
               andOffsetKeyPath:(NSString*)offsetKeyPath
                andInsetKeypath:(NSString*)insetKeyPath
                andTargetObject:(NSObject*)target
  andTargetFramePropertyKeyPath:(NSString*)keypath
                      andLimits:(DZScrollingInspectorTwoOrientationsLimits)limits;

@property DZScrollingInspectorTwoOrientationsLimits limits;

-(void)suspend;
-(void)resume;

DZScrollingInspectorTwoOrientationsLimits DZScrollingInspectorTwoOrientationsLimitsMake(CGFloat portraitMin, CGFloat portraitMax, CGFloat landscapeMin, CGFloat landscapeMax);

@end
