//
//  Car.m
//  
//
//  Created by Evgeny Kalashnikov on 26.07.16.
//
//

#import "Car.h"
#import "Condition.h"
#import "Engine.h"

@implementation Car

- (NSArray *) getImages {
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.images];
}

- (UIImage *) getImage {
    @autoreleasepool {
        return [[self getImages] firstObject];
    }
}

@end
