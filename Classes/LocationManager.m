//
//  LocationManager.m
//  UICatalog
//
//  Created by Leo on 11/8/14.
//  Copyright (c) 2014 Perfectidea. All rights reserved.
//

#import "LocationManager.h"
#import "RequestManager.h"
#import "NSData+JsonParser.h"

#define regionIdentifier @"regionIdentifier"

@interface LocationManager()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LocationManager

+ (LocationManager*)defaultManager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[LocationManager alloc] init];
    });
    
    return instance;
}

- (id)initwithSometype:(NSInteger)type
{
//    self = [self init];
//    if (self)
//    {
//        
//    }
    return self;
}

- (id)init
{
    if (self = [super init])
    {
        [self createLocationManager];
    }
    return self;
}

- (void)createLocationManager
{
    self.locmanager = [[CLLocationManager alloc] init];
    
    //[self startUpdatingLocation];
    /*
     注意
     NSLocationAlwaysUsageDescription
     NSLocationAlwaysUsageDescription
     在Setting Info.plist裡面一定要加上這兩組Key才可以正常使用(iOS8)
     */
}

- (void)stopUpdatingLocation
{
    [_locmanager stopUpdatingLocation];
    [_locmanager stopUpdatingHeading];
    [_locmanager stopMonitoringSignificantLocationChanges];
}

- (void)startUpdatingLocation
{
    /*
     iOS8 以上
     */
    if ([self.locmanager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        //[self.locmanager requestWhenInUseAuthorization];
        [self.locmanager requestAlwaysAuthorization];
    }
    [_locmanager setDelegate:self];
    //設定人在移動多遠時才會定位的距離
    [_locmanager setDistanceFilter:1.0f];
    //degree -->手機在轉動時
    [_locmanager setHeadingFilter:kCLHeadingFilterNone];
    
    //精準度，愈精準愈耗電。
    [_locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
    //開始定位
    [_locmanager startUpdatingLocation];
    [_locmanager startMonitoringSignificantLocationChanges];
    NSLog(@"(1) lat : %f, long : %f", _locmanager.location.coordinate.latitude, _locmanager.location.coordinate.longitude);
    
    [_locmanager startUpdatingHeading];
    
    NSLog(@"(2) lat : %f, long : %f", _locmanager.location.coordinate.latitude, _locmanager.location.coordinate.longitude);
    
    
    //精準度，愈精準愈耗電。
    [_locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [self startMonitoringRegions];
    
}

- (CLCircularRegion*)getFirstRegion
{
    CLLocationCoordinate2D location;
    /*
     [[CLLocation alloc] initWithLatitude:25.085f longitude:121.524f];
     */
    location.latitude = 25.033807f;
    location.longitude = 121.564759f;
    
    CLLocationDistance regionRadius = 8000.00;
//    CLLocationAccuracy acc = 10.0;
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:location radius:regionRadius identifier:regionIdentifier];

    return region;
}

- (void)startMonitoringRegions
{
//    [_locmanager startMonitoringForRegion:[self getFirstRegion]];
//    
//    [_locmanager startMonitoringSignificantLocationChanges];
}

- (CLLocation*)getCurrentLocation
{
    if (!_locmanager.location)
    {
        return [[CLLocation alloc] initWithLatitude:25.033807f longitude:121.564759f];
    }
    return _locmanager.location;
}

- (BOOL)locationServicesEnabled
{
    NSLog(@"locationService is %@", [CLLocationManager locationServicesEnabled] ? @"YES" : @"NO");
    if([CLLocationManager locationServicesEnabled])
    {
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            return NO;
        }
    }
    return YES;
}

-(BOOL)CanDeviceSupportAppBackgroundRefresh
{
    // Override point for customization after application launch.
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusAvailable)
    {
        NSLog(@"Background updates are available for the app.");
        return YES;
    }
    else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied)
    {
        NSLog(@"The user explicitly disabled background behavior for this app or for the whole system.");
        return NO;
    }
    else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted)
    {
        NSLog(@"Background updates are unavailable and the user cannot enable them again. For example, this status can occur when parental controls are in effect for the current user.");
        return NO;
    }
    return NO;
}

#pragma mark - LocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    BOOL canUseLocationNotifications = (status == kCLAuthorizationStatusAuthorizedWhenInUse);
    if (canUseLocationNotifications)
    {
        [self startMonitoringRegions];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"(old) lat : %f, long : %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"(new) lat : %f, long : %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"start monitoring %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Enter");
    [self showNotificationAlert];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"Exit");
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"monitoringDidFailForRegion - error: %@", [error localizedDescription]);
}


- (void)showNotificationAlert
{
    /*
     註冊通知
     */
    UILocalNotification *locNotification = [[UILocalNotification alloc]
                                            init];
    locNotification.alertBody = @"您到達了ｘｘｘｘ!";
    //iOS7以前沒有CLRegion物件，必須使用自已定義的Idntifier識別
    locNotification.userInfo = @{@"key":@"value", @"regionIdentifier":regionIdentifier};
    locNotification.regionTriggersOnce = YES;
    if ([locNotification respondsToSelector:@selector(region)])
    {
        locNotification.region = [self getFirstRegion];
    }
    //註冊一個LocaNotification
    [[UIApplication sharedApplication] scheduleLocalNotification:locNotification];
}


- (void)getCurrentAddress
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?latlng=%f,%f&sensor=false",self.getCurrentLocation.coordinate.latitude, self.getCurrentLocation.coordinate.longitude]];
    
    
    [[RequestManager defaultManager] requestWith:url param:@{} httpMethod:kPostMethod usePostBody:NO completion:^(PFRequestTag tag, NSData *data) {
        if (data)
        {
            NSDictionary *dict = [data parseToAddress];
            
            self.currentAddress = dict[@"address"];
            self.currentLevel1 = dict[@"level1"];
            self.currentLevel2 = dict[@"level2"];
            self.currentLevel3 = dict[@"level3"];
            self.currentLevel4 = dict[@"level4"];
            self.currentInformations = dict;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_UPDATED_EVENT object:nil];
    } falure:^(PFRequestTag tag, NSError *error){
        NSLog(@"error");
    }];
}

- (CLLocationDistance)distanceOfLocation:(CLLocation *)location
{
    CLLocation *distanceLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    CLLocationDistance distance = [self.getCurrentLocation distanceFromLocation:distanceLocation];
    return distance;
}

+ (void)getGeolocation:(NSString *)address completion:(GeocodeBlock)competion
{
    //@"http://maps.google.com/maps/api/geocode/json?address=%E5%8F%B0%E5%8C%97%E5%B8%82%E7%91%9E%E5%85%89%E8%B7%AF480%E8%99%9F&sensor=true"
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=%@&sensor=false", address]];
    [[RequestManager defaultManager] requestWith:url param:@{} httpMethod:kPostMethod usePostBody:NO completion:^(PFRequestTag tag, NSData *data){
    
        [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_UPDATED_EVENT object:nil];
    } falure:^(PFRequestTag tag, NSError *error){
    
        
    }];
}

- (void)updateCurrentAddress
{
    /*
     Use timer to prevent update address too many times
     */
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.65f
                                                              target:self
                                                            selector:@selector(getCurrentAddress)
                                                            userInfo:nil
                                                             repeats:NO];
}

@end
