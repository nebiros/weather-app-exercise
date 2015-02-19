//
//  WAEConstants.h
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/16/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

@import Foundation;

#define kWAEConfigApplicationDisplayName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

@interface WAEConstants : NSObject

#pragma mark - Config

extern NSInteger const kWAEConfigTimesToRetry;

#pragma mark - Flickr

extern NSString *const kWAEFlickrApiRestURL;
extern NSString *const kWAEFlickrApiParamApiKey;
extern NSString *const kWAEFlickrApiParamMethod;
extern NSString *const kWAEFlickrApiParamFormat;
extern NSString *const kWAEFlickrApiParamNoJSONCallback;

#pragma mark - OpenWeatherMap

extern NSString *const kWAEOpenWeatherMapApiRestURL;
extern NSString *const kWAEOpenWeatherMapApiRestWeatherPath;
extern NSString *const kWAEOpenWeatherMapApiParamQuery;
extern NSString *const kWAEOpenWeatherMapApiParamApiKey;

#pragma mark - Blocks

typedef void (^WAENSURLConnectionAsynchronousRequestCompletionHandlerBlock)(NSURLRequest *request,
                                                                            NSHTTPURLResponse *response,
                                                                            NSData *data,
                                                                            NSError *connectionError);

@end
