//
//  MyTableView.m
//  MyTableView_testing
//
//  Created by 万存 on 16/4/1.
//  Copyright © 2016年 WanCun. All rights reserved.
//

#import "CSPageView.h"
#import "UIViewController+Identifier.h"

@interface CSPageView()<UIScrollViewDelegate>

@property (nonatomic ,strong) NSMutableArray * visibleCells;
@property (nonatomic ,strong) NSMutableSet   * reusedCells ;
@property (nonatomic ,strong) NSMutableArray * indexPathForVisibleCells ;
@property (nonatomic ,assign) NSInteger  numsOfRows ;
@property (nonatomic ,strong) NSMutableDictionary * registrationDictionary ;

@end

@implementation CSPageView

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
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO ;
    self.pagingEnabled  = YES ;
    self.delegate = self ;
}
- (void)reloadData {
    
    [self.visibleCells removeAllObjects] ;
    [self.indexPathForVisibleCells removeAllObjects] ;
    
    if ([self.dataSource respondsToSelector:@selector(numberOfPagesInPageView:)]) {
        _numsOfRows = [self.dataSource numberOfPagesInPageView:self] ;
    }
    CGRect  cellFrame = CGRectZero ;
    CGFloat cellX  = 0 ;
    CGFloat cellW  = self.bounds.size.width;
    CGFloat totalW = 0 ;
    
    for (int i = 0 ; i <_numsOfRows ; i++) {
      
        //cells
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        cellX = i * cellW ;
        cellFrame = CGRectMake(cellX, 0, cellW, self.bounds.size.height) ;
        
        if ([self isCellInScreen:cellFrame] == YES) {
            UIViewController * cell = [self.dataSource pageView:self viewControllerAtIndex:i] ;
            cell.view.frame = cellFrame ;
            
            [self insertSubview:cell.view atIndex:0] ;
            
            [self.visibleCells addObject:cell] ;
            [self.indexPathForVisibleCells addObject:indexPath] ;
        }
        totalW = cellX + cellW ;
    }
    self.contentSize = CGSizeMake(totalW, self.bounds.size.height) ;
//    NSLog(@"visible === %@ \n reuse === %@" ,self.visibleCells ,self.reusedCells);
}
- (void)layoutSubviews {
    
    [super layoutSubviews] ;
    if (CGSizeEqualToSize(self.contentSize, CGSizeZero)) {
        [self reloadData];
    }
    CGFloat scrollOffset = self.contentOffset.x ;
    
    UIViewController * firstCell = nil     ;
    UIViewController * lastCell  = nil ;
    if (self.visibleCells.count>0) {
        firstCell = self.visibleCells[0] ;
        lastCell  = self.visibleCells.lastObject ;
    }
    CGFloat firstCellX = firstCell.view.frame.origin.x ;
    
    CGFloat cellH = self.bounds.size.height ;
    CGFloat cellW = firstCell.view.frame.size.width ;
    CGFloat cellY = 0 ;
    
    //向右
    if (firstCellX < scrollOffset) {
//        NSIndexPath * visibleLastIndexPath = [self.indexPathForVisibleCells lastObject] ;
//        if (visibleLastIndexPath.row == _numsOfRows - 1) {
//            return ;
//        }
        if (scrollOffset + self.bounds.size.width > self.contentSize.width) {
            return ;
        }
        if ([self isCellInScreen:firstCell.view.frame] ==  NO) {
            
            [self.visibleCells removeObject:firstCell] ;
            if (self.indexPathForVisibleCells.count > 0) {
                [self.indexPathForVisibleCells removeObjectAtIndex:0] ;
            }
            if (firstCell) {
                [self.reusedCells addObject:firstCell] ;
            }
            [firstCell.view removeFromSuperview] ;
        }
        NSIndexPath  * lastIndexPath = [self.indexPathForVisibleCells lastObject] ;
        
        if (!lastIndexPath) {
            //有跳转操作
            NSInteger index = scrollOffset / self.bounds.size.width ;
            lastIndexPath = [NSIndexPath indexPathForRow:index inSection:0] ;
            UIViewController * cell = [self.dataSource pageView:self viewControllerAtIndex:index] ;
            cell.view.frame = CGRectMake(index * self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height) ;
            [self insertSubview:cell.view atIndex:0] ;

            [self.visibleCells addObject:cell] ;
            [self.indexPathForVisibleCells addObject:lastIndexPath] ;
        }
        
        NSIndexPath * nextIndexPath = [NSIndexPath indexPathForRow:lastIndexPath.row +1 inSection:0] ;
        CGRect nextCellFrame = CGRectMake(nextIndexPath.row * self.bounds.size.width, cellY, cellW, cellH) ;
        
        if ([self isCellInScreen:nextCellFrame] == YES ) {
            UIViewController * nextCell = [self.dataSource pageView:self viewControllerAtIndex:nextIndexPath.row] ;
            nextCell.view.frame = nextCellFrame ;
            
            [self insertSubview:nextCell.view atIndex:0] ;
            [self.visibleCells addObject:nextCell] ;
            [self.indexPathForVisibleCells addObject:nextIndexPath] ;
        }
    }
    //向左
    else {
        NSIndexPath * visibleFirstIndexPath = nil ;
        if (self.indexPathForVisibleCells.count>0) {
            visibleFirstIndexPath  = self.indexPathForVisibleCells.firstObject;
        }
        if (visibleFirstIndexPath.row == 0) {
            return ;
        }
        if ([self isCellInScreen:lastCell.view.frame] == NO  ) {
            [self.visibleCells removeObject:lastCell] ;
            [self.indexPathForVisibleCells removeLastObject] ;
            
            [self.reusedCells addObject:lastCell] ;
            [lastCell.view removeFromSuperview] ;
        }
        NSIndexPath * indexPath = self.indexPathForVisibleCells.firstObject;
        if (!indexPath) {
           //有跳转操作
           NSInteger index = scrollOffset / self.bounds.size.width ;
           indexPath = [NSIndexPath indexPathForRow:index inSection:0] ;
           UIViewController * cell = [self.dataSource pageView:self viewControllerAtIndex:index] ;
           cell.view.frame = CGRectMake(index * self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height) ;
           [self insertSubview:cell.view atIndex:0] ;

           [self.visibleCells addObject:cell] ;
           [self.indexPathForVisibleCells addObject:indexPath] ;
        }
        NSIndexPath * foreIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0] ;
        CGRect preCellFrame = CGRectMake(foreIndexPath.row * self.bounds.size.width, cellY, cellW, cellH) ;
        if ([self isCellInScreen:preCellFrame] == YES) {
            UIViewController * cell = [self.dataSource pageView:self viewControllerAtIndex:foreIndexPath.row] ;
            cell.view.frame = preCellFrame;
            [self insertSubview:cell.view atIndex:0] ;
            [self.visibleCells insertObject:cell atIndex:0] ;
            [self.indexPathForVisibleCells insertObject:foreIndexPath atIndex:0] ;
        }
    }
