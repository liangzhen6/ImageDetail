//
//  ImageModel.h
//  ImageDetail
//
//  Created by shenzhenshihua on 2017/3/21.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageModel : NSObject
@property(nonatomic,copy)NSString * urlStr;
@property(nonatomic,assign)CGSize smallImageSize;
@property(nonatomic,weak)UIImageView *  smallImageView;

//在原始的window上的frame
- (CGRect)smallImageViewframeOriginWindow;
//图片放大后充满屏幕后的frame
- (CGRect)imageViewframeShowWindow;
@end
