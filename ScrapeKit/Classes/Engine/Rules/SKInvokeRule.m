//
//  SKInvokeRule.m
//  ScrapeKit
//
//  Created by Craig Edwards on 21/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKInvokeRule

-(BOOL)executeInFrame:(SKFrame *)frame function:(SKFunction *)function engine:(SKEngine *)engine {
	NSString *functionName = [self param:0];

	if ([engine isDebugging]) {
		[[engine debugger] outputMessage:self message:[NSString stringWithFormat:@"Invoking \"%@\"", functionName]];
	}

	return [engine executeFunction:functionName callingRule:self];
}

@end
