//
//  MeetMeUpTests.m
//  MeetMeUpTests
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Event.h"

@interface MeetMeUpTests : XCTestCase

@end

@implementation MeetMeUpTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAttendanceCountIncrement
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for comments to return"];
    [Event performSearchWithKeyword:@"mobile" andComplete:^(NSArray *events) {
        Event *secondEvent = [events objectAtIndex:1];
        int attendingCount = [[secondEvent RSVPCount] intValue];
        secondEvent.attending = YES;
        XCTAssertEqual(attendingCount++, [[secondEvent RSVPCount] intValue]);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testAttendanceCountDecrement
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for comments to return"];

    [Event performSearchWithKeyword:@"mobile" andComplete:^(NSArray *events) {

        Event *secondEvent = [events objectAtIndex:1];

        secondEvent.attending = YES;
        int attendingCount = [[secondEvent RSVPCount] intValue];
        NSLog(@"Attending Count %d",attendingCount);
        secondEvent.attending = NO;
        NSLog(@"Attending Count %d",attendingCount);
        XCTAssertEqual(attendingCount--, [[secondEvent RSVPCount] intValue]);

        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testAttendanceBooleanManagedProperly
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for comments to return"];

    [Event performSearchWithKeyword:@"mobile" andComplete:^(NSArray *events) {

        Event *secondEvent = [events objectAtIndex:1];

        secondEvent.attending = YES;

        XCTAssertEqual(secondEvent.attending, YES);

        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

-(void)testPerformSearchWithKeyword{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for response for search"];
    
    [Event performSearchWithKeyword:@"mobile" andComplete:^(NSArray *events) {
        XCTAssertEqual(15, events.count);
        [expectation fulfill];

    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}


//Write a unit test that ensures that the second event has only one comment and that that comment was created by a user with an ID of 99045732


-(void)testForCommentNumberAndUserID{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for comments from User 99045732"];
    
    [Event performSearchWithKeyword:@"mobile" andComplete:^(NSArray *events) {
        Event *secondEvent = [events objectAtIndex:1];
        [secondEvent getCommentsWithBlock:^(NSArray *comments) {
            XCTAssert(comments.count == 1);
            Comment *comment = [comments firstObject];
            NSNumber *memberIDNumber = @([@"99045732" intValue]);
            XCTAssert([comment.memberID isEqual: memberIDNumber]);
            [expectation fulfill];
        }];
        
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    
}




@end
