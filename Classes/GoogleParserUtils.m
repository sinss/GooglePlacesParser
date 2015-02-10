//
//  GoogleParserUtils.m
//  Pin-Here-Leo
//
//  Created by Leo on 2/6/15.
//  Copyright (c) 2015 Good-idea Consulgint Inc. All rights reserved.
//

#import "GoogleParserUtils.h"
#import <CoreLocation/CoreLocation.h>
#import "NSData+JsonParser.h"

@implementation GoogleParserUtils

+ (GoogleParserUtils*)sharedInstnce
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[GoogleParserUtils alloc] init];
    });
    
    return instance;
}

- (void)parsePlacesInformationWithKeyword:(NSString*)searchKey location:(CLLocation*)location completion:(ParserBlock)completion
{
    NSString *searchWordProtection = [searchKey stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (searchWordProtection.length != 0) {
        
        NSString *currentLatitude = @(location.coordinate.latitude).stringValue;
        NSString *currentLongitude = @(location.coordinate.longitude).stringValue;
        
        NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment|geocode&location=%@,%@&radius=500&language=en&key=%@", searchKey, currentLatitude, currentLongitude, googleApiKey];
        NSLog(@"AutoComplete URL: %@",urlString);
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionDataTask *task = [delegateFreeSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSDictionary *dict = [data parsePlacesInformation:error];
            completion ([[dict valueForKey:@"status"] boolValue], dict[@"result"]);
        }];
        
        [task resume];
    }
}

- (void)parsePlacesDtailWithPlace:(NSString*)place location:(CLLocation*)location completion:(ParserBlock)completion
{
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@", place, googleApiKey];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [delegateFreeSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dict = [data parsePlacesDeatil:error];
        completion ([[dict valueForKey:@"status"] boolValue], @[dict]);
    }];
    
    [task resume];
}

@end
