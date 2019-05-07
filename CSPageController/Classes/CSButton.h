//
//  CSButton.h
//  JT
//
//  Created by 朱来飞 on 2018/2/26.
//  Copyright © 2018年 zhulaifei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , ImagePosition) {
    P_Top  = 1,
    P_Left ,
    P_Bottom,
    P_Right
};
@interface CSButton : UIButton
@property (nonatomic ,assign)ImagePosition imgPt ;
@property (nonatomic , assign) BOOL imageRoundRect;
@property (nonatomic , assign) CGFloat orignImageWidth;
@property (nonatomic , assign) CGFloat orignImageHeight;
@property (nonatomic , assign) BOOL hasOrign;
@end

