//
//  GoogleParserUtils.h
//  Pin-Here-Leo
//
//  Created by Leo on 2/6/15.
//  Copyright (c) 2015 Good-idea Consulgint Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#warning Please Enter your google api key
#define googleApiKey @"< Please Enter your google api key >"

typedef void (^ParserBlock) (BOOL success, NSArray *items);

@class CLLocation;
@interface GoogleParserUtils : NSObject

+ (GoogleParserUtils*)sharedInstnce;

/*
 Parse Places for autocomplete
 */
- (void)parsePlacesInformationWithKeyword:(NSString*)searchKey location:(CLLocation*)location completion:(ParserBlock)completion;

/*
 Parse defail of each place item
 */
- (void)parsePlacesDtailWithPlace:(NSString*)place location:(CLLocation*)location completion:(ParserBlock)completion;

@end
