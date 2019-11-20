//
//  CSViewController.m
//  CSPageController
//
//  Created by szzhongyu2018@163.com on 05/07/2019.
//  Copyright (c) 2019 szzhongyu2018@163.com. All rights reserved.
//

#import "CSViewController.h"
#import "CSPageController.h"
#import <Masonry/Masonry.h>

#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"

@interface CSViewController ()<CSPageControllerDelegate ,CSPageControllerDataSource>

@property (nonatomic ,strong) CSPageController * pageController ;

@property (nonatomic ,strong) NSArray * titArr ;
@end

@implementation CSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.pageController registeViewControllerClass:[ViewController1 class] forReuseIdentifier:@"VC1"];
      [self.pageController registeViewControllerClass:[ViewController2 class] forReuseIdentifier:@"VC2"];
      [self.pageController registeViewControllerClass:[ViewController3 class] forReuseIdentifier:@"VC3"];

      self.titArr = @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价",@"退款售后" ,@"11111111111111" ,@"22222222222",@"3",@"GlobalTools"];
      [self.view addSubview:self.pageController];
      [self.pageController mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.leading.mas_equalTo(self.view);
          make.size.mas_equalTo(self.view.bounds.size);
      }];
}

- (NSInteger)numberOfPagesInPageController:(CSPageController *)pageController{
    return self.titArr.count;
}
- (NSString *)pageController:(CSPageController *)pageController titleForViewControllerAtIndex:(NSInteger)index {
    NSString* title = self.titArr[index];
    return title;
}
- (UIViewController *)pageController:(CSPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        ViewController1 * vc = [pageController dequeueReusableViewControllerWithIdentifier:@"VC1"];
        return vc ;
    }
    if (index == 5) {
        ViewController3 * vc = [pageController dequeueReusableViewControllerWithIdentifier:@"VC3"];
        return vc ;
    }
    ViewController2 * vc1 = [pageController dequeueReusableViewControllerWithIdentifier:@"VC2"];
    return vc1 ;
}
- (CSPageController *)pageController {
    if (!_pageController) {
        _pageController = [[CSPageController alloc] init];
        _pageController.dataSource = self ;
        _pageController.delegate = self ;
        _pageController.headerScrollable = YES ;
        _pageController.selectedIndex = 7 ;
        _pageController.horizontalSpacing = 10 ;
    }
    return _pageController ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
