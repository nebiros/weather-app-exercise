//
//  WAEOpenWeatherMapHelper.h
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/21/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

@import Foundation;

#import "WAEConstants.h"

@interface WAEOpenWeatherMapHelper : NSObject

+ (void)requestOpenWeatherMapApiWithPath:(NSString *)path
                                     via:(NSString *)via
                          withParameters:(NSDictionary *)params
                                andBlock:(WAERequestCompletionResultBlock)block;

@end
