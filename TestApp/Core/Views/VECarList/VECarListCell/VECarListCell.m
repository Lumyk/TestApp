//
//  VECarLIstCell.m
//  TestApp
//
//  Created by Evgeny Kalashnikov on 26.07.16.
//  Copyright © 2016 Evgeny Kalashnikov. All rights reserved.
//

#import "VECarLIstCell.h"

@interface VECarLIstCell ()
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UILabel *carModel;
@property (weak, nonatomic) IBOutlet UILabel *carPrice;

@end

@implementation VECarLIstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCar:(Car *)car {
    _car = car;
    self.carModel.text = car.model;
    self.carPrice.text = [NSString stringWithFormat:@"$%@",car.price];
    self.carImage.image = car.getImage.copy;
    [self setNeedsDisplay];
}

@end
