//
//  MVCarDetail.m
//  TestApp
//
//  Created by Evgeny Kalashnikov on 20.07.16.
//  Copyright © 2016 Evgeny Kalashnikov. All rights reserved.
//

#import "MVCarDetail.h"
#import "VECarDetail.h"

@interface MVCarDetail ()

@end

@implementation MVCarDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    VECarDetail *carDetailView = [[NSBundle mainBundle] loadNibNamed:@"VECarDetail" owner:self options:nil][0];
    carDetailView.car = self.car;
    carDetailView.frame = self.view.frame;
    [self.view addSubview:carDetailView];
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

@end
