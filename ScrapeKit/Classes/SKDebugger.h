//
//  SKDebugger.h
//  ScrapeKit
//
//  Created by Craig Edwards on 20/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

@class SKFunction;
@class SKFrame;
@class SKRule;

@interface SKDebugger : NSObject {
	NSString *_indent;
}

-(void)enteringFunction:(SKFunction *)function textStack:(NSArray *)textStack;
-(void)exitingFunction:(SKFunction *)function textStack:(NSArray *)textStack;
-(void)executingRule:(SKRule *)rule textStack:(NSArray *)textStack;
-(void)outputMessage:(SKRule *)rule message:(NSString *)message;
-(void)dumpTextStack:(NSArray *)textStack;

@end
