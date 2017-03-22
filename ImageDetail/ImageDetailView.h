//
//  ImageDetailView.h
//  ImageDetail
//
//  Created by shenzhenshihua on 2017/3/21.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDetailView : UIView

+ (id)imageDetailViewWithDataArray:(NSArray *)array currentPage:(NSInteger)page;

- (void)showView;
- (void)dismissView;
@end
