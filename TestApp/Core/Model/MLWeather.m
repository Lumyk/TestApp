//
//  MLWeather.m
//  TestApp
//
//  Created by Evgeny Kalashnikov on 20.07.16.
//  Copyright © 2016 Evgeny Kalashnikov. All rights reserved.
//

#import "MLWeather.h"
#import <CoreLocation/CoreLocation.h>
#import "AFWeather.h"
#import "AFNetworking.h"

@implementation Weather
@end

@interface MLWeather() <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    void (^weatherBlock)(Weather *);
}

@end

@implementation MLWeather

static MLWeather *weather = nil;

+ (instancetype) shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weather = [[[self class] alloc] initPrivate];
    });
    return weather;
}

- (instancetype)init
{
    NSAssert(true, @"You can,t init, use + (void)shared");
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
        [[AFWeather sharedClient] configureClientWithService:AFWeatherAPIOpenWeatherMap withAPIKey:@"f1ef148234079181583dec138aa15016"];

    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [[AFWeather sharedClient] fetchForecastOfLocationWithLatitude:@(newLocation.coordinate.latitude).stringValue andLogitude:@(newLocation.coordinate.longitude).stringValue andCompletionBlock:^(NSDictionary *response, NSError *error) {
        if (!error) {
            if (weatherBlock) {
                double tempFloat = ([response[@"main"][@"temp"] floatValue] - 273.15);
                NSString *temp = [NSString stringWithFormat:tempFloat>0?@"+%.1f°":@"%.1f°",tempFloat];
                
                NSString *imageUrl = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",[response[@"weather"] firstObject][@"icon"]];
                
                Weather *weather = [[Weather alloc] init];
                weather.weaterDescription = [[response[@"weather"] firstObject][@"description"] capitalizedString];
                weather.location = [response[@"name"] capitalizedString];
                weather.temp = temp;
                weather.imageUrl = imageUrl;
                
                weatherBlock(weather);
            }
        }
    }];
}

- (void) getWeather:(void (^)(Weather *weather))block {
    weatherBlock = [block copy];
}

- (AFHTTPRequestOperationManager *) getImageFromGoogle:(NSString *)req result:(void (^)(id result,NSError *error,AFHTTPRequestOperation *operation))block {
    
    AFHTTPRequestOperationManager *requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.googleapis.com/customsearch/v1"]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [requestManager GET:@"" parameters:@{@"q" : @"few clouds wallpaper", @"searchType" : @"image", @"imgsz" : @"medium", @"imgType" : @"photo", @"key" : @"AIzaSyBctwPvCTIpdxDhS0JPEAK1_z5c_FPB9MU", @"cx" : @"016511368400245683819:fd1tbyrne_0"} success:^(AFHTTPRequestOperation *operation, id responseObject) { //small|medium|large
        if (block) {
            block(responseObject,nil,operation);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            NSDictionary *result = nil;
            id errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            if (errorData) {
                if ([errorData isKindOfClass:[NSData class]]) {
                    result = [NSJSONSerialization JSONObjectWithData:errorData options:0 error:nil];
                    NSLog(@"GET %@\n%@",requestManager.baseURL,result);
                }
            }
            block(result,error,operation);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    return requestManager;
}

- (void) getImageForWeather:(Weather *)weather block:(void (^)(UIImage *image))block {
    [self getImageFromGoogle:weather.weaterDescription result:^(id result, NSError *error, AFHTTPRequestOperation *operation) {
        
        NSArray *images = [result valueForKeyPath:@"items.link"];
        NSString *imageUrl = nil;
        
        for (NSString *img in images) {
            if (![img isKindOfClass:[NSNull class]]) {
                imageUrl = img;
                break;
            }
        }
        if (imageUrl) {
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image) {
                    block(image);
                }
            }];
        }
        
    }];
}

@end
