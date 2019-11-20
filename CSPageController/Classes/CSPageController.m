//
//  MyTableView.m
//  MyTableView_testing
//
//  Created by 万存 on 16/4/1.
//  Copyright © 2016年 WanCun. All rights reserved.
//

#import "CSPageController.h"
#import "UIViewController+Identifier.h"
#import "CSBaselineButton.h"
#import "CSPageView.h"
#import <Masonry/Masonry.h>

@interface CSPageController()<CSPageViewDelegate>

@property (nonatomic ,strong) UIScrollView * titleScrView ;
@property (nonatomic ,strong) CSPageView * pageView ;
@property (nonatomic ,assign) NSInteger numsOfRows ;
@end

@implementation CSPageController

- (instancetype)init {
    if (self = [super init]) {
        [self _globalSet];
    }
    return self ;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _globalSet];
    }
    return  self ;
}
- (void)_globalSet {
    
    self.selectedIndex = 0 ;
    self.selectTextColor = [UIColor redColor];
    self.normalTextColor = [UIColor blackColor];
    
    self.segmentLineHeight = 2 ;
    self.segmentLineColor = [UIColor redColor];
    
    self.horizontalSpacing = 5 ;
    self.headerScrollable = NO ;
    
    [self addSubview:self.titleScrView];
    [self addSubview:self.pageView];
    
    [self.titleScrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleScrView.mas_bottom) ;
        make.leading.trailing.bottom.mas_equalTo(self);
    }];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadData];
}
- (void)reloadData {
    
    if ([self.dataSource respondsToSelector:@selector(numberOfPagesInPageController:)]) {
        _numsOfRows = [self.dataSource numberOfPagesInPageController:self] ;
    }
    CGRect  titleRect = CGRectZero;
    for (int i = 0 ; i <_numsOfRows ; i++) {
        //title
        NSString * title = [self.delegate pageController:self titleForViewControllerAtIndex:i];
        CGFloat btnWidth = self.bounds.size.width / _numsOfRows ;
        if (self.headerScrollable) {
            CGSize size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44) options:0 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size ;
            btnWidth = size.width ;
        }
        CSBaselineButton * btn = [[CSBaselineButton alloc]initWithFrame:CGRectMake(titleRect.origin.x + self.horizontalSpacing + titleRect.size.width, 0, btnWidth, 44)];
        btn.tag = i + 1 ;
        btn.lineColor = self.segmentLineColor;
        if (self.segmentLineHeight > 0) {
            btn.lineHeight = self.segmentLineHeight ;
        }
        btn.headerTextFlexibleWidth = self.headerScrollable;
        [btn setTitleColor:self.normalTextColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectTextColor forState:UIControlStateSelected];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_titleScrView addSubview:btn];
        if(self.selectedIndex == i) {
            btn.selected = YES;
        }
        titleRect = btn.frame ;
        if (i == _numsOfRows - 1) {
            _titleScrView.contentSize = CGSizeMake(CGRectGetMaxX(titleRect) + self.horizontalSpacing , 44) ;
        }
    }
    if (self.headerScrollable && self.selectedIndex > 0) {
        [self scrollViewOffset:[_titleScrView viewWithTag:self.selectedIndex + 1]];
        [self.pageView scrollToViewControllerAtIndex:self.selectedIndex];
    }
}
- (NSInteger)numberOfPagesInPageView:(CSPageView *)pageView {
    if ([self.dataSource respondsToSelector:@selector(numberOfPagesInPageController:)]) {
        return [self.dataSource numberOfPagesInPageController:self];
    }
    return 0 ;
}
- (UIViewController *)pageView:(CSPageView *)pageView viewControllerAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(pageController:viewControllerAtIndex:)]) {
        return [self.dataSource pageController:self viewControllerAtIndex:index];
    }
    return nil ;
}
- (UIViewController *)dequeueReusableViewControllerWithIdentifier:(NSString *)identifier {
    return [self.pageView dequeueReusableViewControllerWithIdentifier:identifier];
}
- (void)registeViewControllerClass:(Class)cls forReuseIdentifier:(NSString *)identifier {
    [self.pageView registeViewControllerClass:cls forReuseIdentifier:identifier];
}
- (void)pageViewDidScrollToViewControllerAtIndex:(NSInteger)index {
    NSLog(@"index === %ld" ,index);
    [self titleScrollViewStateChanged:[_titleScrView viewWithTag:index + 1]];
}
- (void)click:(CSBaselineButton *)btn {
    
    [self titleScrollViewStateChanged:btn];
    [self.pageView scrollToViewControllerAtIndex:self.selectedIndex];
}

- (void)titleScrollViewStateChanged:(CSBaselineButton *)btn {
    
    CSBaselineButton * last = [_titleScrView viewWithTag:self.selectedIndex + 1];
    last.selected = !last.selected ;
    
    self.selectedIndex = btn.tag - 1 ;
    btn.selected = !btn.selected ;

    if (self.headerScrollable) {
        [self scrollViewOffset:btn];
    }
}

- (void)scrollViewOffset:(UIButton *)button
{
    CGFloat f = self.bounds.size.width;
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

- (UIScrollView *)titleScrView {
    if (!_titleScrView) {
        _titleScrView = [[UIScrollView alloc] init];
        _titleScrView.backgroundColor = [UIColor whiteColor];
        _titleScrView.showsHorizontalScrollIndicator = NO;
        _titleScrView.showsVerticalScrollIndicator = NO;
        _titleScrView.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
    }
    return _titleScrView;
}
- (CSPageView *)pageView {
    if (!_pageView) {
        _pageView = [[CSPageView alloc]init];
        _pageView.dataSource = self ;
    }
    return _pageView ;
}
@end
