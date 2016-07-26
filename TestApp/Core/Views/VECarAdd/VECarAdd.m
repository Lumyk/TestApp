//
//  VECarAdd.m
//  TestApp
//
//  Created by Evgeny Kalashnikov on 20.07.16.
//  Copyright © 2016 Evgeny Kalashnikov. All rights reserved.
//

#import "VECarAdd.h"
#import "VEImageCell.h"

@interface VECarAdd () <UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate> {
    id activeField;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *carTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *carModelField;
@property (weak, nonatomic) IBOutlet UILabel *priceTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *carPriceField;
@property (weak, nonatomic) IBOutlet UILabel *engineTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *transmissionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *carEngineLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTransmissionLabel;
@property (weak, nonatomic) IBOutlet UILabel *carConditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *carDascriptionTextView;

- (IBAction)engineAction:(UIButton *)sender;
- (IBAction)transmissionAction:(UIButton *)sender;
- (IBAction)conditionAction:(UIButton *)sender;
@end

@implementation VECarAdd

- (void)drawRect:(CGRect)rect {
    self.carDascriptionTextView.textContainerInset = UIEdgeInsetsMake(-5, 3, 0, 0);
    self.scrollView.contentSize = self.scrollView.frame.size;
    
    self.carDascriptionTextView.height = self.height - self.carDascriptionTextView.y;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    UINib *nib = [UINib nibWithNibName:@"VEImageCell" bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"cell"];
}

- (void)reloadImages {
    [self.collectionView reloadData];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(self)self = weakSelf;
        if (self.collectionView.contentSize.width > self.collectionView.width) {
            CGPoint bottomOffset = CGPointMake(self.collectionView.contentSize.width - self.collectionView.width, 0);
            [self.collectionView setContentOffset:bottomOffset animated:YES];
        }
    });
}

- (void)setEngine:(NSString *)engine {
    self.carEngineLabel.text = engine;
}

- (void) setTransmission:(NSString *)transmission {
    self.carTransmissionLabel.text = transmission;
}

- (void) setCondition:(NSString *)condition {
    self.carConditionLabel.text = condition;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource addCarImageCount:self]+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VEImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSInteger count = [self.dataSource addCarImageCount:self];
    if (indexPath.row < count) {
        cell.image = [self.dataSource addCar:self imageForIndexPath:indexPath];
    } else {
        cell.image = nil;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = [self.dataSource addCarImageCount:self];
    if (indexPath.row < count) {
        if ([self.delegate respondsToSelector:@selector(addCar:imageDidSelectedAtIndexPath:)]) {
            [self.delegate addCar:self imageDidSelectedAtIndexPath:indexPath];
        }
    } else {
        [self.delegate addCarAddNewImage:self];
    }
}

- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        __strong typeof(self)self = weakSelf;
        CGFloat h = self.bounds.size.height - kbSize.height;
        self.scrollView.height = h;
    } completion:^(BOOL finished) {
        __strong typeof(self)self = weakSelf;
        [self.scrollView scrollRectToVisible:[(UIView *)activeField frame] animated:YES];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        __strong typeof(self)self = weakSelf;
        self.scrollView.height = self.scrollView.contentSize.height;
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    activeField = textView;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(addCar:carDescriptionDidEntered:)]) {
        [self.delegate addCar:self carDescriptionDidEntered:textView.text];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.carModelField) {
        if ([self.delegate respondsToSelector:@selector(addCar:carModelDidEntered:)]) {
            [self.delegate addCar:self carModelDidEntered:textField.text];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(addCar:carPriceDidEntered:)]) {
            [self.delegate addCar:self carPriceDidEntered:@(textField.text.doubleValue)];
        }
    }
}

- (IBAction)engineAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addCarEngineDidTaped:)]) {
        [self.delegate addCarEngineDidTaped:self];
    }
}

- (IBAction)transmissionAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addCarTransmissionDidTaped:)]) {
        [self.delegate addCarTransmissionDidTaped:self];
    }
}

- (IBAction)conditionAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addCarConditionDidTaped:)]) {
        [self.delegate addCarConditionDidTaped:self];
    }
}

@end
