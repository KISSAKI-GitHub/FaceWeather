//
//  LBXMLParserController.h
//  LightBox
//
//  Created by Toru Inoue on 11/06/27.
//  Copyright 2011 KISSAKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBXMLParserController : NSObject <NSXMLParserDelegate> {
    
}
- (id) initLBXMLParserController;
- (void) lBXMLParserControlCenter:(NSData * )data;

@end
