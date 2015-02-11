//
//  NSData+JsonParser.m
//  Pin-Here-Leo
//
//  Created by leo.chang on 1/10/15.
//  Copyright (c) 2015 Good-idea Consulgint Inc. All rights reserved.
//

#import "NSData+JsonParser.h"
#import <CoreLocation/CoreLocation.h>

@implementation NSData (JsonParser)

- (NSDictionary*)parseToAddress
{
    /*
     premise(樓層)
     postal_code
     country
     administrative_area_level_1
     administrative_area_level_2
     administrative_area_level_3
     administrative_area_level_4
     route
     street_number
     formatted_address
     international_phone_number
     review的前三則評論
     */
    NSError *error = nil;
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error];
    NSString *address = [NSString stringWithFormat:@""];
    NSString *level1 = [NSString stringWithFormat:@""];
    NSString *level2 = [NSString stringWithFormat:@""];
    NSString *level3 = [NSString stringWithFormat:@""];
    NSString *level4 = [NSString stringWithFormat:@""];
    NSString *streetNumber = [NSString stringWithFormat:@""];
    NSString *route = [NSString stringWithFormat:@""];
    NSString *premise = [NSString stringWithFormat:@""];
    NSString *postalCode = [NSString stringWithFormat:@""];
    NSString *country = [NSString stringWithFormat:@""];
    //如果GPS有查到相對位置
    if (results)
    {
        if ([[results valueForKey:@"status"] isEqualToString:@"OK"])
        {
            NSString *addrA = [[[results valueForKey:@"results"] objectAtIndex:0] valueForKey:@"formatted_address"];
            NSArray *comps = [[[results valueForKey:@"results"] objectAtIndex:0] valueForKey:@"address_components"];
            for (NSDictionary *comp in comps)
            {
                if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"street_number"])
                {
                    streetNumber = [comp valueForKey:@"long_name"];
                }
                else if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"route"])
                {
                    route = [comp valueForKey:@"long_name"];
                }
                else if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"premise"])
                {
                    premise = [comp valueForKey:@"long_name"];
                }
                else if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"postal_code"])
                {
                    postalCode = [comp valueForKey:@"long_name"];
                }
                else if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"country"])
                {
                    country = [comp valueForKey:@"long_name"];
                }
                else if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"administrative_area_level_4"])
                {
                    level4 = [comp valueForKey:@"long_name"];
                }
                else if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"administrative_area_level_3"])
                {
                    level3 = [comp valueForKey:@"long_name"];
                }
                else if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"administrative_area_level_2"])
                {
                    level2 = [comp valueForKey:@"long_name"];
                }
                else if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"administrative_area_level_1"])
                {
                    level1 = [comp valueForKey:@"long_name"];
                }

            }
            address = [NSString stringWithFormat:@"%@",addrA];
            NSLog(@"%@",address);
        }
    }
    return @{@"status":@"YES", @"address":address, @"streetNumber":streetNumber, @"route":route, @"premise":premise, @"postal_code":postalCode, @"level1":level1, @"level2":level2, @"level3":level3, @"level4":level4, @"country":country};
}

