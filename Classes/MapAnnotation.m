//
//  MapAnnotation.m
//  GooglePlacesParserSample
//
//  Created by Leo Chang on 2/10/15.
//  Copyright (c) 2015 Perfectidea Inc. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)c
{
    self = [super init];
    if (self)
    {
        _kCoordinate = c;
    }
    return self;
}

- (NSString *)subtitle{
    return _ksubTitle;
}

- (NSString *)title{
    return _ktitle;
}

- (CLLocationCoordinate2D)coordinate
{
    return _kCoordinate;
}

@end
