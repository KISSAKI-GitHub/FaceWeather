//
//  LBXMLParserController.m
//  LightBox
//
//  Created by Toru Inoue on 11/06/27.
//  Copyright 2011 KISSAKI. All rights reserved.
//

#import "LBXMLParserController.h"

@implementation LBXMLParserController


- (id) initLBXMLParserController {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(lBXMLParserControlCenter:) name:@"XMLParser" object:nil];
        
	}
	return self;
}
- (void) lBXMLParserControlCenter:(NSData * )data {
	
        
	NSXMLParser * parser = [[NSXMLParser alloc] initWithData:data];
    
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
}

int m_flagCount = 0;
- (void)parser:(NSXMLParser * )parser didStartElement:(NSString * )elementName namespaceURI:(NSString * )namespaceURI qualifiedName:(NSString * )qName attributes:(NSDictionary * )attributeDict {
	//NSLog(@"elementName	%@	namespaceURI	%@	qName	%@	attributeDict	%@", elementName, namespaceURI, qName, attributeDict);
	if ([elementName isEqualToString:@"url"]) {
		m_flagCount++;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	//NSLog(@"elementName	%@	namespaceURI	%@	qName	%@", elementName, namespaceURI, qName);
	if ([elementName isEqualToString:@"url"]) {
		m_flagCount++;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (m_flagCount == 1) {
		NSString * numStr = [string substringFromIndex:[string length]-6];
		
		numStr = [numStr substringToIndex:2];
		
		NSRange range = NSMakeRange(0, 1);
		if ([[numStr substringWithRange:range] isEqualToString:@"/"]) {
			numStr = [numStr substringFromIndex:1];
		}
		
        [[NSNotificationCenter defaultCenter]postNotificationName:@"WEATHER_NUMBER" object:nil userInfo:[NSDictionary dictionaryWithObject:numStr forKey:@"numStr"]];
		
	}
}


@end
