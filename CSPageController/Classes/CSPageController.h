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

@optional
- (NSString *)pageController:(CSPageController *)pageController titleForViewControllerAtIndex:(NSInteger)index ;
@end

@protocol CSPageControllerDataSource <NSObject>

@required
- (NSInteger)numberOfPagesInPageController:(CSPageController *)pageController;
- (UIViewController *)pageController:(CSPageController *)pageController viewControllerAtIndex:(NSInteger)index;
@end

@interface CSPageController:UIView

@property (nonatomic ,assign) NSInteger selectedIndex ;

@property (nonatomic ,strong) UIColor * normalTextColor ;
@property (nonatomic ,strong) UIColor * selectTextColor ;

@property (nonatomic ,strong) UIColor * segmentLineColor ;
@property (nonatomic ,assign) CGFloat segmentLineHeight ;

@property (nonatomic ,assign) BOOL headerScrollable ;
@property (nonatomic ,assign) CGFloat horizontalSpacing ;

@property (nonatomic ,weak) id <CSPageControllerDataSource> dataSource ;
@property (nonatomic ,weak) id <CSPageControllerDelegate> delegate ;

- (void)registeViewControllerClass:(Class)cls forReuseIdentifier:(NSString * )identifier ;
- (__kindof UIViewController *)dequeueReusableViewControllerWithIdentifier:(NSString *)identifier ;
- (void)reloadData ;
@end








