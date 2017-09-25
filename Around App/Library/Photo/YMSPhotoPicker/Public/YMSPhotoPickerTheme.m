//
//  YMSPhotoPickerTheme.m
//  YangMingShan
//
//  Copyright 2016 Yahoo Inc.
//  Licensed under the terms of the BSD license. Please see LICENSE file in the project root for terms.
//

#import "YMSPhotoPickerTheme.h"

@implementation UIColor (YMSPhotoPickerTheme)

+ (UIColor *)systemBlueColor
{
    static UIColor *systemBlueColor = nil;
    if (!systemBlueColor) {
        systemBlueColor = [UIColor whiteColor];
    }
    return systemBlueColor;
}

@end

@implementation YMSPhotoPickerTheme

+ (instancetype)sharedInstance
{
    static YMSPhotoPickerTheme *instance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[YMSPhotoPickerTheme alloc] init];
        [instance reset];
    });
    return instance;
}

- (void)reset
{
    self.tintColor = self.orderTintColor = self.cameraVeilColor = [UIColor systemBlueColor];
    self.orderLabelTextColor = self.navigationBarBackgroundColor = self.cameraIconColor = [UIColor whiteColor];
    self.titleLabelTextColor = [UIColor whiteColor];
    self.statusBarStyle = UIStatusBarStyleDefault;
   // lblOnline.font = UIFont(name: "OpenSans-Semibold", size: 14)
    self.titleLabelFont = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
    self.albumNameLabelFont = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
    self.photosCountLabelFont = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
    self.selectionOrderLabelFont = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    
    
    
}

@end
