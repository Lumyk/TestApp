//
//  VECarDetail.m
//  TestApp
//
//  Created by Evgeny Kalashnikov on 20.07.16.
//  Copyright © 2016 Evgeny Kalashnikov. All rights reserved.
//

#import "VECarDetail.h"
#import "VEImageCell.h"

@interface VECarDetail () <UICollectionViewDelegate,UICollectionViewDataSource> {
    NSArray *images;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *carTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *carModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *carPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *engineTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *transmissionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *carEngineLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTransmissionLabel;
@property (weak, nonatomic) IBOutlet UILabel *carConditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *carDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;

@end

@implementation VECarDetail

- (void)drawRect:(CGRect)rect {
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    UINib *nib = [UINib nibWithNibName:@"VEImageCell" bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"cell"];
}

- (void)setCar:(Car *)car {
    _car = car;
    self.carModelLabel.text = car.model;
    self.carPriceLabel.text = [NSString stringWithFormat:@"$%@",car.price];
    self.carEngineLabel.text = car.engine.name;
    self.carTransmissionLabel.text = car.transmission.name;
    self.carConditionLabel.text = car.condition.name;
    self.carDescriptionTextView.text = car.descript;
    images = car.getImages;
    self.pageControll.numberOfPages = images.count;
    
    [self.collectionView reloadData];
    [self setNeedsDisplay];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VEImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.image = images[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.width, collectionView.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPage = lround((float)scrollView.contentOffset.x / scrollView.width);
    self.pageControll.currentPage = currentPage;
}

@end
