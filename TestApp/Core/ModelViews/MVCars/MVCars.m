//
//  MVCars.m
//  TestApp
//
//  Created by Evgeny Kalashnikov on 20.07.16.
//  Copyright © 2016 Evgeny Kalashnikov. All rights reserved.
//

#import "MVCars.h"
#import "VEWeather.h"
#import "MLWeather.h"
#import "MVCarAdd.h"
#import "VECarList.h"

@interface MVCars () <VECarListDataSource,VECarListDelegate> {
    NSMutableArray *cars;
    VECarList *carLisView_;
}

- (IBAction)addCarAction:(UIBarButtonItem *)sender;

@end

@implementation MVCars

- (void)viewDidLoad {
    [super viewDidLoad];
    cars = [NSMutableArray new];

    CGFloat h = (self.view.height - 64)/2;
    
    VEWeather *weatherView = [[NSBundle mainBundle] loadNibNamed:@"VEWeather" owner:self options:nil][0];
    weatherView.frame = CGRectMake(0, 0, self.view.bounds.size.width, h);
    [self.view addSubview:weatherView];
    
//    [[MLWeather shared] getWeather:^(Weather *weather) {
//        weatherView.weather = weather;
//    }];
//    Weather *w = [[Weather alloc] init];
//    w.weaterDescription = @"black";
//    w.temp = @"+5";
//    w.location = @"Kiev";
//    w.imageUrl = @"http://openweathermap.org/img/w/09d.png";
//    weatherView.weather = w;
    
    carLisView_ = [[NSBundle mainBundle] loadNibNamed:@"VECarList" owner:self options:nil][0];
    carLisView_.frame = CGRectMake(0, h, self.view.bounds.size.width, h);
    carLisView_.dataSource = self;
    carLisView_.delegate = self;
    [self.view addSubview:carLisView_];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [cars setArray:[Car MR_findAllSortedBy:@"model" ascending:YES]];
    [carLisView_ reloadData];
}

- (NSInteger)carListCarCount:(VECarList *)carListView {
    return cars.count;
}

- (Car *)carList:(VECarList *)carListView carForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cars[indexPath.row];
}

- (void)carList:(VECarList *)carListView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)carList:(VECarList *)carListView didDeleteRowAtIndexPath:(NSIndexPath *)indexPath {
    Car *delCar = cars[indexPath.row];
    [cars removeObjectAtIndex:indexPath.row];
    [carListView deleteAtIndexPath:indexPath];
    if ([delCar MR_deleteEntity]) {
        MR_SAVE_;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addCarAction:(UIBarButtonItem *)sender {
    MVCarAdd *vc = [[MVCarAdd alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
