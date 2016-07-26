//
//  VECarLIstCell.m
//  TestApp
//
//  Created by Evgeny Kalashnikov on 26.07.16.
//  Copyright © 2016 Evgeny Kalashnikov. All rights reserved.
//

#import "VECarListCell.h"

@interface VECarListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UILabel *carModel;
@property (weak, nonatomic) IBOutlet UILabel *carPrice;

@end

@implementation VECarListCell

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
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        UIImage *image = car.getImage;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self)self = weakSelf;
            self.carImage.image = image;
        });
    });
    
    [self setNeedsDisplay];
}

@end
