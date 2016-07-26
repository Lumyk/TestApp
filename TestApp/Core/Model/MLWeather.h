//
//  MLWeather.h
//  TestApp
//
//  Created by Evgeny Kalashnikov on 20.07.16.
//  Copyright © 2016 Evgeny Kalashnikov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject
@property (nonatomic, strong) NSString *weaterDescription;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *temp;
@property (nonatomic, strong) NSString *imageUrl;

@end

@interface MLWeather : NSObject

+ (instancetype) shared;
- (void) getWeather:(void (^)(Weather *weather))block;
- (void) getImageForWeather:(Weather *)weather block:(void (^)(UIImage *image))block;

@end
