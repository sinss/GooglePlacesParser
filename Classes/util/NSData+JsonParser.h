//
//  NSData+JsonParser.h
//  Pin-Here-Leo
//
//  Created by leo.chang on 1/10/15.
//  Copyright (c) 2015 Good-idea Consulgint Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;
@interface NSData (JsonParser)

- (NSDictionary*)parseToAddress;

- (CLLocation*)parseToLocation;

- (NSDictionary*)parsePlacesInformation:(NSError*)error;
- (NSDictionary*)parsePlacesDeatil:(NSError*)error;

@end
