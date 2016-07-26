//
//  VECarAdd.h
//  TestApp
//
//  Created by Evgeny Kalashnikov on 20.07.16.
//  Copyright © 2016 Evgeny Kalashnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VECarAdd;

@protocol VECarAddDataSource <NSObject>
- (NSInteger) addCarImageCount:(VECarAdd *)addCarView;
- (UIImage *) addCar:(VECarAdd *)addCarView imageForIndexPath:(NSIndexPath *)indexPath;
@end

@protocol VECarAddDelegate <NSObject>
- (void) addCarAddNewImage:(VECarAdd *)addCarView;
@optional
- (void) addCar:(VECarAdd *)addCarView imageDidSelectedAtIndexPath:(NSIndexPath *)indexPath;
- (void) addCar:(VECarAdd *)addCarView carModelDidEntered:(NSString *)model;
- (void) addCar:(VECarAdd *)addCarView carPriceDidEntered:(NSNumber *)price;
- (void) addCar:(VECarAdd *)addCarView carDescriptionDidEntered:(NSString *)description;
- (void) addCarEngineDidTaped:(VECarAdd *)addCarView;
- (void) addCarTransmissionDidTaped:(VECarAdd *)addCarView;
- (void) addCarConditionDidTaped:(VECarAdd *)addCarView;

@end

@interface VECarAdd : UIView
@property (nonatomic, weak) id<VECarAddDataSource> dataSource;
@property (nonatomic, weak) id<VECarAddDelegate> delegate;

- (void) reloadImages;
- (void) setEngine:(NSString *)engine;
- (void) setTransmission:(NSString *)transmission;
- (void) setCondition:(NSString *)condition;
@end
