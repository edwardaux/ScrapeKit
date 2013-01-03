//
//  SKGotoRule.m
//  ScrapeKit
//
//  Created by Craig Edwards on 20/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKGotoRule

-(BOOL)executeInFrame:(SKFrame *)frame function:(SKFunction *)function engine:(SKEngine *)engine {
	NSString *label = [self param:0];

	if ([engine isDebugging]) {
		[[engine debugger] outputMessage:self message:[NSString stringWithFormat:@"Jumping to \"%@\"", label]];
	}
	
	return [self doGoto:label frame:frame function:function];
}

@end
