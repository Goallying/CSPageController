//
//  CSPageController.h
//  LabourService
//
//  Created by 朱来飞 on 2018/1/12.
//  Copyright © 2018年 朱来飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSPageController ;
@protocol CSPageControllerDelegate<NSObject>
@required

- (NSInteger)numberOfPagesInPageController:(CSPageController *)pageController;
- (UIViewController *)pageController:(CSPageController *)pageController viewControllerAtIndex:(NSInteger)index;
- (NSString *)pageController:(CSPageController *)pageController titleForViewControllerAtIndex:(NSInteger)index ;
@optional
- (void)pageController:(CSPageController *)pageController currentIndex:(NSInteger)index;
//- (void)pageControllerAddBtnClick:(CSPageController *)pageController ;

@end

@interface CSPageController : UIViewController
@property (nonatomic ,weak)id<CSPageControllerDelegate>delegate ;

/**
 //此属性应在CSPageController 初始化过后立即赋值，避免Viewcontrollers 已经有值而selectIndex却无值。
 */
@property (nonatomic ,assign)NSInteger selectedIndex ;

/**
 selected color
 */
@property (nonatomic ,strong)UIColor * segmentLineColor ;
@property (nonatomic ,strong)UIColor * segmentTextColor ;

/**
 segment bottom line width .
 */
@property (nonatomic ,assign) CGFloat lineWidth ;

/**
 是否允许滚动选择(防止选项过多，屏幕宽度有限)。 defalut NO.
 */
@property (nonatomic ,assign) BOOL headerScrollable ;

/**
 头部标题文字宽度自适应还是宽度均分,如果数量很多需要滑动应该设置headerScrollable 和 headerTextFlexibleWidth
 */
@property (nonatomic ,assign) BOOL headerTextFlexibleWidth ;

/**
 数据内容更新
 */
- (void)reloadData ;


/**
 @Example for copy&paste:
 
 - (void)initView {
 [self addChildViewController:self.pageController];
 [self.view addSubview:self.pageController.view];
 [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
 make.top.leading.bottom.right.mas_equalTo(self.view);
 }];
 }
 - (NSInteger)numberOfPagesInPageController:(CSPageController *)pageController{
 return 2 ;
 }
 - (UIViewController *)pageController:(CSPageController *)pageController viewControllerAtIndex:(NSInteger)index{
 if (index == 0) {
 VoteDetailVC * vc = [VoteDetailVC new];
 return vc ;
 }
 PopularVC * vc = [PopularVC new];
 return vc ;
 }
 - (NSString *)pageController:(CSPageController *)pageController titleForViewControllerAtIndex:(NSInteger)index {
 if (index == 0) {
 return @"最新投票";
 }
 return @"人气选手";
 }
 
 - (CSPageController *)pageController{
 if (!_pageController) {
 _pageController = [CSPageController new];
 _pageController.delegate = self ;
 _pageController.lineWidth = 4 ;
 _pageController.segmentLineColor = GET_COLOR_BY_LONG(0xF6534F);
 _pageController.segmentTextColor = GET_COLOR_BY_LONG(0xF6534F);
 }
 return _pageController ;
 }
 */
@end








