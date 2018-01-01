//
//  UIImageView+JMRadius.m
//  JMRoundedCornerDemo
//
//  Created by 饶志臻 on 2016/10/9.
//  Copyright © 2016年 饶志臻. All rights reserved.
//

#import "UIImageView+JMRadius.h"

#if __has_include(<SDWebImage/UIImageView+WebCache.h>)
#import <SDWebImage/UIImageView+WebCache.h>
#else
#import "UIImageView+WebCache.h"
#endif

#if __has_include(<SDWebImage/UIView+WebCache.h>)
#import <SDWebImage/UIView+WebCache.h>
#else
#import "UIView+WebCache.h"
#endif

@implementation UIImageView (JMRadius)

- (void)jm_setImageWithCornerRadius:(CGFloat)radius imageURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder size:(CGSize)size {
    [self jm_setImageWithJMRadius:JMRadiusMake(radius, radius, radius, radius) imageURL:imageURL placeholder:placeholder borderColor:nil borderWidth:0 backgroundColor:nil contentMode:UIViewContentModeScaleAspectFill size:size];
}

- (void)jm_setImageWithJMRadius:(JMRadius)radius imageURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder size:(CGSize)size {
    [self jm_setImageWithJMRadius:radius imageURL:imageURL placeholder:placeholder borderColor:nil borderWidth:0 backgroundColor:nil contentMode:UIViewContentModeScaleAspectFill size:size];
}

- (void)jm_setImageWithCornerRadius:(CGFloat)radius imageURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder contentMode:(UIViewContentMode)contentMode size:(CGSize)size {
    [self jm_setImageWithJMRadius:JMRadiusMake(radius, radius, radius, radius) imageURL:imageURL placeholder:placeholder borderColor:nil borderWidth:0 backgroundColor:nil contentMode:contentMode size:size];
}

- (void)jm_setImageWithJMRadius:(JMRadius)radius imageURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder contentMode:(UIViewContentMode)contentMode size:(CGSize)size {
    [self jm_setImageWithJMRadius:radius imageURL:imageURL placeholder:placeholder borderColor:nil borderWidth:0 backgroundColor:nil contentMode:contentMode size:size];
}

- (void)jm_setImageWithJMRadius:(JMRadius)radius imageURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor contentMode:(UIViewContentMode)contentMode size:(CGSize)size {
    
    NSString *imageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:imageURL];
    
    NSString *transformKey =  [NSString stringWithFormat:@"%@%@%.1f%@%li%@", NSStringFromJMRadius(radius), borderColor.description, borderWidth, backgroundColor.description, (long)contentMode,NSStringFromCGSize(size)];
    NSString *transformImageKey = [NSString stringWithFormat:@"%@--%@", imageKey, transformKey];
    UIImage *cacheImage = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:transformImageKey];
    
    if (cacheImage) {
        self.image = cacheImage;
        return;
    }
    
    cacheImage = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:imageKey];
    
    if (cacheImage) {
        self.image = [UIImage jm_setJMRadius:radius image:cacheImage size:size borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor withContentMode:contentMode];
        return;
    }
    
    UIImage *placeholderImage;
    if (placeholder || borderWidth > 0 || backgroundColor){
        placeholderImage = [UIImage jm_setJMRadius:radius image:placeholder size:size borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor withContentMode:contentMode];
    }
    
    __weak __typeof(self)wself = self;
    
    [self sd_internalSetImageWithURL:imageURL placeholderImage:placeholderImage options:kNilOptions operationKey:nil setImageBlock:^(UIImage * _Nullable image, NSData * _Nullable imageData) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            UIImage *currentImage = [UIImage jm_setJMRadius:radius image:image size:size borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor withContentMode:contentMode];
            
            dispatch_main_async_safe(^{
                
                __strong __typeof (wself) sself = wself;
                
                if ([sself isKindOfClass:[UIImageView class]]) {
                    UIImageView *imageView = (UIImageView *)sself;
                    imageView.image = currentImage;
                }
            });
        });
        
    } progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
}

@end
