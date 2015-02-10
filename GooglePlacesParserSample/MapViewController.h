//
//  MapViewController.h
//  GooglePlacesParserSample
//
//  Created by Leo Chang on 2/10/15.
//  Copyright (c) 2015 Perfectidea Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)close:(id)sender;

@end
