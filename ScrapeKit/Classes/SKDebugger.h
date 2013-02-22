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

// ------------------------------------------------------------------------------------
// If you want to implement your own debugger, you will need to implement this protocol.
// Your object will be called back as the input data is parsed.
// ------------------------------------------------------------------------------------
@protocol SKDebugger

-(void)enteringFunction:(SKFunction *)function textStack:(NSArray *)textStack;
-(void)exitingFunction:(SKFunction *)function textStack:(NSArray *)textStack;
-(void)executingRule:(SKRule *)rule textStack:(NSArray *)textStack;
-(void)outputMessage:(SKRule *)rule message:(NSString *)message;

@end

// ------------------------------------------------------------------------------------
// Simple console-based debugger.  Just dumps data to the console.
// ------------------------------------------------------------------------------------
@interface SKConsoleDebugger : NSObject<SKDebugger> {
	NSString *_indent;
}

-(void)emitMessage:(NSString *)message;

@end
