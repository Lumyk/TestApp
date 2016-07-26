//
//  MVCarAdd.m
//  TestApp
//
//  Created by Evgeny Kalashnikov on 20.07.16.
//  Copyright © 2016 Evgeny Kalashnikov. All rights reserved.
//

#import "MVCarAdd.h"
#import "VECarAdd.h"
#import <PNImagePickerViewController/PNImagePickerViewController.h>
#import "SBPickerSelector.h"


@interface MVCarAdd () <VECarAddDataSource,VECarAddDelegate,PNImagePickerViewControllerDelegate,SBPickerSelectorDelegate> {
    Car *car;
    VECarAdd *carAddView_;
    BOOL saved;
    NSMutableArray *images;
    NSArray *engines;
    NSArray *transmissions;
    NSArray *conditions;
    SBPickerSelector *picker;
}

@end

@implementation MVCarAdd

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add Car";

    carAddView_ = [[NSBundle mainBundle] loadNibNamed:@"VECarAdd" owner:self options:nil][0];
    carAddView_.frame = self.view.frame;
    carAddView_.dataSource = self;
    carAddView_.delegate = self;
    
    [self.view addSubview:carAddView_];
    
    car = [Car MR_createEntity];
    saved = NO;
    images = [NSMutableArray new];
    
    engines = [Engine MR_findAllSortedBy:@"name" ascending:YES withPredicate:nil];
    transmissions = [Transmission MR_findAllSortedBy:@"name" ascending:YES withPredicate:nil];
    conditions = [Condition MR_findAllSortedBy:@"name" ascending:YES withPredicate:nil];
    
    picker = [SBPickerSelector picker];
    picker.pickerType = SBPickerSelectorTypeText;
    
    picker.delegate = self;
    picker.doneButtonTitle = @"Done";
    picker.cancelButtonTitle = @"Cancel";
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(doneAction)];
    [self.navigationItem setRightBarButtonItem:button];
}

- (void) doneAction {
    
    __weak typeof(self) weakSelf = self;
    

    void(^showAlert)(NSString *) = ^(NSString *message) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Add Car"
                                     message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 __strong typeof(self)self = weakSelf;
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
        __strong typeof(self)self = weakSelf;
        [self presentViewController:alert animated:YES completion:nil];
    };
    
    if (images.count == 0) {
        showAlert(@"You need to add at least one image!");
        return;
    }
    
    if (!car.model) {
        showAlert(@"You need to enter car model");
        return;
    }
    
    if (car.model.length < 2) {
        showAlert(@"Car model mast have more then 2 symbols");
        return;
    }
    
    if (!car.price.integerValue) {
        showAlert(@"You need to enter car price");
        return;
    }
    
    if (!car.engine) {
        showAlert(@"You need to select car engine");
        return;
    }
    
    if (!car.transmission) {
        showAlert(@"You need to select car transmission");
        return;
    }
    
    if (!car.condition) {
        showAlert(@"You need to select car condition");
        return;
    }
    
    if (!car.descript) {
        showAlert(@"You need to enter car description");
        return;
    }
    
    if (car.descript.length < 10) {
        showAlert(@"Car description mast have more then 10 symbols");
        return;
    }
    
    car.images = [NSKeyedArchiver archivedDataWithRootObject:images];
    
    MR_SAVE_;
    saved = YES;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController) {
        if (!saved) {
            [car MR_deleteEntity];
        }
    }
}

- (NSInteger)addCarImageCount:(VECarAdd *)addCarView {
    return images.count;
}

- (UIImage *)addCar:(VECarAdd *)addCarView imageForIndexPath:(NSIndexPath *)indexPath {
    return images[indexPath.row];
}

- (void)addCarAddNewImage:(VECarAdd *)addCarView {
    PNImagePickerViewController *imagePicker = [[PNImagePickerViewController alloc] init];
    imagePicker.delegate = self;
    [imagePicker showImagePickerInController:self animated:YES];
}

- (void) addCar:(VECarAdd *)addCarView carModelDidEntered:(NSString *)model {
    car.model = model;
}

- (void) addCar:(VECarAdd *)addCarView carPriceDidEntered:(NSNumber *)price {
    car.price = price;
}

- (void) addCar:(VECarAdd *)addCarView carDescriptionDidEntered:(NSString *)description {
    car.descript = description;
}

- (void) addCarEngineDidTaped:(VECarAdd *)addCarView {
    picker.pickerData = [[engines valueForKeyPath:@"name"] mutableCopy];
    [picker showPickerOver:self];
    picker.tag = 1;
    [picker.pickerView selectRow:(car.engine)?[engines indexOfObject:car.engine]:0 inComponent:0 animated:NO];
}

- (void) addCarTransmissionDidTaped:(VECarAdd *)addCarView {

    picker.pickerData = [[transmissions valueForKeyPath:@"name"] mutableCopy];
    [picker showPickerOver:self];
    picker.tag = 2;
    [picker.pickerView selectRow:(car.transmission)?[transmissions indexOfObject:car.transmission]:0 inComponent:0 animated:NO];
}

- (void) addCarConditionDidTaped:(VECarAdd *)addCarView {
    picker.pickerData = [[conditions valueForKeyPath:@"name"] mutableCopy];
    [picker showPickerOver:self];
    picker.tag = 3;
    [picker.pickerView selectRow:(car.condition)?[conditions indexOfObject:car.condition]:0 inComponent:0 animated:NO];
}


- (void) pickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx {
    switch (selector.tag) {
        case 1: {
            car.engine = engines[idx];
            [carAddView_ setEngine:value];
            break;
        }
        case 2: {
            car.transmission = transmissions[idx];
            [carAddView_ setTransmission:value];
            break;
        }
        case 3: {
            car.condition = conditions[idx];
            [carAddView_ setCondition:value];
            break;
        }
        default:
            break;
    }
}


#pragma mark - PNImagePickerViewControllerDelegate

- (void)imagePicker:(PNImagePickerViewController *)imagePicker didSelectImage:(UIImage *)image {
    [images addObject:image.copy];
    [carAddView_ reloadImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
