//
//  HFDPacket.h
//  WiDMX
//
//  Created by Sean K. Parker on 11/21/10.
//  Copyright 2010 LiteGear. All rights reserved.
//

#include "HFDTypes.h"

@interface HFDPacket : NSObject {	
	Byte _Buffer[4];
}

@property(assign) HFDCommand Command;
@property(assign) NSInteger Address;
@property(assign) Byte Data1;
@property(assign) Byte Data2;
@property(assign) Byte Data3;

-(id) init;
-(id) initWithBytes:(Byte*)bytes length:(NSUInteger)length;

-(Byte*) getBytes;
+(NSInteger) ByteSize;

@end
