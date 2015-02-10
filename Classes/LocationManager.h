//
//  LocationManager.h
//  UICatalog
//
//  Created by Leo on 11/8/14.
//  Copyright (c) 2014 Perfectidea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <UIKit/UIKit.h>

#define LOCATION_UPDATED_EVENT @"CurrentLocationUpdated"
typedef void (^GeocodeBlock) (CLLocation *location, BOOL success);

@interface LocationManager : NSObject <CLLocationManagerDelegate>

/*
 informations for current locations
 */
@property (strong, nonatomic) CLLocationManager *locmanager;
@property (strong, nonatomic) NSString *currentAddress;
@property (strong, nonatomic) NSString *currentLevel1;
@property (strong, nonatomic) NSString *currentLevel2;
@property (strong, nonatomic) NSString *currentLevel3;
@property (strong, nonatomic) NSString *currentLevel4;
@property (strong, nonatomic) NSDictionary *currentInformations;

+ (LocationManager*)defaultManager;

- (id)initwithSometype:(NSInteger)type;

- (void)stopUpdatingLocation;
- (void)startUpdatingLocation;

- (BOOL)locationServicesEnabled;
- (BOOL)CanDeviceSupportAppBackgroundRefresh;

//Geolocation
- (CLLocation*)getCurrentLocation;
- (void)updateCurrentAddress;
- (CLLocationDistance)distanceOfLocation:(CLLocation*)location;

+ (void)getGeolocation:(NSString*)address completion:(GeocodeBlock)competion;

@end
