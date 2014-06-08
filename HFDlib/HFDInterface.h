//
//  HFDInterface.h
//  WiDMX
//
//  Created by Sean K. Parker on 11/15/10.
//  Copyright 2010 LiteGear. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "HFDTypes.h"

@class HFDPacket;
@protocol HFDIfDelegate;

@interface HFDInterface : NSObject <NSStreamDelegate> {
	NSString * IpAddress;
	NSString * Password;
	NSInteger PortNumber;
	BOOL awaitingAuth;

	HFDState ConnectionState;
	
	NSInputStream *inStream;
	NSOutputStream *outStream;
	
	NSMutableArray *outPackets;
	
	id <HFDIfDelegate> delegate;
}

@property(nonatomic, retain, readonly) NSString * IpAddress;
@property(assign, readonly) NSInteger PortNumber;
@property(assign, readonly) HFDState ConnectionState;
@property(nonatomic, strong) NSInputStream * inStream;
@property(nonatomic, strong) NSOutputStream * outStream;
@property(nonatomic, retain) 	id <HFDIfDelegate> delegate;

-(id) init;

-(BOOL) connectToIpAddress:(NSString *)Address onPort:(NSInteger)Port withPassword:(NSString *)password;
-(BOOL) connectToIpAddress:(NSString *)Address onPort:(NSInteger)Port;

-(BOOL) setValueAt:(NSInteger)index toValue:(NSInteger)val;
-(BOOL) setValueAt:(NSInteger)index toMix1:(NSInteger)val1 and2:(NSInteger)val2;
-(BOOL) setValueAt:(NSInteger)index toColor:(UIColor *)color;

-(BOOL) sendPacket:(HFDPacket *)packet;

-(void) disconnect;

/* Private Methods */

-(BOOL) connect;

-(void) stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode;

-(void) processInStreamEvent:(NSStreamEvent)eventCode;
-(void) processOutStreamEvent:(NSStreamEvent)eventCode;

-(void) onStateChanged:(HFDState)state;
-(void) onDataReceived:(Byte*)data ofSize:(NSInteger)count;

@end

@protocol HFDIfDelegate
-(void) interface:(HFDInterface*)iface stateChanged:(HFDState)state;
-(void) interface:(HFDInterface*)iface receivedData:(Byte*)data ofSize:(NSInteger)count;
@end

