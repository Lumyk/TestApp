//
//  VECarList.m
//  TestApp
//
//  Created by Evgeny Kalashnikov on 20.07.16.
//  Copyright © 2016 Evgeny Kalashnikov. All rights reserved.
//

#import "VECarList.h"
#import "VECarListCell.h"

@interface VECarList () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation VECarList

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void) reloadData {
    [self.tableView reloadData];
}

- (void) deleteAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource carListCarCount:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VECarListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"VECarListCell" owner:self options:nil][0];
    }

    cell.car = [self.dataSource carList:self carForRowAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carList:didSelectRowAtIndexPath:)]) {
        [self.delegate carList:self didSelectRowAtIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.delegate respondsToSelector:@selector(carList:didDeleteRowAtIndexPath:)]) {
            [self.delegate carList:self didDeleteRowAtIndexPath:indexPath];
        }
    }
}

@end
