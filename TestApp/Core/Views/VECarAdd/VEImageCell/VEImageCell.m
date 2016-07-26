//
//  VEImageCell.m
//  TestApp
//
//  Created by Evgeny Kalashnikov on 26.07.16.
//  Copyright © 2016 Evgeny Kalashnikov. All rights reserved.
//

#import "VEImageCell.h"

@interface VEImageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation VEImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
    
    [self setNeedsDisplay];
}

@end
