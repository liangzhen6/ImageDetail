//
//  ImageModel.m
//  ImageDetail
//
//  Created by shenzhenshihua on 2017/3/21.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "ImageModel.h"
#import "ImageHeader.h"
@implementation ImageModel

- (CGRect)smallImageViewframeOriginWindow {
    return [self.smallImageView convertRect:self.smallImageView.bounds toView:self.smallImageView.window];
}

- (CGSize)smallImageSize {
    return self.smallImageView.image.size;
}

- (CGRect)imageViewframeShowWindow {
    CGFloat imageW = self.smallImageSize.width;
    CGFloat imageH = self.smallImageSize.height;
    CGRect frame;
    CGFloat H = Screen_Width * imageH/imageW;
    if (imageH/imageW > Screen_Height/Screen_Width) {
        //长图 指图片宽度方大为屏幕宽度时，高度超过屏幕高度
        frame = CGRectMake(0, 0, Screen_Width, H);
    } else {
        //非 长图
        frame = CGRectMake(0, Screen_Height/2 - H/2, Screen_Width, H);
    }
    return frame;
}


@end