//    NSLog(@"visible === %@ \n reuse === %@" ,self.visibleCells ,self.reusedCells);
}
- (void)scrollToViewControllerAtIndex:(NSInteger)index {
    [self setContentOffset:CGPointMake(index * self.bounds.size.width, 0) animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.dragging) {
        [self.dataSource pageViewDidScrollToViewControllerAtIndex:scrollView.contentOffset.x / self.bounds.size.width];
    }

}
- (BOOL)isCellInScreen:(CGRect)cellFrame {
    CGFloat offsetX = self.contentOffset.x;
    return CGRectGetMaxX(cellFrame) > offsetX && cellFrame.origin.x < (self.bounds.size.width + offsetX);
}
- (void)registeViewControllerClass:(Class)cls forReuseIdentifier:(NSString *)identifier {
    [self.registrationDictionary setObject:cls forKey:identifier];
}
- (UIViewController *)dequeueReusableViewControllerWithIdentifier:(NSString *)identifier{
    NSMutableArray * temporaryContainar = self.reusedCells.mutableCopy ;
    for (UIViewController * vc in temporaryContainar) {
        if ([vc.reuseIdentifier isEqualToString:identifier]) {
            [self.reusedCells removeObject:vc] ;
            return vc ;
        }
    }
    Class cls = self.registrationDictionary[identifier];
    UIViewController * vc = [cls new];
    vc.reuseIdentifier = identifier ;
    return vc ;
}
- (NSMutableDictionary *)registrationDictionary {
    if (!_registrationDictionary) {
        _registrationDictionary = [NSMutableDictionary dictionary];
    }
    return _registrationDictionary ;
}
- (NSMutableArray *)visibleCells {
    if (!_visibleCells) {
        _visibleCells = [NSMutableArray array] ;
    }
    return _visibleCells ;
}
- (NSMutableSet *)reusedCells {
    if (!_reusedCells) {
        _reusedCells  = [NSMutableSet set] ;
    }
    return _reusedCells ;
}
- (NSMutableArray *)indexPathForVisibleCells {
    if (!_indexPathForVisibleCells) {
        _indexPathForVisibleCells = [NSMutableArray array] ;
    }
    return _indexPathForVisibleCells ;
}

@end
