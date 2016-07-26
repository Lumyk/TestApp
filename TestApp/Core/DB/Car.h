//
//  Car.h
//  
//
//  Created by Evgeny Kalashnikov on 26.07.16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Condition, Engine;

NS_ASSUME_NONNULL_BEGIN

@interface Car : NSManagedObject

- (NSArray *) getImages;
- (UIImage *) getImage;

@end

NS_ASSUME_NONNULL_END

#import "Car+CoreDataProperties.h"
