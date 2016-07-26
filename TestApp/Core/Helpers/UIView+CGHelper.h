//
//  UIView+CGHelper.h
//  Boligappen
//
//  Created by Andrey Ivanov on 23.10.12.
//  Copyright (c) 2012 Mobidev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CGHelper)

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

-(void)addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii;
-(CALayer*)maskForRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii;


@end
