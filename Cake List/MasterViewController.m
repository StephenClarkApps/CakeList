//
//  MasterViewController.m
//  Cake List
//
//  Created by Stewart Hart on 19/05/2015.
//  Copyright (c) 2015 Stewart Hart. All rights reserved.
//

#import "MasterViewController.h"
//#import "CakeCell.h"
#import "CakeTableViewCell.h"
#import "UINib+CakeList.h"

@interface MasterViewController ()
@property (strong, nonatomic) NSArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self getData];
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
    return self.objects.count;
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
    
    NSDictionary *object = self.objects[indexPath.row];
    cell.titleLabel.text = object[@"title"];
    cell.descriptionLabel.text = object[@"desc"];
    
    // Start by insuring image starts off at nil
    cell.imageView.image = nil;
 
    NSURL *aUrl = [NSURL URLWithString: object[@"image"]];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL: aUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData: data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    CakeTableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell)
                        updateCell.cakeImageView.image = image;
                });
            }
        } else {
            NSLog(@"Error handling");
            cell.imageView.image = nil;
        }
    }];
    [task resume];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)getData{
    
    NSURL *url = [NSURL URLWithString:@"https://gist.githubusercontent.com/hart88/198f29ec5114a3ec3460/raw/8dd19a88f9b8d24c23d9960f3300d0c917a4f07c/cake.json"];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *jsonError;
    id responseData = [NSJSONSerialization
                       JSONObjectWithData:data
                       options:kNilOptions
                       error:&jsonError];
    if (!jsonError){
        self.objects = responseData;
        [self.tableView reloadData];
    } else {
    }
    
}

@end
