//
//  HFDPacket.m
//  WiDMX
//
//  Created by Sean K. Parker on 11/21/10.
//  Copyright 2010 LiteGear. All rights reserved.
//

#import "HFDPacket.h"


@implementation HFDPacket

@dynamic Command;
@dynamic Address;
@dynamic Data1;
@dynamic Data2;
@dynamic Data3;

-(id) init
{
	if(self = [super init])
	{
        // Clear Buffer data
        for (int i = 0; i < 4; i++) {
            _Buffer[i] = 0;
        }
	}
	return self;
}

-(id) initWithBytes:(Byte*)bytes length:(NSUInteger)length
{
    assert(bytes != NULL);
    assert(length >= 4);
    
	if(self = [super init])
	{
		for(int i = 0; i < 4; i++)
		{
			_Buffer[i] = bytes[i];
		}
	}
	return self;
}

-(HFDCommand) Command
{
    return (HFDCommand)(_Buffer[0] & 0x07);
}

-(void) setCommand:(HFDCommand)Command
{
    _Buffer[0] &= 0xF8;
    _Buffer[0] |= (Byte)Command;
}

-(NSInteger) Address
{
    return (_Buffer[0] & 0xF8) >> 3;
}

-(void) setAddress:(NSInteger)Address
{
    _Buffer[0] &= 0x07;
    _Buffer[0] |= ((Byte)Address | 0xF8) << 3;
}

-(Byte) Data1
{
    return _Buffer[1];
}

-(void) setData1:(Byte)Data1
{
    _Buffer[1] = Data1;
}

-(Byte) Data2
{
    return _Buffer[2];
}

-(void) setData2:(Byte)Data2
{
    _Buffer[2] = Data2;
}

-(Byte) Data3
{
    return _Buffer[3];
}

-(void) setData3:(Byte)Data3
{
    _Buffer[3] = Data3;
}

-(Byte*) getBytes
{
	return _Buffer;
}

+(NSInteger) ByteSize{ return 4; }

@end
