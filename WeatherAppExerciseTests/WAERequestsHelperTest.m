//
//  WAERequestsHelperTest.m
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/23/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "WAERequestsHelper.h"

@interface WAERequestsHelperTest : XCTestCase

@end

@implementation WAERequestsHelperTest

- (void)testRequestViaGet
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"resultReady"];
    
    NSURL *URL = [NSURL URLWithString:@"http://juan.im"];
    [WAERequestsHelper request:URL via:@"GET" withParameters:@{} andBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSData *data, NSError *connectionError) {
        XCTAssertNil(connectionError, "'connectionError' should be nil");
        XCTAssertFalse((response.statusCode > 300), "'statusCode, %ld' seems like an error", (long)response.statusCode);
        XCTAssertNotNil(data, "'data' can't be nil");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.f handler:^(NSError *error) {
        XCTAssertNil(error, "'error' should be nil");
    }];
}

- (void)testRequestAndSerializeResult
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"resultReady"];
    
    NSURL *URL = [NSURL URLWithString:kWAEExerciseCitiesURL];
    [WAERequestsHelper requestAndSerializeResult:URL via:@"GET" withParameters:nil andBlock:^(BOOL succeeded, id result, NSError *error) {
        XCTAssertNil(error, "'error' should be nil");
        XCTAssertTrue(succeeded, @"'succeeded' must be YES");
        XCTAssertEqual([result allKeys].count, 1, @"should be just one key");
        XCTAssertEqual(((NSArray *) result[@"cities"]).count, 7, @"should be seven cities");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.f handler:^(NSError *error) {
        XCTAssertNil(error, "'error' should be nil");
    }];
}

@end