- (CLLocation*)parseToLocation
{
    NSError *error = nil;
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error];
    CLLocation *location = nil;
    //如果GPS有查到相對位置
    if (results)
    {
        if ([[results valueForKey:@"status"] isEqualToString:@"OK"])
        {
            NSString *lat = [[[[[results valueForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"]  valueForKey:@"location"] valueForKey:@"lat"];
            
            NSString *lng = [[[[[results valueForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"]  valueForKey:@"location"] valueForKey:@"lng"];
            
            location = [[CLLocation alloc] initWithLatitude:lat.doubleValue longitude:lng.doubleValue];
        }
    }
    return location;
}

- (NSDictionary*)parsePlacesInformation:(NSError*)error
{
    NSDictionary *jSONresult = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:nil];
    NSArray *results = [jSONresult valueForKey:@"predictions"];
    if (error || [jSONresult[@"status"] isEqualToString:@"NOT_FOUND"] || [jSONresult[@"status"] isEqualToString:@"REQUEST_DENIED"])
    {
        if (!error)
        {
            NSDictionary *userInfo = @{@"error":jSONresult[@"status"]};
            NSError *newError = [NSError errorWithDomain:@"API Error" code:666 userInfo:userInfo];
            return @{@"status":@"NO", @"result":@[@"API Error", newError]};
        }
        return @{@"status":@"NO", @"result":@[@"API Error", error]};
    }
    else
    {
        return @{@"status":@"YES", @"result":results};
    }
}

- (NSDictionary*)parsePlacesDeatil:(NSError*)error
{
    NSString *placeId = [NSString stringWithFormat:@""];;
    NSString *address = [NSString stringWithFormat:@""];
    NSString *name = [NSString stringWithFormat:@""];
    NSString *streetNumber = [NSString stringWithFormat:@""];
    NSString *route = [NSString stringWithFormat:@""];
    NSString *premise = [NSString stringWithFormat:@""];
    NSString *postalCode = [NSString stringWithFormat:@""];
    NSString *phoneNumber = [NSString stringWithFormat:@""];
    NSMutableArray *reviewNotes = [NSMutableArray array];
    NSString *level1 = [NSString stringWithFormat:@""];
    NSString *level2 = [NSString stringWithFormat:@""];
    NSString *level3 = [NSString stringWithFormat:@""];
    NSString *level4 = [NSString stringWithFormat:@""];
    NSString *country = [NSString stringWithFormat:@""];
    double latitude = 0;
    double longitude = 0;
    NSDictionary *jSONresult = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *dict = [jSONresult valueForKey:@"result"];
    if (error || [jSONresult[@"status"] isEqualToString:@"NOT_FOUND"] || [jSONresult[@"status"] isEqualToString:@"REQUEST_DENIED"])
    {
        if (!error)
        {
            NSDictionary *userInfo = @{@"error":jSONresult[@"status"]};
            NSError *newError = [NSError errorWithDomain:@"API Error" code:666 userInfo:userInfo];
            return @{@"status":@"NO", @"result":@[@"API Error", newError]};
        }
        return @{@"status":@"NO", @"result":@[@"API Error", error]};
    }
    else
    {
        /*
         geometry =     {
         location =         {
         lat = "25.036561";
         lng = "121.558423";
         };
         };
         */
        placeId = dict[@"place_id"];
        address = dict[@"formatted_address"];
        name = dict[@"name"];
        phoneNumber = dict[@"international_phone_number"];
        latitude = [[[[dict valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"] doubleValue];
        longitude = [[[[dict valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"] doubleValue];
        //Reviews
        NSArray *reviews = dict[@"reviews"];
        for (NSDictionary *review in reviews)
        {
            [reviewNotes addObject:review[@"text"]];
        }
        //地址
        NSDictionary *addressComps = dict[@"address_components"];
        for (NSDictionary *comp in addressComps)
        {
            if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"street_number"])
            {
                streetNumber = [comp valueForKey:@"long_name"];
            }
            else if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"route"])
            {
                route = [comp valueForKey:@"long_name"];
            }
            else if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"premise"])
            {
                premise = [comp valueForKey:@"long_name"];
            }
            else if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"postal_code"])
            {
                postalCode = [comp valueForKey:@"long_name"];
            }
            else if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"country"])
            {
                country = [comp valueForKey:@"long_name"];
            }
            else if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"administrative_area_level_4"])
            {
                level4 = [comp valueForKey:@"long_name"];
            }
            else if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"administrative_area_level_3"])
            {
                level3 = [comp valueForKey:@"long_name"];
            }
            else if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"administrative_area_level_2"])
            {
                level2 = [comp valueForKey:@"long_name"];
            }
            else if ([[[comp valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"administrative_area_level_1"])
            {
                level1 = [comp valueForKey:@"long_name"];
            }
            
        }
        return @{@"status":@"YES", @"place_id":placeId, @"address":address, @"name":name, @"streetNumber":streetNumber, @"route":route, @"premise":premise, @"postal_code":postalCode, @"phone_number":phoneNumber, @"reviews":reviewNotes, @"level1":level1, @"level2":level2, @"level3":level3, @"level4":level4, @"country":country, @"latitude":@(latitude), @"longitude":@(longitude)};
    }
}

@end
