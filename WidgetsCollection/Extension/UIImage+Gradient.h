//
//  UIImage+Gradient.h
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RadientType) {
    RadientTypeTopToBottom, // 从上到下
    RadientTypeLeftToRight, // 从左到右
    RadientTypeLeftTopToRightBottom, // 从左上到右下
    RadientTypeLeftBottomToRightTop // 从左下到右上
};

@interface UIImage (Gradient)
- (instancetype)initWithSize:(CGSize)size gradientColors:(NSArray<UIColor *> *)colors percentage:(NSArray<NSNumber *> *)percents gradientType:(RadientType)type;
- (instancetype)cornerImageWithcornerRadius:(CGFloat)cornerRadius AndImage:(UIImage *)sourceImage;
@end

NS_ASSUME_NONNULL_END
