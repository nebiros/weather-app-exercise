//
//  WAEOpenWeatherMapHelperTest.m
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/23/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "WAEOpenWeatherMapHelper.h"

@interface WAEOpenWeatherMapHelperTest : XCTestCase

@end

@implementation WAEOpenWeatherMapHelperTest

- (void)testRequestOpenWeatherMapApiWithWeatherPath
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"resultReady"];
    
    [WAEOpenWeatherMapHelper requestOpenWeatherMapApiWithPath:kWAEOpenWeatherMapApiRestWeatherPath
                                                          via:@"GET"
                                               withParameters:@{kWAEOpenWeatherMapApiParamQuery: @"new york, usa"}
                                                     andBlock:
     ^(BOOL succeeded, id result, NSError *error) {
         XCTAssertNil(error, "'error' should be nil");
         XCTAssertTrue(succeeded, @"'succeeded' must be YES");
         XCTAssertNotNil(result[@"coord"], @"'coord' key should not be nil");
         
         [expectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:5.f handler:^(NSError *error) {
        XCTAssertNil(error, "'error' should be nil");
    }];
}

@end
