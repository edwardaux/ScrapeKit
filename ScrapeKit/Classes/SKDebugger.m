//
//  SKDebugger.m
//  ScrapeKit
//
//  Created by Craig Edwards on 20/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKDebugger

-(void)enteringFunction:(SKFunction *)function textStack:(NSArray *)textStack {
	_indent = [_indent stringByAppendingString:@"  "];
}

-(void)exitingFunction:(SKFunction *)function textStack:(NSArray *)textStack {
	_indent = [_indent substringFromIndex:2];
}

-(void)executingRule:(SKRule *)rule textStack:(NSArray *)textStack  {
	[self outputMessage:rule message:@"---------------------------------------------------"];
}

-(void)outputMessage:(SKRule *)rule message:(NSString *)message {
	NSLog(@"%@%@[%@] %@", _indent, [rule function], [rule verb], message);
}

-(void)dumpTextStack:(NSArray *)textStack {
	for (int i = [textStack count]-1; i >= 0; i--)
		NSLog(@"%@  %@", _indent, [NSString stringWithFormat:@"%d %@", [textStack count]-i-1, [textStack[i] debugDescription]]);
}

@end
