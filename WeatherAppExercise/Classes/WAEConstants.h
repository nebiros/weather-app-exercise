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
extern NSString *const kWAEFlickrApiMethodPhotosSearch;
extern NSString *const kWAEFlickrApiParamText;
extern NSString *const kWAEFlickrApiParamLat;
extern NSString *const kWAEFlickrApiParamLon;
extern NSString *const kWAEFlickrApiParamPerPage;
/**
 *  @see https://www.flickr.com/services/api/misc.urls.html
 *
 *  https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
 */
extern NSString *const kWAEFlickrApiPhotoURLFormat;
extern NSString *const kWAEFlickrApiParamMinUploadDate;
extern NSString *const kWAEFlickrApiParamSort;
extern NSString *const kWAEFlickrApiParamContentType;
extern NSString *const kWAEFlickrApiParamApiSig;

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
typedef void (^WAERequestCompletionResultBlock)(BOOL succeeded, id result, NSError *error);
typedef void (^WAERequestCompletionBlock)(BOOL succeeded, NSError *error);

@end
