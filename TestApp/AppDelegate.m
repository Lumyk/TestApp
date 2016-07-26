//
//  AppDelegate.m
//  TestApp
//
//  Created by Evgeny Kalashnikov on 20.07.16.
//  Copyright © 2016 Evgeny Kalashnikov. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Model.xcdatamodeld"];
    
    [self setUpData];
    return YES;
}

- (void) setUpData {
    if ([Engine MR_countOfEntities] == 0) {
        for (NSString *value in @[@"1.0",@"1.2",@"1.4",@"1.6",@"1.8",@"2.0"]) {
            Engine *engine = [Engine MR_createEntity];
            engine.name = value;
        }
        MR_SAVE_;
    }
    if ([Transmission MR_countOfEntities] == 0) {
        for (NSString *value in @[@"Ручная",@"Автомат",@"Полуавтомат"]) {
            Transmission *transmission = [Transmission MR_createEntity];
            transmission.name = value;
        }
        MR_SAVE_;
    }
    
    if ([Condition MR_countOfEntities] == 0) {
        for (NSString *value in @[@"Плохое",@"Нормальное",@"Хорошее"]) {
            Condition *condition = [Condition MR_createEntity];
            condition.name = value;
        }
        MR_SAVE_;
    }
        
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
