//
//  WAEFlickrHelper.h
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/21/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "WAEConstants.h"

@interface WAEFlickrHelper : NSObject

+ (void)requestFlickrApiWithFlickrMethod:(NSString *)flickrMethod
                                     via:(NSString *)via
                          withParameters:(NSDictionary *)params
                                andBlock:(WAERequestCompletionResultBlock)block;

+ (void)getRandomPhotoDataFromFlickrWithParameters:(NSDictionary *)params andBlock:(WAERequestCompletionResultBlock)block;
+ (void)getRandomPhotoURLFromFlickrWithParameters:(NSDictionary *)params andBlock:(WAERequestCompletionResultBlock)block;
+ (void)getRandomPhotoFromFlickrWithParameters:(NSDictionary *)params andBlock:(WAERequestCompletionResultBlock)block;

@end
