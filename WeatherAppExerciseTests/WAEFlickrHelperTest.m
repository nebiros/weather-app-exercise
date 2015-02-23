//
//  WAEFlickrHelperTest.m
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/23/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "WAEFlickrHelper.h"

@interface WAEFlickrHelperTest : XCTestCase

@end

@implementation WAEFlickrHelperTest

- (void)testRequestFlickrApiWithFlickrMethodPhotosSearch
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"resultReady"];
    
    [WAEFlickrHelper requestFlickrApiWithFlickrMethod:kWAEFlickrApiMethodPhotosSearch
                                                  via:@"GET"
                                       withParameters:@{kWAEFlickrApiParamText: @"new york, usa"}
                                             andBlock:
     ^(BOOL succeeded, id result, NSError *error) {
         XCTAssertNil(error, "'error' should be nil");
         XCTAssertTrue(succeeded, @"'succeeded' must be YES");
         XCTAssertEqualObjects(result[@"stat"], @"ok", @"'stat' key should be equal to 'ok'");
         
         [expectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:5.f handler:^(NSError *error) {
        XCTAssertNil(error, "'error' should be nil");
    }];
}

- (void)testGetRandomPhotoDataFromFlickrWithParameters
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"resultReady"];
    
    [WAEFlickrHelper getRandomPhotoDataFromFlickrWithParameters:@{kWAEFlickrApiParamText: @"new york, usa"} andBlock:^(BOOL succeeded, id result, NSError *error) {
        XCTAssertNil(error, "'error' should be nil");
        XCTAssertTrue(succeeded, @"'succeeded' must be YES");
        XCTAssertEqual([result allKeys].count, 9, @"should be nine keys");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.f handler:^(NSError *error) {
        XCTAssertNil(error, "'error' should be nil");
    }];
}

- (void)testGetRandomPhotoURLFromFlickrWithParameters
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"resultReady"];
    
    [WAEFlickrHelper getRandomPhotoURLFromFlickrWithParameters:@{kWAEFlickrApiParamText: @"new york, usa"} andBlock:^(BOOL succeeded, id result, NSError *error) {
        XCTAssertNil(error, "'error' should be nil");
        XCTAssertTrue(succeeded, @"'succeeded' must be YES");
        XCTAssertEqualObjects([result class], [NSURL class], @"'result' should be a URL class");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.f handler:^(NSError *error) {
        XCTAssertNil(error, "'error' should be nil");
    }];
}

- (void)testGetRandomPhotoFromFlickrWithParameters
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"resultReady"];
    
    [WAEFlickrHelper getRandomPhotoFromFlickrWithParameters:@{kWAEFlickrApiParamText: @"new york, usa"} andBlock:^(BOOL succeeded, id result, NSError *error) {
        XCTAssertNil(error, "'error' should be nil");
        XCTAssertTrue(succeeded, @"'succeeded' must be YES");
        XCTAssertEqualObjects([result class], [UIImage class], @"'result' should be a UIImage class");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.f handler:^(NSError *error) {
        XCTAssertNil(error, "'error' should be nil");
    }];
}

@end
