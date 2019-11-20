//
//  UIViewController+identifier.m
//  RACTest
//
//  Created by Lifee on 2019/11/19.
//  Copyright © 2019 Lifee. All rights reserved.
//

#import "UIViewController+Identifier.h"
#import <objc/runtime.h>

static NSString * const reuseIdentifierKey = @"reuseIdentifierKey";
@implementation UIViewController (Identifier)


- (void)setReuseIdentifier:(NSString *)reuseIdentifier {
    objc_setAssociatedObject(self, &reuseIdentifierKey, reuseIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)reuseIdentifier {
    return objc_getAssociatedObject(self, &reuseIdentifierKey);
}
@end
