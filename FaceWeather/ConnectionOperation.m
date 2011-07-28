//
//  ConnectionOperation.m
//  QlippyPlugin
//
//  Created by Toru Inoue on 11/02/02.
//  Copyright 2011 KISSAKI. All rights reserved.
//

#import "ConnectionOperation.h"
#import "LightBoxConstSetting.h"

@implementation ConnectionOperation



- (id) initConnectionOperationWithID:(NSString * )sentID withMasterName:(NSString * )parentName {
	if ((self = [super init])) {
		messenger = [[MessengerSystem alloc]initWithBodyID:self withSelector:@selector(select:) withName:LB_CONNECTIONS];
		[messenger inputParent:parentName];
		
		m_sentID = [sentID copy];
		m_data = [[NSMutableData alloc]init];
	}
	return self;
}

- (void) select:(NSNotification * )notif {}

- (void) startConnect:(NSURLRequest * )request withConnectionName:(NSString * )connectionName {
	m_connectionName = [[NSString alloc] initWithFormat:@"%@",connectionName];
	NSAssert1([m_connectionName retainCount] == 1, @"not 1	%d", [m_connectionName retainCount]);
	[NSURLConnection connectionWithRequest:request delegate:self];
} 




/*
 connection delegation
 */
- (void) connection:(NSURLConnection * )connection didReceiveData:(NSData * )data {
	[m_data appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection * )connection {
//	NSLog(@"m_connectionName%@", m_connectionName);
//	NSLog(@"connection	%@", connection);
	[messenger callParent:CONNECTION_STATUS_SUCCEEDED,
	 [messenger tag:@"name" val:m_connectionName],
	 [messenger tag:@"receivedID" val:m_sentID],
	 [messenger tag:@"data" val:m_data],
	 nil];
	
	[self release];
}

- (void) connection:(NSURLConnection * )connection didFailWithError:(NSError * )error {
	[messenger callParent:CONNECTION_STATUS_FAILURE,
	 [messenger tag:@"name" val:m_connectionName],
	 [messenger tag:@"receivedID" val:m_sentID],
	 [messenger tag:@"error" val:error],
	 nil];
	
	[self release];
}

- (void) connection:(NSURLConnection * )connection didReceiveResponse:(NSURLResponse * )response {
//	NSHTTPURLResponse * cores = (NSHTTPURLResponse * )response;
//	NSLog(@"cores statusCode				%@", [cores statusCode]);
	//NSLog(@"response suggestedFilename		%@", [response suggestedFilename]);
//	NSLog(@"response expectedContentLength	%l", [response expectedContentLength]);
//	NSLog(@"response url					%@", [response URL]);
//	NSLog(@"response textEncodingName		%@", [response textEncodingName]);
//	NSLog(@"response MIMEType				%@", [response MIMEType]);
}


/**
 NSURLConnectionを使う以上は、deallocはURLConnectionから呼ばれる。
 NSURLConnectionがdelegateを扱う為だ。
 cancelしても、このオブジェクトのカウンタは減る。
 */
- (void) dealloc {
	[m_sentID release];
	[m_data release];
	[m_connectionName release];
	[messenger release];
	
	[super dealloc];
}


@end
