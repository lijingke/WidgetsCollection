//
//  UIImage+Gradient.h
//
//  Created by 杨敬 on 2018/12/3.
//  Copyright © 2018 grdoc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,HXSGRadientType) {
    HXSGRadientTypeTopToBottom,//从上到下
    HXSGRadientTypeLeftToRight,//从左到右
    HXSGRadientTypeLeftTopToRightBottom,//从左上到右下
    HXSGRadientTypeLeftBottomToRightTop//从左下到右上
};
@interface UIImage (HXSGradient)
-(instancetype)initWithSize:(CGSize)size gradientColors:(NSArray <UIColor *>*)colors percentage:(NSArray <NSNumber *>*)percents gradientType:(HXSGRadientType)type;
-(instancetype)cornerImageWithcornerRadius:(CGFloat)cornerRadius AndImage:(UIImage *)sourceImage;
@end

NS_ASSUME_NONNULL_END
