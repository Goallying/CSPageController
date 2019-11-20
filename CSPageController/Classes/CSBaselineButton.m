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
        CGFloat lineHeight = 2.0;
        if (self.lineHeight>0) {
            lineHeight = self.lineHeight ;
        }
        CGColorRef color = [UIColor whiteColor].CGColor;
        if (self.lineColor) {
            color = self.lineColor.CGColor ;
        }
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(ctx, color);
        CGContextSetLineWidth(ctx, lineHeight);
        if (self.headerTextFlexibleWidth) {
            CGFloat sizeWidth = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 40)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                  context:nil].size.width;
            
            CGContextMoveToPoint(ctx, (self.frame.size.width - sizeWidth)*0.5, self.frame.size.height - lineHeight - self.bottomLineOffset);
            CGContextAddLineToPoint(ctx, self.frame.size.width - (self.frame.size.width - sizeWidth)*0.5, self.frame.size.height - lineHeight - self. bottomLineOffset);
        }else{
            CGContextMoveToPoint(ctx, 0, self.frame.size.height - lineHeight - self.bottomLineOffset);
            CGContextAddLineToPoint(ctx, self.frame.size.width, self.frame.size.height - lineHeight - self. bottomLineOffset);
        }
        CGContextStrokePath(ctx);
    }
}

@end
