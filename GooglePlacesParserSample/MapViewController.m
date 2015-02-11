//
//  MapViewController.m
//  GooglePlacesParserSample
//
//  Created by Leo Chang on 2/10/15.
//  Copyright (c) 2015 Perfectidea Inc. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LCGoogleParserUtils.h"
#import "LCLocationManager.h"
#import "MapAnnotation.h"

@interface MapViewController()

@property (nonatomic, strong) NSArray *stores;

@end

@implementation MapViewController

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getSpotsByCurrentLocation];
}

#pragma mark - MapViewDelegate

- (MKAnnotationView *) mapView:(MKMapView *)eMapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    MapAnnotation *addTheAnnotation = (MapAnnotation *)annotation;
    static NSString *pinIdentifier = @"PinIdentifier";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[eMapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
    
    if(pinView == nil)
    {
        
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
        pinView.frame = CGRectMake(0, 0, 20, 20);
        
    }
    else
    {
        pinView.annotation = annotation;
    }
    
    switch (addTheAnnotation.pinType)
    {
        case PinTypeDefault:
            pinView.pinColor = MKPinAnnotationColorGreen;
            break;
        default:
            pinView.image =[UIImage imageNamed:@"image name"];
            break;
    }
    pinView.tag = addTheAnnotation.tag;
    pinView.animatesDrop = NO;
    pinView.canShowCallout = YES;
    pinView.calloutOffset = CGPointMake(-5, 5);
    pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return pinView;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSInteger index = view.tag;
    NSDictionary *dict = self.stores[index];
    NSLog(@"click : %@", dict[@"description"]);
}

- (void)getSpotsByCurrentLocation
{
    CLLocation *currentLocation = [LCLocationManager defaultManager].getCurrentLocation;
    
    [[LCGoogleParserUtils sharedInstnce] parsePlacesInformationWithKeyword:@"7-11" location:currentLocation completion:^(BOOL success, NSArray *items) {
        for (NSDictionary *dict in items)
        {
            NSLog(@"items : %@", dict[@"description"]);
        }
        self.stores = items;
        [self resetMap];
        [self reloadMap];
    }];
}

- (void)resetMap
{
    MKCoordinateSpan span;
    span.latitudeDelta = 0.02f;
    span.longitudeDelta = 0.02f;
    MKCoordinateRegion region;
    region.center = [LCLocationManager defaultManager].getCurrentLocation.coordinate;
    region.span = span;
    self.mapView.region = region;
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)reloadMap
{
    CLLocation *currentLocation = [LCLocationManager defaultManager].getCurrentLocation;
    NSInteger counter = 0;
    for (NSDictionary *dict in _stores)
    {
        __block NSInteger index = counter;
        [[LCGoogleParserUtils sharedInstnce] parsePlacesDtailWithPlace:dict[@"place_id"] location:currentLocation completion:^(BOOL success, NSArray *items){
            @autoreleasepool {
                NSDictionary *detail = items[0];
                CLLocationDegrees latitude = [detail[@"latitude"] doubleValue];
                CLLocationDegrees longitude = [detail[@"longitude"] doubleValue];
                CLLocationCoordinate2D location;
                location.latitude = latitude;
                location.longitude = longitude;
                MapAnnotation *annot = [[MapAnnotation alloc] initWithCoordinate:location];
                annot.pinType = PinTypeDefault;
                annot.tag = index;
                annot.ktitle = detail[@"name"];
                annot.ksubTitle = detail[@"address"];
                [self.mapView addAnnotation:annot];
            }
        }];
        
        counter ++;
    }
}

@end
