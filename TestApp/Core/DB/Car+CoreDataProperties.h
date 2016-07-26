//
//  Car+CoreDataProperties.h
//  
//
//  Created by Evgeny Kalashnikov on 26.07.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Car.h"

NS_ASSUME_NONNULL_BEGIN

@interface Car (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *model;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSString *descript;
@property (nullable, nonatomic, retain) NSData *images;
@property (nullable, nonatomic, retain) Engine *engine;
@property (nullable, nonatomic, retain) Condition *condition;
@property (nullable, nonatomic, retain) NSManagedObject *transmission;

@end

NS_ASSUME_NONNULL_END
