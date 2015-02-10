//
//  ViewController.h
//  GooglePlacesParserSample
//
//  Created by Leo Chang on 2/10/15.
//  Copyright (c) 2015 Perfectidea Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

- (IBAction)showMap:(id)sender;

@end

