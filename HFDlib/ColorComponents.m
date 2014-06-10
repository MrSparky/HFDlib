//
//  ColorComponents.m
//  WiDMX
//
//  Created by Sean K. Parker on 11/14/10.
//  Copyright 2010 LiteGear. All rights reserved.
//

#import "ColorComponents.h"


@implementation ColorComponents

+ (CGFloat) GetRedFromUIColor:(UIColor *)color
{
	CGColorRef cgColor = [color CGColor];
	
	size_t numComponents = CGColorGetNumberOfComponents(cgColor);
	
	if (numComponents == 4)
	{
		const CGFloat *components = CGColorGetComponents(cgColor);
		return components[0];
	}
    else if(numComponents == 2)
    {
        const CGFloat *components = CGColorGetComponents(cgColor);
		return components[0];
    }
	return -1;
}

+ (CGFloat) GetGreenFromUIColor:(UIColor *)color
{
	CGColorRef cgColor = [color CGColor];
	
	size_t numComponents = CGColorGetNumberOfComponents(cgColor);
	
	if (numComponents == 4)
	{
		const CGFloat *components = CGColorGetComponents(cgColor);
		return components[1];
	}
    else if(numComponents == 2)
    {
        const CGFloat *components = CGColorGetComponents(cgColor);
		return components[0];
    }

	return -1;
}

+ (CGFloat) GetBlueFromUIColor:(UIColor *)color
{
	CGColorRef cgColor = [color CGColor];
	
	size_t numComponents = CGColorGetNumberOfComponents(cgColor);
	
	if (numComponents == 4)
	{
		const CGFloat *components = CGColorGetComponents(cgColor);
		return components[2];
	}
    else if(numComponents == 2)
    {
        const CGFloat *components = CGColorGetComponents(cgColor);
		return components[0];
    }

	return -1;
}

+ (CGFloat) GetAlphaFromUIColor:(UIColor *)color
{
	CGColorRef cgColor = [color CGColor];
	
	size_t numComponents = CGColorGetNumberOfComponents(cgColor);
	
	if (numComponents == 4)
	{
		const CGFloat *components = CGColorGetComponents(cgColor);
		return components[3];
	}
    else if(numComponents == 2)
    {
        const CGFloat *components = CGColorGetComponents(cgColor);
		return components[1];
    }
	return -1;
}

+ (NSInteger) GetColorByteFromWeight:(CGFloat)weight
{
	return 255 * weight;
}

+(UIColor *) MixColor:(UIColor *)color withColor:(UIColor *)otherColor
{
	return [ColorComponents MixColor:color withColor:otherColor withWeight:0.5];
}

+(UIColor *) MixColor:(UIColor *)color withColor:(UIColor *)otherColor withWeight:(CGFloat)weight
{
	CGFloat red, red1, red2;
	CGFloat green, green1, green2;
	CGFloat blue, blue1, blue2;
	CGFloat alpha, alpha1, alpha2;
	
	CGColorRef cgColor = [color CGColor];
	size_t numComponents = CGColorGetNumberOfComponents(cgColor);
	if (numComponents == 4)
	{
		const CGFloat *components = CGColorGetComponents(cgColor);
		red1 = components[0];
		green1 = components[1];
		blue1 = components[2];
		alpha1 = components[3];
	}
	
	cgColor = [otherColor CGColor];
	numComponents = CGColorGetNumberOfComponents(cgColor);
	if (numComponents == 4)
	{
		const CGFloat *components = CGColorGetComponents(cgColor);
		red2 = components[0];
		green2 = components[1];
		blue2 = components[2];
		alpha2 = components[3];
	}
	
	red = (red1 * weight) + (red2 * (1.0 - weight));
	green = (green1 * weight) + (green2 * (1.0 - weight));
	blue = (blue1 * weight) + (blue2 * (1.0 - weight));
	alpha = (alpha1 * weight) + (alpha2 * (1.0 - weight));
	
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+(UIColor *) MixColor1:(UIColor *)color1 withWeight:(CGFloat)weight1
			withColor2:(UIColor *)color2 withWeight2:(CGFloat)weight2
			withColor3:(UIColor *)color3 withWeight3:(CGFloat)weight3
{
	return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
}

@end
