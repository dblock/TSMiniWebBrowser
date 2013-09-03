//
//  DZScrollingInspector.h
//  TSMiniWebBrowserDemo
//
//  Created by Denis Zamataev on 9/2/13.
//
//

#import <Foundation/Foundation.h>

#define DZScrollingInspector_CONTENT_OFFSET_KEYPATH @"contentOffset"
#define DZScrollingInspector_CONTENT_INSET_KEYPATH @"contentInset"

typedef enum {
    DZScrollDirectionNone,
    DZScrollDirectionUp,
    DZScrollDirectionDown
} DZScrollDirection;

typedef enum {
    DZScrollingInspectorTargetPropertySetterOptionNumber,
    DZScrollingInspectorTargetPropertySetterOptionFrameOriginY
} DZScrollingInspectorTargetPropertySetterOption;

@interface DZScrollingInspector : NSObject
{
    UIScrollView *_scrollView;
    NSObject *_targetObject;
    NSString *_targetKeyPath;
    DZScrollingInspectorTargetPropertySetterOption _targetPropertySetterOption;
    CGFloat _targetPropertyInitialValue;
    CGFloat _targetPropertyLowerLimit;
    CGFloat _targetPropertyUpperLimit;
    
    CGFloat _inset;
    CGFloat _offset;
    
    BOOL _isSuspended;
    DZScrollDirection _scrollDirection;
}
-(id)initWithObservedScrollView:(UIScrollView*)scrollView
                andTargetObject:(NSObject*)target
       andTargetPropertyKeyPath:(NSString*)keypath
andSetterOption:(DZScrollingInspectorTargetPropertySetterOption)setterOption
                  andLowerLimit:(CGFloat)lowerLimit
                  andUpperLimit:(CGFloat)upperLimit;

@property CGFloat upperLimit;
@property CGFloat lowerLimit;

-(void)suspend;
-(void)resume;


@end
