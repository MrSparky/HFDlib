//
//  ColorComponentsTestCase.m
//  HFDlib
//
//  Created by Sean Parker on 6/9/14.
//  Copyright (c) 2014 LiteGear. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ColorComponents.h"

@interface ColorComponentsTestCase : XCTestCase

@end

@implementation ColorComponentsTestCase

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testGetRedFromUIColor
{
    CGFloat red = [ColorComponents GetRedFromUIColor:[UIColor redColor]];
    XCTAssertEqual(red, 1.0, @"Red Component");
    
    red = [ColorComponents GetRedFromUIColor:[UIColor greenColor]];
    XCTAssertEqual(red, 0.0, @"Red Component");
    
    red = [ColorComponents GetRedFromUIColor:[UIColor yellowColor]];
    XCTAssertEqual(red, 1.0, @"Red Component");
    
    red = [ColorComponents GetRedFromUIColor:[UIColor magentaColor]];
    XCTAssertEqual(red, 1.0, @"Red Component");
    
    red = [ColorComponents GetRedFromUIColor:[UIColor grayColor]];
    XCTAssertEqual(red, 0.5, @"Red Component");
}

-(void)testGetGreenFromUIColor
{
    CGFloat grn = [ColorComponents GetGreenFromUIColor:[UIColor greenColor]];
    XCTAssertEqual(grn, 1.0, @"Green Component");
    
    grn = [ColorComponents GetGreenFromUIColor:[UIColor blueColor]];
    XCTAssertEqual(grn, 0.0, @"Green Component");
    
    grn = [ColorComponents GetGreenFromUIColor:[UIColor yellowColor]];
    XCTAssertEqual(grn, 1.0, @"Green Component");
    
    grn = [ColorComponents GetGreenFromUIColor:[UIColor cyanColor]];
    XCTAssertEqual(grn, 1.0, @"Green Component");
    
    grn = [ColorComponents GetGreenFromUIColor:[UIColor grayColor]];
    XCTAssertEqual(grn, 0.5, @"Green Component");
}

-(void)testGetBlueFromUIColor
{
    CGFloat blu = [ColorComponents GetBlueFromUIColor:[UIColor blueColor]];
    XCTAssertEqual(blu, 1.0, @"Blue Component");
    
    blu = [ColorComponents GetBlueFromUIColor:[UIColor redColor]];
    XCTAssertEqual(blu, 0.0, @"Blue Component");

    blu = [ColorComponents GetBlueFromUIColor:[UIColor cyanColor]];
    XCTAssertEqual(blu, 1.0, @"Blue Component");
    
    blu = [ColorComponents GetBlueFromUIColor:[UIColor magentaColor]];
    XCTAssertEqual(blu, 1.0, @"Blue Component");
    
    blu = [ColorComponents GetBlueFromUIColor:[UIColor grayColor]];
    XCTAssertEqual(blu, 0.5, @"Blue Component");
    
}

-(void)testGetAlphaFromUIColor
{
    CGFloat alf = [ColorComponents GetAlphaFromUIColor:[UIColor magentaColor]];
    XCTAssertEqual(alf, 1.0, @"Alpha Component");

    alf = [ColorComponents GetAlphaFromUIColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]];
    XCTAssertEqual(alf, 0.5, @"Alpha Component");
    
    alf = [ColorComponents GetAlphaFromUIColor:[UIColor colorWithRed:0.1 green:0.25 blue:05 alpha:0.0]];
    XCTAssertEqual(alf, 0.0, @"Alpha Component");
    
    alf = [ColorComponents GetAlphaFromUIColor:[UIColor grayColor]];
    XCTAssertEqual(alf, 1.0, @"Alpha Component");

}

@end
