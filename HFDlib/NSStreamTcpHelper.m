//
//  NSStreamTcpHelper.m
//  WiDMX
//
//  Created by Sean K. Parker on 11/20/10.
//  Copyright 2010 LiteGear. All rights reserved.
//

#import "NSStreamTcpHelper.h"

@implementation NSStream (NSStreamTcpHelper)

+ (void)getStreamsToHostNamed:(NSString *)hostName 
						 port:(NSInteger)port 
				  inputStream:(NSInputStream **)inputStreamPtr 
				 outputStream:(NSOutputStream **)outputStreamPtr
{
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
	
    assert(hostName != nil);
    assert( (port > 0) && (port < 65536) );
    assert( (inputStreamPtr != NULL) || (outputStreamPtr != NULL) );
	
    CFStreamCreatePairWithSocketToHost(NULL, 
									   (CFStringRef) hostName, 
									   (UInt32)port,
									   ((inputStreamPtr  != nil) ? &readStream : NULL),
									   ((outputStreamPtr != nil) ? &writeStream : NULL)
									   );
	
    if (inputStreamPtr != NULL) {
        *inputStreamPtr  = [NSMakeCollectable(readStream) autorelease];
    }
    if (outputStreamPtr != NULL) {
        *outputStreamPtr = [NSMakeCollectable(writeStream) autorelease];
    }
}

@end