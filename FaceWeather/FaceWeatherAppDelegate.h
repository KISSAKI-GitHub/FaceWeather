//
//  FaceWeatherAppDelegate.h
//  FaceWeather
//
//  Created by Toru Inoue on 11/07/27.
//  Copyright 2011 KISSAKI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceWeatherAppDelegate : NSObject <UIApplicationDelegate> {
    UIImageView * iView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
