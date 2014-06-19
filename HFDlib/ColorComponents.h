//
//  ColorComponents.h
//  WiDMX
//
//  Created by Sean K. Parker on 11/14/10.
//  Copyright 2010 LiteGear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorComponents : NSObject {

}

+ (CGFloat) GetRedFromUIColor:(UIColor *)color;
+ (CGFloat) GetGreenFromUIColor:(UIColor *)color;
+ (CGFloat) GetBlueFromUIColor:(UIColor *)color;
+ (CGFloat) GetAlphaFromUIColor:(UIColor *)color;

+ (UInt8) GetColorByteFromWeight:(CGFloat)weight;

+(UIColor *) MixColor:(UIColor *)color withColor:(UIColor *)otherColor;
+(UIColor *) MixColor:(UIColor *)color withColor:(UIColor *)otherColor withWeight:(CGFloat)weight;

+(UIColor *) MixColor1:(UIColor *)color1 withWeight:(CGFloat)weight1
			withColor2:(UIColor *)color2 withWeight2:(CGFloat)weight2
			withColor3:(UIColor *)color3 withWeight3:(CGFloat)weight3;

@end
