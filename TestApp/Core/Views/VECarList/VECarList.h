//
//  VECarList.h
//  TestApp
//
//  Created by Evgeny Kalashnikov on 20.07.16.
//  Copyright © 2016 Evgeny Kalashnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VECarList;

@protocol VECarListDataSource <NSObject>
- (NSInteger) carListCarCount:(VECarList *)carListView;
- (Car *) carList:(VECarList *)carListView carForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol VECarListDelegate <NSObject>
@optional
- (void) carList:(VECarList *)carListView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) carList:(VECarList *)carListView didDeleteRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface VECarList : UIView

@property (nonatomic, weak) id<VECarListDataSource> dataSource;
@property (nonatomic, weak) id<VECarListDelegate> delegate;

- (void) reloadData;
- (void) deleteAtIndexPath:(NSIndexPath *)indexPath;

@end
