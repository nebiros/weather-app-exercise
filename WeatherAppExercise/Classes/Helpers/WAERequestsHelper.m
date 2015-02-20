//
//  WAERequestsHelper.m
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/17/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

#import "WAERequestsHelper.h"

#import <RequestUtils/RequestUtils.h>
#import "JIMEnvironments.h"
#import "NSString+JIMNSStringUtilities.h"

@implementation WAERequestsHelper

+ (void)request:(NSURL *)URL
            via:(NSString *)via
 withParameters:(NSDictionary *)params
       andBlock:(WAENSURLConnectionAsynchronousRequestCompletionHandlerBlock)block
{
    NSURLRequest *req = [NSURLRequest HTTPRequestWithURL:URL
                                                  method:[via uppercaseString]
                                              parameters:params];
#ifdef DEBUG
    NSLog(@"req, %@", req);
#endif
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        return block(req, (NSHTTPURLResponse *) response, data, connectionError);
    }];
}

+ (void)requestFlickrApiWithFlickrMethod:(NSString *)flickrMethod
                                     via:(NSString *)via
                          withParameters:(NSDictionary *)params
                                andBlock:(WAERequestCompletionResultBlock)block
{
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    if (params) {
        p = [NSMutableDictionary dictionaryWithDictionary:params];
    }
    
    [p setObject:flickrMethod forKey:kWAEFlickrApiParamMethod];
    [p setObject:[JIMEnvironments sharedInstance].environment[@"FlickrApiKey"] forKey:kWAEFlickrApiParamApiKey];
    [p setObject:@"json" forKey:kWAEFlickrApiParamFormat];
    [p setObject:@1 forKey:kWAEFlickrApiParamNoJSONCallback];
    // see: https://www.flickr.com/services/api/auth.howto.web.html
    // secret + 'api_key' + [api_key] + 'perms' + [perms]
    /*
    NSString *apiSig = [NSString stringWithFormat:@"%@api_key%@permsread",
                        [JIMEnvironments sharedInstance].environment[@"FlickrApiSecret"],
                        [JIMEnvironments sharedInstance].environment[@"FlickrApiKey"]];
    [p setObject:[apiSig jim_MD5] forKey:kWAEFlickrApiParamApiSig];
    */
    NSURL *URL = [NSURL URLWithString:kWAEFlickrApiRestURL];
    
    [self requestAndSerializeResult:URL via:via withParameters:p andBlock:block];
}

+ (void)requestOpenWeatherMapApiWithPath:(NSString *)path
                                     via:(NSString *)via
                          withParameters:(NSDictionary *)params
                                andBlock:(WAERequestCompletionResultBlock)block
{
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    if (params) {
        p = [NSMutableDictionary dictionaryWithDictionary:params];
    }
    
    [p setObject:[JIMEnvironments sharedInstance].environment[@"OpenWeatherMapApiKey"] forKey:kWAEOpenWeatherMapApiParamApiKey];
    [p setObject:@"metric" forKey:kWAEOpenWeatherMapApiParamUnits];
    
    NSString *URLAsString = [NSString stringWithFormat:@"%@%@", kWAEOpenWeatherMapApiRestURL, path];
    NSURL *URL = [NSURL URLWithString:URLAsString];
    
    [self requestAndSerializeResult:URL via:via withParameters:p andBlock:block];
}

+ (void)requestAndSerializeResult:(NSURL *)URL
                              via:(NSString *)via
                   withParameters:(NSDictionary *)params
                         andBlock:(WAERequestCompletionResultBlock)block
{
    [self request:URL via:via withParameters:params andBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError && !data) {
            NSString *errorMessage = [NSString stringWithFormat:@"\n%@\n%@", [connectionError localizedDescription], connectionError.userInfo];
            NSLog(@"[ERROR] - %s: %@",
                  __PRETTY_FUNCTION__,
                  errorMessage);
            
            return block(NO, nil, connectionError);
        }
        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
#ifdef DEBUG
        NSLog(@"json, %@", json);
#endif
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"\n%@\n%@", [error localizedDescription], error.userInfo];
            NSLog(@"[ERROR] - %s: %@",
                  __PRETTY_FUNCTION__,
                  errorMessage);
            
            return block(NO, nil, error);
        }
        
        if (response.statusCode != 200) {
            NSError *e = [NSError
                          errorWithDomain:@"im.juan.WeatherAppExercise"
                          code:response.statusCode
                          userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(json[@"message"], nil),
                                     @"responseStatusCode": @(response.statusCode),
                                     @"responseCode": json[@"code"],
                                     @"responseMessage": json[@"message"]}];
            return block(NO, nil, e);
        }
        
        return block(YES, json, nil);
    }];
}

