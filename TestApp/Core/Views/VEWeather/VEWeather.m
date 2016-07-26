//
//  VEWeather.m
//  TestApp
//
//  Created by Evgeny Kalashnikov on 20.07.16.
//  Copyright © 2016 Evgeny Kalashnikov. All rights reserved.
//

#import "VEWeather.h"

@interface VEWeather () {
    UIColor *textColor;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroungImage;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation VEWeather

- (UIColor *)averageColor:(UIImage *)image {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        unsigned char rgba[4];
        CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        
        CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), image.CGImage);
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
        
        if(rgba[3] > 0) {
            CGFloat alpha = ((CGFloat)rgba[3])/255.0;
            CGFloat multiplier = alpha/255.0;
            return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                                   green:((CGFloat)rgba[1])*multiplier
                                    blue:((CGFloat)rgba[2])*multiplier
                                   alpha:alpha];
        }
        else {
            return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                                   green:((CGFloat)rgba[1])/255.0
                                    blue:((CGFloat)rgba[2])/255.0
                                   alpha:((CGFloat)rgba[3])/255.0];
        }
}

- (void)setWeather:(Weather *)weather {
    if (!textColor) {
        textColor = [UIColor blackColor];
    }
    _weather = weather;
    self.descriptionLabel.text = weather.weaterDescription;
    self.locationLabel.text = weather.location;
    NSMutableAttributedString *temp = [[NSMutableAttributedString alloc] initWithString:weather.temp];
    self.tempLabel.attributedText = temp;
    
    self.descriptionLabel.textColor = textColor;
    self.locationLabel.textColor = textColor;
    self.tempLabel.textColor = textColor;
    
    __weak typeof(self) weakSelf = self;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:weather.imageUrl] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            __strong typeof(self)self = weakSelf;
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = image;
            attachment.bounds = CGRectMake(0, -15, 50, 50);
            NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
            [temp appendAttributedString:attachmentString];
            self.tempLabel.attributedText = temp;
        }
    }];
    
    

    [[MLWeather shared] getImageForWeather:weather block:^(UIImage *image) {
        __strong typeof(self)self = weakSelf;
        self.backgroungImage.image = image;
        
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
        [[self averageColor:image] getRed:&red green:&green blue:&blue alpha:&alpha];
        int threshold = 105;
        int bgDelta = ((red * 0.299) + (green * 0.587) + (blue * 0.114));
        textColor = (255 - bgDelta < threshold) ? [UIColor blackColor] : [UIColor whiteColor];
        
        self.weather = _weather;
    }];
    
    [self.spinner stopAnimating];
}

@end
