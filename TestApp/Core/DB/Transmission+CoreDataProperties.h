//
//  Transmission+CoreDataProperties.h
//  
//
//  Created by Evgeny Kalashnikov on 26.07.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Transmission.h"

NS_ASSUME_NONNULL_BEGIN

@interface Transmission (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END