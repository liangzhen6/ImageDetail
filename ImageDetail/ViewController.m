//
//  ViewController.m
//  ImageDetail
//
//  Created by shenzhenshihua on 2017/3/21.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "ViewController.h"
#import "ImageDetailView.h"
@interface ViewController ()
@property(nonatomic,strong)ImageDetailView * myView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _myView = [ImageDetailView imageDetailViewWithDataArray:@[@"http://n.sinaimg.cn/news/transform/20170321/1X_i-fycnyhm0561349.jpg",@"http://n.sinaimg.cn/news/1_img/upload/8de453bf/20170321/BNOM-fycnyhm0534251.jpg",@"http://n.sinaimg.cn/news/crawl/20170321/_L4d-fycnyhm0785090.jpg",@"http://n.sinaimg.cn/news/1_img/upload/8de453bf/20170321/nuDB-fycnyhm0613821.jpg",@"http://images.lieqinews.com/pushimg/20170320/1490023057320496.jpg"] currentPage:2];
    
//    [self.view addSubview:view];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [_myView showView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
