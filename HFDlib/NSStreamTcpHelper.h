//
//  NSStreamTcpHelper.h
//  WiDMX
//
//  Created by Sean K. Parker on 11/20/10.
//  Copyright 2010 LiteGear. All rights reserved.
//

@interface NSStream (NSStreamTcpHelper)

+ (void)getStreamsToHostNamed:(NSString *)hostName 
						 port:(NSInteger)port 
				  inputStream:(NSInputStream * __strong *) inputStreamPtr
				 outputStream:(NSOutputStream * __strong *) outputStreamPtr;

@end

