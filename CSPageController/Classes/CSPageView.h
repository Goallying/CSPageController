//
//  CSPageView.h
//  RACTest
//
//  Created by Lifee on 2019/11/20.
//  Copyright © 2019 Lifee. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CSPageView ;

@protocol CSPageViewDelegate<NSObject>

@required
- (NSInteger)numberOfPagesInPageView:(CSPageView *)pageView;
- (UIViewController *)pageView:(CSPageView *)pageView viewControllerAtIndex:(NSInteger)index;

@optional
- (void)pageViewDidScrollToViewControllerAtIndex:(NSInteger)index ;

@end



@interface CSPageView : UIScrollView

@property (nonatomic ,weak) id <CSPageViewDelegate> dataSource ;
- (void)registeViewControllerClass:(Class)cls forReuseIdentifier:(NSString * )identifier ;
- (__kindof UIViewController *)dequeueReusableViewControllerWithIdentifier:(NSString *)identifier ;
- (void)scrollToViewControllerAtIndex:(NSInteger)index ;
- (void)reloadData ;
@end

