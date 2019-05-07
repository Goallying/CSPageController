//
//  CSBaselineButton.h
//  LabourService
//
//  Created by 朱来飞 on 2018/1/27.
//  Copyright © 2018年 朱来飞. All rights reserved.
//

#import "CSButton.h"

@interface CSBaselineButton : CSButton
@property (nonatomic,strong) UIColor *lineColor ;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic ,assign) CGFloat lineWidth ;
@property (nonatomic ,assign) CGFloat bottomLineOffset ;
@end
