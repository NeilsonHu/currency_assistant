//
//  FVTableView.h
//  ForVisa
//
//  Created by neilson on 2022-03-28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FVTableView : UITableView

@property (nonatomic, copy) NSDictionary <NSString *, NSArray *> *allCities;

@end

NS_ASSUME_NONNULL_END
