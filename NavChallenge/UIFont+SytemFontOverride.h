#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@interface UIFont (SytemFontOverride)
+ (void)replaceClassSelector:(SEL)originalSelector withSelector:(SEL)modifiedSelector;
+ (void)replaceInstanceSelector:(SEL)originalSelector withSelector:(SEL)modifiedSelector;
+ (UIFont *)regularFontWithSize:(CGFloat)size;
+ (UIFont *)boldFontWithSize:(CGFloat)size;
+ (UIFont *)italicFontOfSize:(CGFloat)fontSize;
- (id)initCustomWithCoder:(NSCoder *)aDecoder;
+ (void)load;

@end