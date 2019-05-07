//
//  CSPageController.m
//  LabourService
//
//  Created by 朱来飞 on 2018/1/12.
//  Copyright © 2018年 朱来飞. All rights reserved.
//

#import "CSPageController.h"
#import "CSBaselineButton.h"
#import <Masonry/Masonry.h>

@interface CSPageController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic ,strong)UIPageViewController * pageController ;
@property (nonatomic ,strong)UIScrollView * titleScrView ;

@end

@implementation CSPageController{
    NSMutableArray * _vcs;
    NSMutableArray * _btns;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.view addSubview:self.titleScrView];
    [self.titleScrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
    }];
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.bottom.right.mas_equalTo(self.view);
    }];
    [self _reloadData];
    
    NSLog(@"my test");
}
- (void)reloadData{
    _selectedIndex = 0 ;
    [self _reloadData];
}
- (void)_reloadData {
    
    if ([self.delegate respondsToSelector:@selector(numberOfPagesInPageController:)]) {
        for (UIView * v in _titleScrView.subviews) {
            [v removeFromSuperview];
        }
        NSInteger c = [self.delegate numberOfPagesInPageController:self];
        CGRect rct = CGRectZero;
        _vcs = [NSMutableArray array];
        _btns = [NSMutableArray array];
        
        UIColor *lineColor = [UIColor groupTableViewBackgroundColor];
        UIColor *textColor = [UIColor blackColor];
    
        if (self.segmentLineColor) {
            lineColor = self.segmentLineColor ;
        }
        if (self.segmentTextColor) {
            textColor = self.segmentTextColor ;
        }
        for (NSInteger i = 0 ; i<c; i++) {
            if ([self.delegate respondsToSelector:@selector(pageController:viewControllerAtIndex:)]) {
                id vc = [self.delegate pageController:self viewControllerAtIndex:i];
                [_vcs addObject:vc];
            }
            if ([self.delegate respondsToSelector:@selector(pageController:titleForViewControllerAtIndex:)]) {
                NSString * title = [self.delegate pageController:self titleForViewControllerAtIndex:i];
                CGFloat btnWidth = [UIScreen mainScreen].bounds.size.width/c ;
                if (self.headerScrollable) {
                    CGSize size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44) options:0 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size ;
                    btnWidth = size.width ;
                }
                CSBaselineButton * btn = [[CSBaselineButton alloc]initWithFrame:CGRectMake(rct.origin.x+rct.size.width, 0, btnWidth, 44)];
                btn.tag = i + 1 ;
                btn.lineColor = lineColor;
                if (self.lineWidth > 0) {
                    btn.lineWidth = self.lineWidth ;
                }
                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [btn setTitleColor:textColor forState:UIControlStateSelected];
                [btn setTitle:title forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
                [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                [_titleScrView addSubview:btn];
                [_btns addObject:btn];
                if(self.selectedIndex == i) btn.selected = YES;
                rct = btn.frame ;
            }
        }
        _titleScrView.contentSize = CGSizeMake(((UIButton *)_btns.lastObject).frame.size.width+((UIButton *)_btns.lastObject).frame.origin.x, _titleScrView.frame.size.height);
        //滚动到选中标签。
        if (self.headerScrollable) {
            UIButton * b = _btns[self.selectedIndex];
            [self scrollViewOffset:b];
        }
        if (_vcs&&_vcs.count>0) {
            [_pageController setViewControllers:@[_vcs[self.selectedIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
    }
}

- (void)click:(UIButton *)btn{
    
    UIButton * b = _btns[self.selectedIndex];
    b.selected = NO;
    NSInteger direction = self.selectedIndex < (btn.tag - 1)?1:0;
    
    btn.selected = YES;
    self.selectedIndex = btn.tag - 1 ;
    if ([self.delegate respondsToSelector:@selector(pageController:currentIndex:)]) {
        [self.delegate pageController:self currentIndex:self.selectedIndex];
    }
    [_pageController setViewControllers:@[_vcs[self.selectedIndex]] direction:direction == 1?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    if (self.headerScrollable) {
        [self scrollViewOffset:btn];
    }
}
- (void)addClick{
//    if ([self.delegate respondsToSelector:@selector(pageControllerAddBtnClick:)]) {
//        [self.delegate pageControllerAddBtnClick:self];
//    }
}
-(void)scrollViewOffset:(UIButton *)button
{
    CGFloat f = [UIScreen mainScreen].bounds.size.width - 44;
    if (!(_titleScrView.contentSize.width> f)) {
        return;
    }
    if (CGRectGetMidX(button.frame)>f/2) {
        if (_titleScrView.contentSize.width< f/2+CGRectGetMidX(button.frame)) {
            [_titleScrView setContentOffset:CGPointMake(_titleScrView.contentSize.width-f, 0) animated:YES];
        }
        else{
            [_titleScrView setContentOffset:CGPointMake(CGRectGetMidX(button.frame)-f/2, 0) animated:YES];
        }
    }else{
        [_titleScrView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    //这里记录本次选择
    self.selectedIndex = [_vcs indexOfObject:pendingViewControllers[0]];

}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (completed) {
        
        NSInteger idx = [_vcs indexOfObject:previousViewControllers[0]] ;
        if (self.selectedIndex != idx ) {
            UIButton * btn = _btns[self.selectedIndex];
            //selctedIndex 不仅记录上次的选择还记录本次选择，这里记录上次选择
            self.selectedIndex = idx ;
            [self click:btn];
        }
        
        if ([self.delegate respondsToSelector:@selector(pageController:currentIndex:)]) {
            [self.delegate pageController:self currentIndex:self.selectedIndex];
        }
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSInteger index = [_vcs indexOfObject:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }else{
        return _vcs[--index];
    }
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [_vcs indexOfObject:viewController];
    if (index == _vcs.count-1 || index == NSNotFound) {
        return nil;
    }else{
        return _vcs[++index];
    }
}
-(UIScrollView *)titleScrView
{
    if (!_titleScrView) {
        _titleScrView = [[UIScrollView alloc] init];
        _titleScrView.backgroundColor = [UIColor whiteColor];
        _titleScrView.showsHorizontalScrollIndicator = NO;
        _titleScrView.showsVerticalScrollIndicator = NO;
    }
    return _titleScrView;
}
-(UIPageViewController *)pageController
{
    if (!_pageController) {
        _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageController.delegate = self;
        _pageController.dataSource = self;
    }
    return _pageController;
}
@end