+ (void)getRandomPhotoDataFromFlickrWithParameters:(NSDictionary *)params andBlock:(WAERequestCompletionResultBlock)block
{
    [self requestFlickrApiWithFlickrMethod:kWAEFlickrApiMethodPhotosSearch
                                       via:@"GET"
                            withParameters:params
                                  andBlock:
     ^(BOOL succeeded, NSDictionary *result, NSError *error) {
         if (error) {
             NSString *errorMessage = [NSString stringWithFormat:@"\n%@\n%@", [error localizedDescription], error.userInfo];
             NSLog(@"[ERROR] - %s: %@",
                   __PRETTY_FUNCTION__,
                   errorMessage);
             
             return block(NO, nil, error);
         }

         NSArray *photos = (NSArray *) result[@"photos"][@"photo"];
         
         if (photos.count > 0) {
             NSDictionary *photoData = [NSDictionary dictionaryWithDictionary:photos[arc4random_uniform(photos.count)]];
#ifdef DEBUG
             NSLog(@"photoData, %@", photoData);
#endif
             return block(YES, photoData, nil);
         }
         
         return block(NO, nil, nil);
     }];
}

+ (void)getRandomPhotoURLFromFlickrWithParameters:(NSDictionary *)params andBlock:(WAERequestCompletionResultBlock)block
{
    [self getRandomPhotoDataFromFlickrWithParameters:params andBlock:^(BOOL succeeded, NSDictionary *result, NSError *error) {
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"\n%@\n%@", [error localizedDescription], error.userInfo];
            NSLog(@"[ERROR] - %s: %@",
                  __PRETTY_FUNCTION__,
                  errorMessage);
            
            return block(NO, nil, error);
        }
        
        NSString *photoURL = [NSString stringWithFormat:kWAEFlickrApiPhotoURLFormat,
                              result[@"farm"],
                              result[@"server"],
                              result[@"id"],
                              result[@"secret"]];
        NSURL *URL = [NSURL URLWithString:photoURL];
#ifdef DEBUG
        NSLog(@"URL.absoluteString, %@", URL.absoluteString);
#endif
        return block(YES, URL, nil);
    }];
}

+ (void)getRandomPhotoFromFlickrWithParameters:(NSDictionary *)params andBlock:(WAERequestCompletionResultBlock)block
{
    [self getRandomPhotoURLFromFlickrWithParameters:params andBlock:^(BOOL succeeded, NSURL *result, NSError *error) {
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"\n%@\n%@", [error localizedDescription], error.userInfo];
            NSLog(@"[ERROR] - %s: %@",
                  __PRETTY_FUNCTION__,
                  errorMessage);
            
            return block(NO, nil, error);
        }
        
        if (result) {
            NSData *data = [NSData dataWithContentsOfURL:result];
            UIImage *randomPhoto = [UIImage imageWithData:data];
            
            return block(YES, randomPhoto, nil);
        }
        
        return block(NO, nil, nil);
    }];
}

+ (void)getExerciseCitiesWithBlock:(WAERequestCompletionResultBlock)block
{
    NSURL *URL = [NSURL URLWithString:kWAEExerciseCitiesURL];
    [self requestAndSerializeResult:URL via:@"GET" withParameters:nil andBlock:block];
}

+ (void)getExerciseCityPhotoWithImageURL:(NSString *)imageURL andBlock:(WAERequestCompletionResultBlock)block
{
    NSURL *URL = [NSURL URLWithString:imageURL];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:URL];
        
        if (!data) {
            return block(NO, nil, nil);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:data];
            return block(YES, image, nil);
        });
    });
}


@end
