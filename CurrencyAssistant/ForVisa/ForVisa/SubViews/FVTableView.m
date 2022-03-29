//
//  FVTableView.m
//  ForVisa
//
//  Created by neilson on 2022-03-28.
//

#import "FVTableView.h"

@interface FVTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *keys;

@end

@implementation FVTableView

#pragma mark - override lifecycle

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
        [self registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:@"header"];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)setAllCities:(NSDictionary<NSString *,NSArray *> *)allCities {
    _allCities = allCities.copy;
    self.keys = _allCities.allKeys.copy;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.keys.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = (NSString *)self.keys[section];
    return MAX(self.allCities[key].count, 1);
}

- (CGFloat)sectionHeaderHeight {
    return 44.f;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"cell"];
    }
    cell.textLabel.textColor = UIColor.blackColor;

    NSString *key = (NSString *)self.keys[indexPath.section];
    NSArray *dates = self.allCities[key];
    if (dates.count == 0) {
        cell.textLabel.text = @"none";
    } else {
        NSDictionary *date = dates[indexPath.row];
        cell.textLabel.text = date[@"date"];
        if ([cell.textLabel.text hasPrefix:@"2022"]) {
            cell.textLabel.textColor = UIColor.redColor;
        }
    }
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = (NSString *)self.keys[section];
    return key;
}

@end

