//
//  HFDTypes.h
//  HFDlib
//
//  Created by Sean Parker on 6/8/14.
//  Copyright (c) 2010 LiteGear. All rights reserved.
//

#ifndef HFDlib_HFDTypes_h
#define HFDlib_HFDTypes_h

typedef enum {
	HFDStateDisconnected,
	HFDStateConnecting,
	HFDStateConnected,
} HFDState;

typedef enum
{
	HFDCommandInvalid      = 0,
	HFDCommandSetMode      = 1,
	HFDCommandSetValue     = 2,
	HFDCommandGetStatus    = 3,
	HFDCommandUnused1      = 4,
	HFDCommandUnused2      = 5,
	HFDCommandAuthenticate = 6,
	HFDCommandTuneChannel  = 7,
} HFDCommand;

typedef enum
{
	HFDRequestInvalid,
    // General HFD Requests
	HFDRequestMode = 1,
	HFDRequestTime,
	HFDReserved = 15,
	// Ch. 1 Requests
	HFDRequestCh1Status,
	HFDRequestCh1Current,
	HFDRequestCh1Value,
	HFDRequestCh1Reserved = 31,
	// Ch. 2 Requests
	HFDRequestCh2Status,
	HFDRequestCh2Current,
	HFDRequestCh2Value,
	HFDRequestCh2Reserved = 47,
	// Ch. 3 Requests
	HFDRequestCh3Status,
	HFDRequestCh3Current,
	HFDRequestCh3Value,
	HFDRequestCh3Reserved = 63,
	// End of Requests
	HFDRequestUnused = 255,
} HFDRequest;

typedef enum
{
	HFDModeInvalid = 0,
	HFDModeStandby = 1,
	HFDModeNormal  = 2,
	HFDModeUnused  = 3,
	HFDModeWiFly   = 33,
	
	HFDModeCh1On   = 61, // Ch. Modes
	HFDModeCh2On   = 62,
	HFDModeCh3On   = 63,
	HFDModeCh12On  = 64,
	HFDModeCh23On  = 65,
	HFDModeCh13On  = 66,
	HFDModeCh123On = 69,
	
	HFDModeWhtChase  = 71, // White Modes
	HFDModeWhtFade   = 72,
	HFDModeWhtBounce = 73,
	HFDModeWhtBFade  = 74,
	HFDModeWhtStrobe = 75,
	HFDModeWhtPulse  = 76,
	HFDModeWhtRandom = 77,
	HFDModeWhtWater  = 78,
	HFDModeWhtRsvd   = 79,
	
	HFDModeRgbChase3  = 81, // RGB Modes
	HFDModeRgbFade3   = 82,
	HFDModeRgbChase12 = 83,
	HFDModeRgbChase23 = 84,
	HFDModeRgbChase13 = 85,
	HFDModeRgbFireFlk = 86,
	HFDModeRgbTVFlkr  = 87,
	HFDModeRgbPolice  = 88,
	HFDModeRgbRsvd    = 89
} HFDMode;

typedef enum
{
	HFDChStatusInvalid,
	HFDChStatusOff,
	HFDChStatusShort,
	HFDChStatusOverCurrent,
	HFDChStatusOverTemp,
	HFDChStatusReserved,
	
	HFDChStatusOK = 250,
	HFDChStatusUnused,
} HFDChStatus;

#endif
