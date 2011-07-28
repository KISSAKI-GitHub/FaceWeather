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

@implementation FaceWeatherAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIView * baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height)];
    [self.window addSubview:baseView];
    
    
    iView = [[UIImageView alloc]initWithFrame:CGRectMake(self.window.frame.origin.x, self.window.frame.origin.y, self.window.frame.size.width, self.window.frame.size.height)];
    [baseView addSubview:iView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapped:) name:@"BUTTON_TAPPED" object:nil];
    
    FaceWeatherViewController * fWeatherViewCont = [[FaceWeatherViewController alloc]init];
    
    [baseView addSubview:fWeatherViewCont.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}


//ボタンが押されたら動く
- (void) tapped:(NSNotification * )notif {
    ConnectionOperation * cOperation = [[ConnectionOperation alloc] initConnectionOperationWithID:@"concurrent" withMasterName:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(success:) name:@"ANSWER_SUCCEEDED" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(failure:) name:@"ANSWER_FAILURE" object:nil];
    
    
    NSMutableURLRequest * currentRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://weather.livedoor.com/forecast/webservice/rest/v1?city=46&day=today"]];
	[currentRequest setHTTPMethod:@"GET"];
	
    [cOperation startConnect:currentRequest withConnectionName:@"connectionName"];
}




- (void) success:(NSNotification * )notif {
    NSLog(@"通信成功！   %@", notif);
    NSDictionary * dict = (NSDictionary * )[notif userInfo];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(color:) name:@"WEATHER_NUMBER" object:nil];
    
    LBXMLParserController * lBXmlParsCont = [[LBXMLParserController alloc]initLBXMLParserController];
    [lBXmlParsCont lBXMLParserControlCenter:[dict valueForKey:@"data"]];
    
    
}

- (void) failure:(NSNotification * )notif {
    NSLog(@"通信失敗！   %@", notif);
    UIView * failedView = [[UIView alloc]initWithFrame:CGRectMake(self.window.frame.origin.x, self.window.frame.origin.y, self.window.frame.size.width, self.window.frame.size.height/10)];
    [failedView setBackgroundColor:[UIColor redColor]];
    [self.window addSubview:failedView];
}




- (void) color:(NSNotification * )notif {
    NSDictionary * dict = (NSDictionary * )[notif userInfo];
    NSString * numStr = [dict valueForKey:@"numStr"];
    
    
    int num = [numStr intValue];
    
    /*
     1.gif 〜 7.gif は 晴れ
     8.gif 〜 14.gif は曇り
     15.gif 〜 22.gif は 雨
     23.gif 〜 30.gif は 雪
     */
    
    [iView setBackgroundColor:[UIColor blackColor]];
    
    
    if (1 <= num && num <= 7) {
        [iView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fair" ofType:@"png"]]];// = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:@"fair.png"]];
    }
    if (8 <= num && num <= 14) {
        [iView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cloudy" ofType:@"png"]]];// = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:@"fair.png"]];
    }
    if (15 <= num && num <= 22) {
        [iView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rain" ofType:@"png"]]];// = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:@"fair.png"]];
    }
    if (23 <= num && num <= 30) {
        [iView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"snow" ofType:@"png"]]];// = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:@"fair.png"]];
    }
    
   // [self.window addSubview:iView];
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
