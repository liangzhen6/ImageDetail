//
//  ImageDetailView.m
//  ImageDetail
//
//  Created by shenzhenshihua on 2017/3/21.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "ImageDetailView.h"
#import "ImageDetailCollectionViewCell.h"
#import "ImageModel.h"

#define IOS_VERSION      [[[UIDevice currentDevice] systemVersion] floatValue]
#define Screen_Frame     [[UIScreen mainScreen] bounds]
#define Screen_Width     [[UIScreen mainScreen] bounds].size.width
#define Screen_Height    [[UIScreen mainScreen] bounds].size.height

#define SpaceWidth  20

NSString * const registerId = @"collectionCell";

@interface ImageDetailView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)UIPageControl * pageControl;
@property(nonatomic,strong)NSMutableArray * dataSource;

@property(nonatomic,assign)NSInteger currentPage;

@property(nonatomic,strong)ImageDetailCollectionViewCell * currentCell;

@end

@implementation ImageDetailView

+ (id)imageDetailViewWithDataArray:(NSArray *)array currentPage:(NSInteger)page {
    ImageDetailView * imageDetail = [[ImageDetailView alloc] initWithFrame:Screen_Frame];
    imageDetail.dataSource = [[NSMutableArray alloc] init];
    for (NSString * str in array) {
        ImageModel * model = [[ImageModel alloc] init];
        model.url = str;
        [imageDetail.dataSource addObject:model];
    }
    
    imageDetail.currentPage = page;
    
    [imageDetail.collectionView reloadData];
    
    return imageDetail;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)showView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    self.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:.1 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];


}
- (void)dismissView {
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:.1 animations:^{
        self.transform = CGAffineTransformMakeScale(0.0000000001, 0.00000001);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    

}


- (void)initView {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:pan];
}

- (void)panAction:(UIPanGestureRecognizer *)gesture {
    CGPoint piont = [gesture translationInView:self];
    CGFloat flo = (500 - piont.y)/500;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            {
             _currentCell = [self getCurrentCell];
            }
            break;
        case UIGestureRecognizerStateChanged:
            {
                self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:flo];
                if (flo<1 && flo>0) {
                    [_currentCell changeSize:flo centerY:piont.y];
                }

            }
            break;
        case UIGestureRecognizerStateEnded:
            {
                self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
                [_currentCell changeSize:1.0 centerY:0.0];
            }
            break;
            
        default:
            break;
    }

    NSLog(@"%f%f",piont.x, piont.y);
}

- (ImageDetailCollectionViewCell *)getCurrentCell {
    
    NSInteger index = self.collectionView.contentOffset.x / Screen_Width;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    ImageDetailCollectionViewCell * currentcell = (ImageDetailCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    NSLog(@"%ld--%@",indexPath.row,currentcell);
    
    return currentcell;
    
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    self.pageControl.numberOfPages = self.dataSource.count;
    CGSize size = [self.pageControl sizeForNumberOfPages:self.dataSource.count];
    self.pageControl.frame = CGRectMake(Screen_Width/2-size.width/2, Screen_Height-size.height-20, size.width, size.height);
    
    self.pageControl.currentPage = currentPage;
    
//    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:currentPage inSection:0];
//    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    [self.collectionView setContentOffset:CGPointMake((Screen_Width+SpaceWidth)*currentPage, 0)];

}


- (UIPageControl *)pageControl {
    if (_pageControl==nil) {
        _pageControl = [[UIPageControl alloc] init];
        //如果只有一页就隐藏
        _pageControl.hidesForSinglePage = YES;
        //设置page的颜色
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        //设置当前page的颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

- (UICollectionView *)collectionView {

    if (_collectionView==nil) {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = SpaceWidth; //设置每一行的间距
        layout.sectionInset = UIEdgeInsetsMake(0,SpaceWidth/2, 0, SpaceWidth/2);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        layout.itemSize=CGSizeMake(Screen_Width, Screen_Height);  //设置每个单元格的大小
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-SpaceWidth/2, 0, Screen_Width + SpaceWidth, Screen_Height) collectionViewLayout:layout];
        _collectionView.center = self.center;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[ImageDetailCollectionViewCell class] forCellWithReuseIdentifier:registerId];
        
    }
    return _collectionView;

}


#pragma mark ================UICollectionViewDelegate====================

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageDetailCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:registerId forIndexPath:indexPath];
    cell.model = [self.dataSource objectAtIndex:indexPath.row];
    __weak typeof (self)ws = self;
    [cell setDismissBlock:^{
        [ws dismissView];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[ImageDetailCollectionViewCell class]]) {
        [(ImageDetailCollectionViewCell *)cell updateImageSize];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[ImageDetailCollectionViewCell class]]) {
        [(ImageDetailCollectionViewCell *)cell updateImageSize];
    }
}

#pragma mark  ==========UICollectionView->scrollerViewDeleagte=====================
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat X = scrollView.contentOffset.x;
    NSInteger page = X/(Screen_Width+SpaceWidth);
//    NSLog(@"%f-----%f-----%ld",X,Screen_Width,(long)page);
    
    [self.pageControl setCurrentPage:page];

}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat X = scrollView.contentOffset.x;
    NSInteger page = X/(Screen_Width+SpaceWidth);
//    NSLog(@"%f-----%f-----%ld",X,Screen_Width,(long)page);
    
    [self.pageControl setCurrentPage:page];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
