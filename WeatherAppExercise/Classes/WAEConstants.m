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
NSString *const kWAEConfigTemperature = @"Temperature";

#pragma mark - Flickr

NSString *const kWAEFlickrApiRestURL = @"https://api.flickr.com/services/rest";
NSString *const kWAEFlickrApiParamApiKey = @"api_key";
NSString *const kWAEFlickrApiParamMethod = @"method";
NSString *const kWAEFlickrApiParamFormat = @"format";
NSString *const kWAEFlickrApiParamNoJSONCallback = @"nojsoncallback";
NSString *const kWAEFlickrApiMethodPhotosSearch = @"flickr.photos.search";
NSString *const kWAEFlickrApiParamText = @"text";
NSString *const kWAEFlickrApiParamLat = @"lat";
NSString *const kWAEFlickrApiParamLon = @"lon";
NSString *const kWAEFlickrApiParamPerPage = @"per_page";
NSString *const kWAEFlickrApiPhotoURLFormat = @"https://farm%@.staticflickr.com/%@/%@_%@_z.jpg";
NSString *const kWAEFlickrApiParamMinUploadDate = @"min_upload_date";
NSString *const kWAEFlickrApiParamSort = @"sort";
NSString *const kWAEFlickrApiParamContentType = @"content_type";
NSString *const kWAEFlickrApiParamApiSig = @"api_sig";

#pragma mark - OpenWeatherMap

NSString *const kWAEOpenWeatherMapApiRestURL = @"http://api.openweathermap.org/data/2.5";
NSString *const kWAEOpenWeatherMapApiRestWeatherPath = @"/weather";
NSString *const kWAEOpenWeatherMapApiParamQuery = @"q";
NSString *const kWAEOpenWeatherMapApiParamApiKey = @"APPID";
NSString *const kWAEOpenWeatherMapApiParamUnits = @"units";
NSString *const kWAEOpenWeatherMapApiParamLat = @"lat";
NSString *const kWAEOpenWeatherMapApiParamLon = @"lon";
NSString *const kWAEOpenWeatherMapApiTemperatureUnitMetric = @"metric";
NSString *const kWAEOpenWeatherMapApiTemperatureUnitImperial = @"imperial";

#pragma mark - Exercise

NSString *const kWAEExerciseCitiesURL = @"https://dl.dropboxusercontent.com/u/3501/countries.json";

#pragma mark - IDs

NSString *const kWAEStoryboardSegueRootToCities = @"RootToCitiesSegue";
NSString *const kWAECollectionCellCity = @"CityCollectionViewCell";
NSString *const kWAEStoryboardSegueCityTappedToRoot = @"CityTappedToRootSegue";

@end
