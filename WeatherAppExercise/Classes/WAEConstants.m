//
//  WAEConstants.m
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/16/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

#import "WAEConstants.h"

@implementation WAEConstants

#pragma mark - Config

NSInteger const kWAEConfigTimesToRetry = 3;

#pragma mark - Flickr

NSString *const kWAEFlickrApiRestURL = @"https://api.flickr.com/services/rest";
NSString *const kWAEFlickrApiParamApiKey = @"api_key";
NSString *const kWAEFlickrApiParamMethod = @"method";
NSString *const kWAEFlickrApiParamFormat = @"format";
NSString *const kWAEFlickrApiParamNoJSONCallback = @"nojsoncallback";

#pragma mark - OpenWeatherMap

NSString *const kWAEOpenWeatherMapApiRestURL = @"http://api.openweathermap.org/data/2.5";
NSString *const kWAEOpenWeatherMapApiRestWeatherPath = @"/weather";
NSString *const kWAEOpenWeatherMapApiParamQuery = @"q";
NSString *const kWAEOpenWeatherMapApiParamApiKey = @"APPID";

@end
