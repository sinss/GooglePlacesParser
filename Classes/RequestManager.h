//
//  RequestManager.h
//  Pin-Here-Leo
//
//  Created by leo.chang on 1/2/15.
//  Copyright (c) 2015 Good-idea Consulgint Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

#define kSearchUrl @"http://pin-here.com/api/search_pins"
#define kUserPinsUrl @"http://pin-here.com/api/user_pins"
#define kLoginUrl @"http://pin-here.com/api/login"
#define kTestUrl @"http://pin-here.com/test_http"

static const NSTimeInterval baseTimeout = 60.f;

@interface RequestManager : NSObject

+ (RequestManager*)defaultManager;

- (void)requestWith:(NSURL*)url param:(NSDictionary*)param httpMethod:(NSString *)method usePostBody:(BOOL)userPostBody completion:(completionBlock)completion falure:(falureBlock)falure;

- (void)requestSearchPinsWithParam:(NSDictionary*)param httpMethod:(NSString*)method usePostBody:(BOOL)userPostBody completion:(completionBlock)completion falure:(falureBlock)falure;

- (void)requestLoginWithParam:(NSDictionary*)param httpMethod:(NSString*)method usePostBody:(BOOL)userPostBody completion:(completionBlock)completion falure:(falureBlock)falure;

- (void)requestUserPinsWithParam:(NSDictionary*)param httpMethod:(NSString*)method usePostBody:(BOOL)userPostBody completion:(completionBlock)completion falure:(falureBlock)falure;

@end
