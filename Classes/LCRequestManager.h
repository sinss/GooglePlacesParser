//
//  RequestManager.h
//  Pin-Here-Leo
//
//  Created by leo.chang on 1/2/15.
//  Copyright (c) 2015 Good-idea Consulgint Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCBaseRequest.h"

static const NSTimeInterval baseTimeout = 60.f;

@interface LCRequestManager : NSObject

+ (LCRequestManager*)defaultManager;

- (void)requestWith:(NSURL*)url param:(NSDictionary*)param httpMethod:(NSString *)method usePostBody:(BOOL)userPostBody completion:(completionBlock)completion falure:(falureBlock)falure;


@end
