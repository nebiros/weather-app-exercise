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

@implementation WAERequestsHelper

+ (void)request:(NSURL *)URL
            via:(NSString *)via
 withParameters:(NSDictionary *)params
       andBlock:(WAENSURLConnectionAsynchronousRequestCompletionHandlerBlock)block
{
    NSURLRequest *req = [NSURLRequest HTTPRequestWithURL:URL
                                                  method:[via uppercaseString]
                                              parameters:params];
    
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
                              [result[@"farm"] intValue],
                              [result[@"server"] intValue],
                              [result[@"id"] intValue],
                              result[@"secret"]];
        NSURL *URL = [NSURL URLWithString:photoURL];
        
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

@end
