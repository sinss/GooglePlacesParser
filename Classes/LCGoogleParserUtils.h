//
//  GoogleParserUtils.h
//  Pin-Here-Leo
//
//  Created by Leo on 2/6/15.
//  Copyright (c) 2015 Good-idea Consulgint Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#warning NOTE !! Please Enter your google api key
#warning NOTE !! It Must replaced your own google api key
#define googleApiKey @"< put your google api key in here >"

typedef void (^ParserBlock) (BOOL success, NSArray *items);

@class CLLocation;
@interface LCGoogleParserUtils : NSObject

+ (LCGoogleParserUtils*)sharedInstnce;

/*
 Parse Places for autocomplete
 */
- (void)parsePlacesInformationWithKeyword:(NSString*)searchKey location:(CLLocation*)location completion:(ParserBlock)completion;

/*
 Parse defail of each place item
 */
- (void)parsePlacesDtailWithPlace:(NSString*)place location:(CLLocation*)location completion:(ParserBlock)completion;

@end
