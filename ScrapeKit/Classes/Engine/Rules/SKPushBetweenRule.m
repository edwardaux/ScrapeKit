//
//  SKPushBetweenRule.m
//  ScrapeKit
//
//  Created by Craig Edwards on 8/01/13.
//  Copyright (c) 2013 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKPushBetweenRule

-(BOOL)executeInFrame:(SKFrame *)frame function:(SKFunction *)function engine:(SKEngine *)engine {
	NSString *string1 = [self param:0];
	BOOL include1 = [@"include" isEqualToString:[self param:1]];
	NSString *string2 = [self param:2];
	BOOL include2 = [@"include" isEqualToString:[self param:3]];
	BOOL includeToEOF = [@"includeToEOF" isEqualToString:[self param:4]];
	
	SKTextBuffer *buffer = [engine peek];
	if ([engine isDebugging]) {
		[[engine debugger] outputMessage:self message:[NSString stringWithFormat:@"Looking between \"%@\" and \"%@\" in \"%@\"", string1, string2, [buffer debugDescription]]];
	}

	SKTextBuffer *output = [buffer betweenString1:string1 include1:include1 string2:string2 include2:include2 includeToEOF:includeToEOF];
	if (output != nil) {
		// great, found something
		if ([engine isDebugging]) {
			[[engine debugger] outputMessage:self message:[NSString stringWithFormat:@"Pushing \"%@\" onto text stack", [output debugDescription]]];
		}
		[engine push:output];
		return YES;
	}
	else {
		// nothing found
		if ([engine isDebugging]) {
			[[engine debugger] outputMessage:self message:[NSString stringWithFormat:@"Unable to find anything between \"%@\" and \"%@\"", string1, string2]];
		}
		return NO;
	}
}

@end
