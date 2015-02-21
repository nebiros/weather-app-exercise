//
//  WAEOpenWeatherMapHelper.m
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/21/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

#import "WAEOpenWeatherMapHelper.h"

#import "JIMEnvironments.h"
#import <FXKeychain/FXKeychain.h>

#import "WAERequestsHelper.h"

@implementation WAEOpenWeatherMapHelper

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
    
    WAETemperatureUnit temperature = [[FXKeychain defaultKeychain][kWAEConfigTemperature] integerValue];    
    if (temperature == WAETemperatureUnitFahrenheit) {
        [p setObject:kWAEOpenWeatherMapApiTemperatureUnitImperial forKey:kWAEOpenWeatherMapApiParamUnits];
    } else {
        [p setObject:kWAEOpenWeatherMapApiTemperatureUnitMetric forKey:kWAEOpenWeatherMapApiParamUnits];
    }
    
    NSString *URLAsString = [NSString stringWithFormat:@"%@%@", kWAEOpenWeatherMapApiRestURL, path];
    NSURL *URL = [NSURL URLWithString:URLAsString];
    
    [WAERequestsHelper requestAndSerializeResult:URL via:via withParameters:p andBlock:block];
}

@end
