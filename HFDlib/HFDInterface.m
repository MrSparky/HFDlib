//
//  HFDInterface.m
//  WiDMX
//
//  Created by Sean K. Parker on 11/15/10.
//  Copyright 2010 LiteGear. All rights reserved.
//

#import "HFDInterface.h"
#import "ColorComponents.h"
#import "HFDPacket.h"
#import "NSStreamTcpHelper.h"

@implementation HFDInterface

@synthesize IpAddress;
@synthesize PortNumber;
@synthesize ConnectionState;
@synthesize delegate;
@synthesize inStream;
@synthesize outStream;

-(id) init 
{
	if(self = [super init])
	{
		IpAddress = NULL;
		Password = NULL;
		PortNumber = 0;
		ConnectionState = HFDStateDisconnected;
		outPackets = [[NSMutableArray alloc] initWithCapacity:16];
	}
	
	return self;
}

-(BOOL) connectToIpAddress:(NSString *)Address onPort:(NSInteger)Port withPassword:(NSString *)password
{
	if(ConnectionState != HFDStateDisconnected)
		return NO;
	
	IpAddress = Address;
	PortNumber = Port;
	Password = password;
	ConnectionState = HFDStateConnecting;
	awaitingAuth = YES;
	[self onStateChanged:ConnectionState];
	
	return [self connect];
}

-(BOOL) connectToIpAddress:(NSString *)Address onPort:(NSInteger)Port
{
	if(ConnectionState != HFDStateDisconnected)
		return NO;
	
	IpAddress = Address;
	PortNumber = Port;
	ConnectionState = HFDStateConnecting;
	awaitingAuth = YES;
	[self onStateChanged:ConnectionState];
	
	return [self connect];
}

-(BOOL) setValueAt:(NSInteger)index toValue:(NSInteger)val
{
	if( ConnectionState == HFDStateDisconnected || 
	   [outStream streamStatus] == NSStreamStatusNotOpen)
		return NO;
	
	HFDPacket * packet = [[HFDPacket alloc] init];
	
	packet.Address = index;
	packet.Command = HFDCommandSetValue;
	packet.Data1 = val;
	
	if([outStream hasSpaceAvailable])
	{
		[outStream write:[packet getBytes] maxLength:[HFDPacket ByteSize]];
	}else{
		[outPackets addObject:packet];
	}
	
	return YES;
}

-(BOOL) setValueAt:(NSInteger)index toMix1:(NSInteger)val1 and2:(NSInteger)val2
{
	if( ConnectionState == HFDStateDisconnected ||
	   [outStream streamStatus] == NSStreamStatusNotOpen)
		return NO;
	
	HFDPacket * packet = [[HFDPacket alloc] init];
	
	packet.Address = index;
	packet.Command = HFDCommandSetValue;
	packet.Data1 = val1;
	packet.Data2 = val2;
	
	if([outStream hasSpaceAvailable])
	{
		[outStream write:[packet getBytes] maxLength:[HFDPacket ByteSize]];
	}else{
		[outPackets addObject:packet];
	}
	
	return YES;
}

-(BOOL) setValueAt:(NSInteger)index toColor:(UIColor *)color
{
	if( ConnectionState == HFDStateDisconnected ||
	   [outStream streamStatus] == NSStreamStatusNotOpen)
		return NO;
	
	HFDPacket * packet = [[HFDPacket alloc] init];
	
	packet.Address = index;
	packet.Command = HFDCommandSetValue;
	packet.Data1 = [ColorComponents GetRedFromUIColor:color] * 255;
	packet.Data2 = [ColorComponents GetGreenFromUIColor:color] * 255;
	packet.Data3 = [ColorComponents GetBlueFromUIColor:color] * 255;
	
	if([outStream hasSpaceAvailable])
	{
		[outStream write:[packet getBytes] maxLength:[HFDPacket ByteSize]];
	}else{
		[outPackets addObject:packet];
	}
	
	return YES;
}

-(BOOL) sendPacket:(HFDPacket *)packet;
{
	if([outStream hasSpaceAvailable])
	{
		[outStream write:[packet getBytes] maxLength:[HFDPacket ByteSize]];
	}else {
		[outPackets addObject:packet];
	}
	return YES;

}

