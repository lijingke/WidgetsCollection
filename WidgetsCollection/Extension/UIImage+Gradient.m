//
//  UIImage+Gradient.m
//
//  Created by 杨敬 on 2018/12/3.
//  Copyright © 2018 grdoc. All rights reserved.
//

#import "UIImage+Gradient.h"

@implementation UIImage (Gradient)
-(instancetype)cornerImageWithcornerRadius:(CGFloat)cornerRadius AndImage:(UIImage *)sourceImage {
 
    //生成一张新图片
    //1.开上一个位图上下文
    UIGraphicsBeginImageContextWithOptions(sourceImage.size, NO, 0.0);
    
    //2.把图片画在 位图上下文
    //2.1图片要裁剪成有圆角
    CALayer *layer = [CALayer layer];//图层里有一张图片
    
//    #warning 图层的大小一定要设置
    //图层设置大小
    layer.bounds = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height);
    
    //设置内容
    layer.contents = (id)sourceImage.CGImage;
    //设置圆角
    layer.cornerRadius = cornerRadius;
    //裁剪
    layer.masksToBounds = YES;
    
    //设置边框
//    layer.borderWidth = borderWidth;
//
//    //设置边框颜色
//    layer.borderColor = borderColor.CGColor;
    
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //3.从位图上下文 获取新图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    //4.结束位图的编辑
    UIGraphicsEndImageContext();
    
    //5.返回新图片
    return newImg;
}
-(instancetype)initWithSize:(CGSize)size gradientColors:(NSArray<UIColor *> *)colors percentage:(NSArray<NSNumber *> *)percents gradientType:(HXSGRadientType)type {
    
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }

    CGFloat locations[percents.count];
    for (int i = 0; i < percents.count; i++) {
        locations[i] = [percents[i] floatValue];
    }
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, locations);
    CGPoint start;
    CGPoint end;
    switch (type) {
        case HXSGRadientTypeTopToBottom:
            start = CGPointMake(size.width/2, 0.0);
            end = CGPointMake(size.width/2, size.height);
            break;
        case HXSGRadientTypeLeftToRight:
            start = CGPointMake(0.0, size.height/2);
            end = CGPointMake(size.width, size.height/2);
            break;
        case HXSGRadientTypeLeftTopToRightBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, size.height);
            break;
        case HXSGRadientTypeLeftBottomToRightTop:
            start = CGPointMake(0.0, size.height);
            end = CGPointMake(size.width, 0.0);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}
@end
