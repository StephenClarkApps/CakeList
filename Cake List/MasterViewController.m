//
//  MasterViewController.m
//  Cake List
//
//  Created by Stewart Hart on 19/05/2015.
//  Copyright (c) 2015 Stewart Hart. All rights reserved.
//

#import "MasterViewController.h"
#import "CakeTableViewCell.h"
#import "CLCakesHelper.h"
#import "UINib+CakeList.h"
#import "CLConstants.h"
#import "CLNetworking.h"
#import "CLFunctions.h"
#import "CLCake.h"

@interface MasterViewController ()
@property (strong, nonatomic) NSArray *objects;
@property (strong, nonatomic) CLCakes *cakes;
@property (strong, nonatomic) NSMutableDictionary *imageDict;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    CLNetworking *networking = [[CLNetworking alloc] init];
    [networking getCakesListData:CLCakesUrl withSuccessBlock:^(NSArray *objects) {
        NSLog (@"Success");
        CLCakesHelper *cakesHelper = [[CLCakesHelper alloc] init];
        self.cakes = [cakesHelper makeCakesWhilstTheSunShines:objects];
        [self.tableView reloadData];
    } andFailureBlock:^(NSError *error) {
        NSLog (@"Failure");
    }];
    
    self.imageDict = [[NSMutableDictionary alloc]initWithCapacity:1000];
    
    [self setupRefreshControl];
}

/**
 Initialize the refresh control.
 */
- (void) setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor blueColor];
    self.refreshControl.tintColor = [UIColor yellowColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshTable)
                  forControlEvents:UIControlEventValueChanged];
}


/**
 Cleared all the cached images Then reload the tableview
 */
- (void)refreshTable {
    [self.tableView setUserInteractionEnabled:false];
    [self.imageDict removeAllObjects];
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.tableView setUserInteractionEnabled:true];
        [self.refreshControl endRefreshing];
    });
}

#pragma mark - Table View

/**
 Method to register cells to use in the tableview
 */
- (void)setupTableView {
    [self.tableView registerNib:CakeTableViewCell.nibForClass forCellReuseIdentifier:CakeTableViewCell.nibIdentifier];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cakes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CakeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CakeTableViewCell.nibIdentifier
                                                                                forIndexPath:indexPath];
    
    [cell.spinner startAnimating];
    
    // Set title and description labels
    cell.titleLabel.text = self.cakes[indexPath.row].title;
    cell.descriptionLabel.text = self.cakes[indexPath.row].descript;
    
    
    if ([self.imageDict objectForKey:self.cakes[indexPath.row].image]) {
        cell.cakeImageView.alpha = 0.0;
        NSString *lookup = self.cakes[indexPath.row].image;
        cell.cakeImageView.image = [self.imageDict objectForKey:lookup];
        
        // The image for this row has been previously cached
        [UIView animateWithDuration:0.5f animations:^{
            cell.cakeImageView.alpha = 1.0;
        } completion:^(BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.spinner stopAnimating];
            });
        }];
        
    } else {
        CLNetworking *networking = [[CLNetworking alloc] init];
        
        __weak __typeof__(self) weakSelf = self;

        // set the completion handler block
        [networking setCompletionHandler:^(NSError *error, NSData *data) {
            if (data) {
                UIImage *image = [UIImage imageWithData: data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CakeTableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                        if (updateCell) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                updateCell.cakeImageView.alpha = 0.0;
                                updateCell.cakeImageView.image = image;
                                
                                // Animating the image in gives a nicer look
                                [UIView animateWithDuration:1.0f
                                                      delay:0.0f
                                                    options:UIViewAnimationOptionCurveEaseIn
                                                 animations:^{
                                                     updateCell.cakeImageView.alpha = 1.0;
                                                 }
                                                 completion:^(BOOL finished) {
                                                     [updateCell.spinner stopAnimating];
                                                 }];
                            
                                [weakSelf.imageDict setValue:image forKey: self.cakes[indexPath.row].image];
                            });
                        }
                    });
                } else {
                    //No Image
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [cell.spinner stopAnimating];
                        [self.imageDict setValue:[UIImage imageNamed:@"placeholder"] forKey: self.cakes[indexPath.row].image];
                    });
                }
            } else {
                // No Data
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.spinner stopAnimating];
                    [self.imageDict setValue:[UIImage imageNamed:@"placeholder"] forKey: self.cakes[indexPath.row].image];
                });
            }
        }];
        [networking getDataFromURL:self.cakes[indexPath.row].image];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
