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

@interface MVCars ()

- (IBAction)addCarAction:(UIBarButtonItem *)sender;

@end

@implementation MVCars

- (void)viewDidLoad {
    [super viewDidLoad];

    VEWeather *weatherView = [[NSBundle mainBundle] loadNibNamed:@"VEWeather" owner:self options:nil][0];
    weatherView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
    [self.view addSubview:weatherView];
    
    [[MLWeather shared] getWeather:^(Weather *weather) {
        weatherView.weather = weather;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
