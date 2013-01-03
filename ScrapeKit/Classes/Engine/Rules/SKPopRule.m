//
//  SKPopRule.m
//  ScrapeKit
//
//  Created by Craig Edwards on 21/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKPopRule

-(BOOL)executeInFrame:(SKFrame *)frame function:(SKFunction *)function engine:(SKEngine *)engine {
	SKTextBuffer *buffer = [engine pop];
	
	if ([engine isDebugging]) {
		[[engine debugger] outputMessage:self message:[NSString stringWithFormat:@"Popping \"%@\"", [buffer debugDescription]]];
	}

	return buffer != nil;
}

@end
