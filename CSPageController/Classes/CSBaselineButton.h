//
//  CSBaselineButton.h
//  LabourService
//
//  Created by 朱来飞 on 2018/1/27.
//  Copyright © 2018年 朱来飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSBaselineButton : UIButton

@property (nonatomic,strong) UIColor *lineColor ;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic ,assign) CGFloat lineHeight ;
@property (nonatomic ,assign) CGFloat bottomLineOffset ;

@property (nonatomic ,assign) BOOL headerTextFlexibleWidth;//显示留白
@end
