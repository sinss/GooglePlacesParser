//
//  MapAnnotation.h
//  GooglePlacesParserSample
//
//  Created by Leo Chang on 2/10/15.
//  Copyright (c) 2015 Perfectidea Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, PinType)
{
    PinTypeDefault,
};

@interface MapAnnotation : NSObject <MKAnnotation>

- (id)initWithCoordinate:(CLLocationCoordinate2D)c;

@property (nonatomic, strong) NSString *ktitle;
@property (nonatomic, strong) NSString *ksubTitle;
@property (nonatomic, assign) CLLocationCoordinate2D kCoordinate;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) PinType pinType;
@end
