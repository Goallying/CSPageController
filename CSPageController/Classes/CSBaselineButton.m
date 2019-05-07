//
//  CSBaselineButton.m
//  LabourService
//
//  Created by 朱来飞 on 2018/1/27.
//  Copyright © 2018年 朱来飞. All rights reserved.
//

#import "CSBaselineButton.h"


@implementation CSBaselineButton

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.selected) {
        CGFloat lineWidth = 2.0;
        if (self.lineWidth>0) {
            lineWidth = self.lineWidth ;
        }
        CGColorRef color = [UIColor whiteColor].CGColor;
        if (self.lineColor) {
            color = self.lineColor.CGColor ;
        }
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(ctx, color);
        CGContextSetLineWidth(ctx, lineWidth);
        CGContextMoveToPoint(ctx, 0, self.height - lineWidth - self.bottomLineOffset);
        CGContextAddLineToPoint(ctx, self.width, self.height - lineWidth - self. bottomLineOffset);
        CGContextStrokePath(ctx);
    }
}

@end
