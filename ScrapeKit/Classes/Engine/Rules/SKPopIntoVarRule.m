//
//  SKPopIntoVarRule.m
//  ScrapeKit
//
//  Created by Craig Edwards on 2/01/13.
//  Copyright (c) 2013 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKPopIntoVarRule

-(BOOL)executeInFrame:(SKFrame *)frame function:(SKFunction *)function engine:(SKEngine *)engine {
	NSString *variableName = [self param:0];
	NSString *propertyName = [self param:1];

	// let's figure out the value that we're going to store. Note that we
	// default the value to an empty string in case there isn't anything
	// on the text stack
	NSString *value = @"";
	SKTextBuffer *buffer = [engine pop];
	if (buffer != nil)
		value = [buffer stringValue];

	if ([engine isDebugging]) {
		[[engine debugger] outputMessage:self message:[NSString stringWithFormat:@"Popping \"%@\" into %@", [buffer debugDescription], DEBUG_PROP(variableName, propertyName)]];
	}
	
	return [self saveValue:value intoVariable:variableName propertyName:propertyName engine:engine];
}

@end
