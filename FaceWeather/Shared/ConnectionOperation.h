//
//  ConnectionOperation.h
//  QlippyPlugin
//
//  Created by Toru Inoue on 11/02/02.
//  Copyright 2011 KISSAKI. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MessengerSystem.h"



#define CONNECTION_STATUS_SUCCEEDED	(@"CONNECTION_STATUS_SUCCEEDED")
#define CONNECTION_STATUS_FAILURE	(@"CONNECTION_STATUS_FAILURE")


@interface ConnectionOperation : NSObject {
	NSString * m_sentID;
	NSMutableData * m_data;
	
//	MessengerSystem * messenger;
	NSString * m_connectionName;
}

- (id) initConnectionOperationWithID:(NSString * )sentID withMasterName:(NSString * )parentName;
- (void) startConnect:(NSURLRequest * )request withConnectionName:(NSString * )connectionName;

@end