-(void) disconnect
{
	if(ConnectionState != HFDStateDisconnected)
	{
		ConnectionState = HFDStateDisconnected;
		awaitingAuth = NO;
		
		[inStream close];
		[outStream close];
		
		[inStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[outStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	}
}

#pragma mark Helper Methods

-(BOOL) connect
{
	[NSStream getStreamsToHostNamed:IpAddress 
							   port:PortNumber 
						inputStream:&inStream
					   outputStream:&outStream];
	
	if(inStream == nil || outStream == nil)
	{
		ConnectionState = HFDStateDisconnected;
		[self onStateChanged:ConnectionState];
		return NO;
	}
    
	[inStream setDelegate:self];
	[outStream setDelegate:self];
	
	[inStream scheduleInRunLoop:[NSRunLoop currentRunLoop] 
						forMode:NSDefaultRunLoopMode];
	
	[outStream scheduleInRunLoop:[NSRunLoop currentRunLoop] 
						 forMode:NSDefaultRunLoopMode];
	
	[inStream open];
	[outStream open];
	
	return YES;
}

-(void) stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{
    if(stream == inStream)
		[self processInStreamEvent:eventCode];
	else if(stream == outStream)
		[self processOutStreamEvent:eventCode];

}

-(void) processInStreamEvent:(NSStreamEvent)eventCode
{
	Byte Buffer[100];
	switch (eventCode) {
		case NSStreamEventHasBytesAvailable:
			// Read in bytes
			while([inStream hasBytesAvailable])
			{
				NSInteger bytesRead = [inStream read:Buffer maxLength:100];
				[self onDataReceived:Buffer ofSize:bytesRead];
			}
			break;
		case NSStreamEventOpenCompleted:
			ConnectionState = HFDStateConnected;
			[self onStateChanged:ConnectionState];
			break;
		case NSStreamEventEndEncountered:
			ConnectionState = HFDStateDisconnected;
			[self onStateChanged:ConnectionState];
			break;
		case NSStreamEventErrorOccurred:
			NSLog(@"InStream Error (%@): %@", [inStream streamError], [[inStream streamError] userInfo]);
			if([inStream streamStatus] == NSStreamStatusClosed ||
			  [inStream streamStatus] == NSStreamStatusError)
			{
				ConnectionState = HFDStateDisconnected;
				[self onDataReceived:(Byte*)"\nConnection Error!" ofSize:18];
				[self onStateChanged:ConnectionState];
			}
			break;
        default:
            // Unknown event
            NSLog(@"InStream attempted to handle unknown event %lu", (unsigned long)eventCode);
            break;
	}
}

-(void) processOutStreamEvent:(NSStreamEvent)eventCode
{
	switch(eventCode) {
        case NSStreamEventHasSpaceAvailable:
        {
            while([outPackets count] > 0)
			{
				HFDPacket *pPacket = (HFDPacket*)[outPackets objectAtIndex:0];
				[outStream write:[pPacket getBytes] maxLength:[HFDPacket ByteSize]];
				[outPackets removeObjectAtIndex:0];
			}
			break;
        }
		case NSStreamEventOpenCompleted:
			ConnectionState = HFDStateConnected;
			[self onStateChanged:ConnectionState];
			break;
		case NSStreamEventEndEncountered:
			ConnectionState = HFDStateDisconnected;
			[self onStateChanged:ConnectionState];
			break;
		case NSStreamEventErrorOccurred:
			NSLog(@"OutStream Error (%@): %@", [outStream streamError], [[outStream streamError] userInfo]);
			if([outStream streamStatus] == NSStreamStatusClosed ||
			  [outStream streamStatus] == NSStreamStatusError)
			{
				ConnectionState = HFDStateDisconnected;
				[self onStateChanged:ConnectionState];
			}
			break;
        default:
            // Unknown event
            NSLog(@"Outsteam attempted to handle unknown event %lu", (unsigned long)eventCode);
            break;
    }
}

-(void) onStateChanged:(HFDState)state
{
	[delegate interface:self stateChanged:state];
}

-(void) onDataReceived:(Byte*)data ofSize:(NSInteger)count
{
	if(awaitingAuth && count >= 4)
	{
		if(data[0] == 0x23 && data[1] == 0x48 &&
		  data[2] == 0x46 && data[3] == 0x44)
		{
			HFDPacket *pPacket = [[HFDPacket alloc] init];
			pPacket.Address = 0;
			pPacket.Command = HFDCommandSetMode;
			pPacket.Data1 = HFDModeNormal;
			pPacket.Data2 = 3;
			pPacket.Data3 = 4;
			
			[self sendPacket:pPacket];
			awaitingAuth = NO;
		}
	}
	
	[delegate interface:self receivedData:data ofSize:count];
}

@end
