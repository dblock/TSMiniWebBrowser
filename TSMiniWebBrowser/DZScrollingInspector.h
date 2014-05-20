//
//  DZScrollingInspector.h
//  TSMiniWebBrowserDemo
//
//  Created by Denis Zamataev on 9/2/13.
//
//

#import <Foundation/Foundation.h>

typedef struct {
    CGFloat max;
    CGFloat min;
} DZScrollingInspectorLimit;

typedef struct {
    DZScrollingInspectorLimit portraitLimit;
    DZScrollingInspectorLimit landscapeLimit;
} DZScrollingInspectorTwoOrientationsLimits;

@interface DZScrollingInspector : NSObject

-(id)initWithObservedScrollView:(UIScrollView*)scrollView
               andOffsetKeyPath:(NSString*)offsetKeyPath
                andInsetKeypath:(NSString*)insetKeyPath
                andTargetObject:(NSObject*)target
  andTargetFramePropertyKeyPath:(NSString*)keypath
                      andLimits:(DZScrollingInspectorTwoOrientationsLimits)limits;

@property DZScrollingInspectorTwoOrientationsLimits limits;

-(void)suspend;
-(void)resume;
-(void)resetTargetToMinLimit;

+ (DZScrollingInspectorTwoOrientationsLimits) DZScrollingInspectorTwoOrientationsLimitsMake:(CGFloat)portraitMin
                                                                                portraitMax:(CGFloat)portraitMax
                                                                               landscapeMin:(CGFloat)landscapeMin
                                                                               landscapeMax:(CGFloat)landscapeMax;

@end
