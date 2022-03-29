//
//  ViewController.m
//  ForVisa
//
//  Created by neilson on 2022-03-28.
//

#import "ViewController.h"
#import "FVMainRequestManager.h"
#import "FVTableView.h"

@interface ViewController ()

@property (nonatomic, strong) FVMainRequestManager *requestManager;

@property (nonatomic, strong) UIActivityIndicatorView *loading;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) FVTableView *tableView;

@end

@implementation ViewController

#pragma mark - override lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupUI];
    [self _startLoad];
}

#pragma mark - private methods

- (void)_setupUI {
    self.view.backgroundColor = UIColor.whiteColor;

    self.tableView = ({
        FVTableView *tableView = [[FVTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.view addSubview:tableView];
        tableView;
    });
    
    self.loading = ({
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        view.center = self.view.center;
        view.hidesWhenStopped = YES;
        [self.tableView addSubview:view];
        view;
    });
    
    self.label = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"加载中...";
        [label sizeToFit];
        label.center = CGPointMake(self.loading.center.x, self.loading.center.y + 30);
        [self.tableView addSubview:label];
        label;
    });
}

- (void)_startLoad {
    [self.loading startAnimating];
    self.label.hidden = NO;

    self.requestManager = [FVMainRequestManager new];
    [self.requestManager startDataRequest:^(NSDictionary * _Nonnull result) {
        [self.loading stopAnimating];
        self.label.hidden = YES;
        self.tableView.allCities = result;
        [self.tableView reloadData];
    }];
}

@end
