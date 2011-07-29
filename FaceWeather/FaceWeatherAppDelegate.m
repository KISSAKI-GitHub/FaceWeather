//
//  FaceWeatherAppDelegate.m
//  FaceWeather
//
//  Created by Toru Inoue on 11/07/27.
//  Copyright 2011 KISSAKI. All rights reserved.
//

#import "FaceWeatherAppDelegate.h"

#import "FaceWeatherViewController.h"

#import "ConnectionOperation.h"

#import "LBXMLParserController.h"


/**
 AppDelegate:アプリケーションの全ての権限がある場所→アプリケーションのスタートポイント。
 起動したらまず、このファイルのメソッドが呼ばれる。
 */
@implementation FaceWeatherAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIView * baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height)];
    [self.window addSubview:baseView];
    
    
    iView = [[UIImageView alloc]initWithFrame:CGRectMake(self.window.frame.origin.x, self.window.frame.origin.y, self.window.frame.size.width, self.window.frame.size.height)];
    [baseView addSubview:iView];
    
    
    failedView = [[UIView alloc]initWithFrame:CGRectMake(self.window.frame.origin.x, self.window.frame.origin.y, self.window.frame.size.width, self.window.frame.size.height/10)];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapped:) name:@"BUTTON_TAPPED" object:nil];
    
    FaceWeatherViewController * fWeatherViewCont = [[FaceWeatherViewController alloc]init];
    
    [baseView addSubview:fWeatherViewCont.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}



/**
 ボタンが押されたのを受け取って、通信→通信結果をとってくる
 */
- (void) tapped:(NSNotification * )notif {
    NSDictionary * dict = (NSDictionary * )[notif userInfo];
    NSAssert([dict valueForKey:@"placeNumber"], @"placeNumber required");
    
    
    [iView setBackgroundColor:[UIColor blackColor]];
    [failedView removeFromSuperview];
    
    
    ConnectionOperation * cOperation = [[ConnectionOperation alloc] initConnectionOperationWithID:@"concurrent" withMasterName:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(success:) name:@"ANSWER_SUCCEEDED" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(failure:) name:@"ANSWER_FAILURE" object:nil];
    
    
    NSString * urlString = [NSString stringWithFormat:@"http://weather.livedoor.com/forecast/webservice/rest/v1?city=46&day=today", [dict valueForKey:@"placeNumber"]];
    
    NSMutableURLRequest * currentRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
	[currentRequest setHTTPMethod:@"GET"];
	
    [cOperation startConnect:currentRequest withConnectionName:@"connectionName"];
}



/**
 通信結果、成功
 */
- (void) success:(NSNotification * )notif {
    NSLog(@"通信成功！");
    NSDictionary * dict = (NSDictionary * )[notif userInfo];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(color:) name:@"WEATHER_NUMBER" object:nil];
    
    LBXMLParserController * lBXmlParsCont = [[LBXMLParserController alloc]initLBXMLParserController];
    [lBXmlParsCont lBXMLParserControlCenter:[dict valueForKey:@"data"]];
}


/**
 通信結果、失敗
 */
- (void) failure:(NSNotification * )notif {
    NSLog(@"通信失敗！");
    
    [self.window addSubview:failedView];
}



/**
 解析したXMLから結果の数値を取り出して、天気の表示へ。
 */
- (void) color:(NSNotification * )notif {
    NSDictionary * dict = (NSDictionary * )[notif userInfo];
    NSString * numStr = [dict valueForKey:@"numStr"];
    
    
    int num = [numStr intValue];
    
    /*
     1 〜 7 は 晴れ
     8 〜 14 は曇り
     15 〜 22 は 雨
     23 〜 30 は 雪
     */
    
    [iView setBackgroundColor:[UIColor blackColor]];
    
    
    if (1 <= num && num <= 7) {
        [iView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fair" ofType:@"png"]]];
    }
    if (8 <= num && num <= 14) {
        [iView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cloudy" ofType:@"png"]]];
    }
    if (15 <= num && num <= 22) {
        [iView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rain" ofType:@"png"]]];
    }
    if (23 <= num && num <= 30) {
        [iView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"snow" ofType:@"png"]]];
    }
    [iView setAlpha:0.0];
    [UIView beginAnimations:@"appear" context:iView];
    [iView setAnimationDuration:2.0];
    [iView setAlpha:1.0];
    [UIView commitAnimations];
}





- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
