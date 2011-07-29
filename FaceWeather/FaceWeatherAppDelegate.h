//
//  FaceWeatherAppDelegate.h
//  FaceWeather
//
//  Created by Toru Inoue on 11/07/27.
//  Copyright 2011 KISSAKI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceWeatherAppDelegate : NSObject <UIApplicationDelegate> {
    UIImageView * iView;//通信が成功するといろいろ表示出来るビュー。
    UIView * failedView;//通信失敗時に表示されるビュー、赤い。
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
