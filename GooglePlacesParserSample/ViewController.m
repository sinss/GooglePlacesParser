//
//  ViewController.m
//  GooglePlacesParserSample
//
//  Created by Leo Chang on 2/10/15.
//  Copyright (c) 2015 Perfectidea Inc. All rights reserved.
//

#import "ViewController.h"
#import "LocationManager.h"
#import "AppDelegate.h"
#import "MapViewController.h"

typedef NS_ENUM(NSInteger, TBSection)
{
    TBSectionAddress = 0,
    TBSectionCountry,
    TBSectionRoute,
    TBSectionStreetnumber,
    TBSectionPremis,
    TBSectionPostalcode,
    TBSectionLevel1,
    TBSectionLevel2,
    TBSectionLevel3,
    TBSectionLevel4,
    TBSectionCount,
};

static NSString *cellIdentifier = @"cellIdentifier";

@interface ViewController ()

@end

@implementation ViewController

- (AppDelegate*)appDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:LOCATION_UPDATED_EVENT object:nil];

    /*
     trigger location manger to update current address
     */
    [[LocationManager defaultManager] updateCurrentAddress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TBSectionCount;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    NSDictionary *dict = [LocationManager defaultManager].currentInformations;
    switch (indexPath.row)
    {
        case TBSectionAddress:
            cell.textLabel.text = [NSString stringWithFormat:@"address"];
            cell.detailTextLabel.text = [LocationManager defaultManager].currentAddress;
            break;
        case TBSectionCountry:
            cell.textLabel.text = [NSString stringWithFormat:@"country"];
            cell.detailTextLabel.text = dict[@"country"];
            break;
        case TBSectionRoute:
            cell.textLabel.text = [NSString stringWithFormat:@"route"];
            cell.detailTextLabel.text = dict[@"route"];
            break;
        case TBSectionStreetnumber:
            cell.textLabel.text = [NSString stringWithFormat:@"street number"];
            cell.detailTextLabel.text = dict[@"street_number"];
            break;
        case TBSectionPremis:
            cell.textLabel.text = [NSString stringWithFormat:@"premis"];
            cell.detailTextLabel.text = dict[@"premise"];
            break;
        case TBSectionPostalcode:
            cell.textLabel.text = [NSString stringWithFormat:@"postal code"];
            cell.detailTextLabel.text = dict[@"postal_code"];
            break;
        case TBSectionLevel1:
            cell.textLabel.text = [NSString stringWithFormat:@"level 1"];
            cell.detailTextLabel.text = [LocationManager defaultManager].currentLevel1;
            break;
        case TBSectionLevel2:
            cell.textLabel.text = [NSString stringWithFormat:@"level 2"];
            cell.detailTextLabel.text = [LocationManager defaultManager].currentLevel2;
            break;
        case TBSectionLevel3:
            cell.textLabel.text = [NSString stringWithFormat:@"level 3"];
            cell.detailTextLabel.text = [LocationManager defaultManager].currentLevel3;
            break;
        case TBSectionLevel4:
            cell.textLabel.text = [NSString stringWithFormat:@"level 4"];
            cell.detailTextLabel.text = [LocationManager defaultManager].currentLevel4;
            break;
    }
    
    return cell;
}

- (IBAction)showMap:(id)sender
{
    MapViewController *vc = [[AppDelegate mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass(MapViewController.class)];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - NSNotificationCenter
- (void)locationUpdated:(NSNotification*)noti
{
    [self.tableView reloadData];
}
@end
