/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_XANDGREATER (IS_IPHONE && SCREEN_MAX_LENGTH >= 812.0)

#define STATUS_BAR_HEIGHT (IS_IPHONE_XANDGREATER ? 44.f : 20.f)
#define TAB_BAR_HEIGHT (IS_IPHONE_XANDGREATER ? 83.f : 49.f)
#define NAVIGATION_STATUS_HEIGHT (IS_IPHONE_XANDGREATER ? 88.f : 64.f)
#define APPMainColor [UIColor redColor]
#define HJTFont(_AAA) [UIFont systemFontOfSize:(_AAA)]
CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (ViewFrameGeometry)
@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

- (void)setAnchorPointTo:(CGPoint)point;
@end
