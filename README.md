![Platform](https://img.shields.io/badge/platform-iOS-green.svg)
![License](https://img.shields.io/badge/License-MIT%20License-orange.svg)

# GooglePlacesParser
communication with google services

1. Get information for current location  eg. address , geolocation
2. integrating google places api that can search information of stores by given keyword.

#important 
- If you are using location services , it is necessary to add two values to your info.plist above iOS8
  ．NSLocationWhenInUseUsageDescription
  ．NSLocationAlwaysUsageDescription
#How to use

1. get current location and information
  
 - LocationMananager
```objective-c
#import LocationManager.h

[[LocationManager defaultManager] updateCurrentAddress];
```

．After calling the method , then you can get address information directly

2. google places api

```objective-c
#import GoogleParserUtils.h

[[GoogleParserUtils sharedInstnce] parsePlacesInformationWithKeyword:@"7-11" location:currentLocation completion:^(BOOL success, NSArray *items) {
        for (NSDictionary *dict in items)
        {
            NSLog(@"items : %@", dict[@"description"]);
        }
        //do your job here
    }];
```
