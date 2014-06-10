//
//  HFDPacketTestCase.m
//  HFDlib
//
//  Created by Sean Parker on 6/9/14.
//  Copyright (c) 2014 LiteGear. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HFDPacket.h"

@interface HFDPacketTestCase : XCTestCase

@end

@implementation HFDPacketTestCase

HFDPacket * testPacket;
Byte normBuffer[4];
Byte longBuffer[16];
Byte shortBuffer[2];

- (void)setUp
{
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    testPacket = [[HFDPacket alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    [super tearDown];
}

- (void)testHFDCommand
{
    testPacket.Command = HFDCommandGetStatus;
    XCTAssertEqual(testPacket.Command, HFDCommandGetStatus, @"Get/Set");
    XCTAssertEqual(testPacket.Address, 0, @"Address untouched");
    testPacket.Command = HFDCommandAuthenticate;
    XCTAssertEqual(testPacket.Command, HFDCommandAuthenticate, @"Get/Set");
    testPacket.Command = (HFDCommand)0xFF;
    XCTAssertNotEqual(testPacket.Command, 0xFF, @"Value too large!");
    XCTAssertEqual(testPacket.Address, 0, @"Address untouched");
}

- (void)testAddress
{
    testPacket.Command = HFDCommandSetValue;
    testPacket.Address = 3;
    XCTAssertEqual(testPacket.Address, 3, @"Get/Set");
    XCTAssertEqual(testPacket.Command, HFDCommandSetValue, @"Command untouched");
    testPacket.Address = 7;
    XCTAssertEqual(testPacket.Address, 7, @"Get/Set");
    testPacket.Address = 0xFF;
    XCTAssertNotEqual(testPacket.Address, 0xFF, @"Value too large!");
    XCTAssertEqual(testPacket.Command, HFDCommandSetValue, @"Command untouched");
}

- (void)testData
{
    testPacket.Data1 = 4;
    testPacket.Data2 = 5;
    testPacket.Data3 = 6;
    XCTAssertEqual(testPacket.Data1, 4, @"Data 1");
    XCTAssertEqual(testPacket.Data2, 5, @"Data 2");
    XCTAssertEqual(testPacket.Data3, 6, @"Data 3");
    
    Byte * buffer = [testPacket getBytes];
    XCTAssertNotEqual(buffer, NULL, @"notNULL");
    XCTAssertEqual(buffer[1], 4, @"Buffer 1");
    XCTAssertEqual(buffer[2], 5, @"Buffer 2");
    XCTAssertEqual(buffer[3], 6, @"Buffer 3");
}

- (void)testInit
{
    shortBuffer[0] = 0xDE;
    shortBuffer[1] = 0xAD;
    
    normBuffer[0] = 0x12;
    normBuffer[1] = 0x34;
    normBuffer[2] = 0x56;
    normBuffer[3] = 0x78;
    
    longBuffer[0] = 0x00;
    longBuffer[1] = 0x11;
    longBuffer[2] = 0x22;
    longBuffer[3] = 0x33;
    longBuffer[4] = 0x44;
    longBuffer[5] = 0x55;
    longBuffer[6] = 0x66;
    longBuffer[7] = 0x77;
    longBuffer[8] = 0x88;
    longBuffer[9] = 0x99;
    longBuffer[10] = 0xAA;
    longBuffer[11] = 0xBB;
    longBuffer[12] = 0xCC;
    longBuffer[13] = 0xDD;
    longBuffer[14] = 0xEE;
    longBuffer[15] = 0xFF;
    
    // Valid Buffer and Length
    testPacket = [testPacket initWithBytes:normBuffer length:[HFDPacket ByteSize]];
    XCTAssertEqual(testPacket.Data1, 0x34, @"Data 1");
    XCTAssertEqual(testPacket.Data2, 0x56, @"Data 2");
    XCTAssertEqual(testPacket.Data3, 0x78, @"Data 3");
    
    // Valid Buffer, Valid Length
    testPacket = [testPacket initWithBytes:longBuffer length:[HFDPacket ByteSize]];
    XCTAssertEqual(testPacket.Data1, 0x11, @"Data 1");
    XCTAssertEqual(testPacket.Data2, 0x22, @"Data 2");
    XCTAssertEqual(testPacket.Data3, 0x33, @"Data 3");
    
    // Invalid Short Length (asserts)
    //XCTAssertThrows(testPacket = [testPacket initWithBytes:shortBuffer length:2], @"Short Buffer");
    //XCTAssertEqual(testPacket.ByteSize, 2, @"ByteSize");
    
    // Valid Buffer, Invalid Length
    testPacket = [testPacket initWithBytes:normBuffer length:9];
    XCTAssertEqual(testPacket.Data1, 0x34, @"Data 1");
    XCTAssertEqual(testPacket.Data2, 0x56, @"Data 2");
    XCTAssertEqual(testPacket.Data3, 0x78, @"Data 3");
    
    // Valid Buffer, Long Length
    testPacket = [testPacket initWithBytes:longBuffer length:16];
    XCTAssertEqual(testPacket.Data1, 0x11, @"Data 1");
    XCTAssertEqual(testPacket.Data2, 0x22, @"Data 2");
    XCTAssertEqual(testPacket.Data3, 0x33, @"Data 3");

}

@end
