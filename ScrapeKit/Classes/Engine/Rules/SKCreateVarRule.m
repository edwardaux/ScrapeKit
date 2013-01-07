//
//  SKCreateVarRule.m
//  ScrapeKit
//
//  Created by Craig Edwards on 3/01/13.
//  Copyright (c) 2013 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKCreateVarRule

-(BOOL)executeInFrame:(SKFrame *)frame function:(SKFunction *)function engine:(SKEngine *)engine {
	NSString *className = [self param:0];
	NSString *variableName = [self param:1];
	
	if ([engine isDebugging]) {
		[[engine debugger] outputMessage:self message:[NSString stringWithFormat:@"Creating variable of type \"%@\" and assigning to %@", className, variableName]];
	}

	Class clazz = NSClassFromString(className);
	if (clazz == nil) {
		if ([engine isDebugging])
			[[engine debugger] outputMessage:self message:[NSString stringWithFormat:@"Unable to find class \"%@\"", className]];
		return NO;
	}
	else {
		id value = [[clazz alloc] init];
		if (value != nil)
			return [self saveValue:value intoVariable:variableName propertyName:nil engine:engine saveInto:NO];
		else {
			if ([engine isDebugging])
				[[engine debugger] outputMessage:self message:[NSString stringWithFormat:@"Unable to instantiate class \"%@\"", className]];
			return NO;
		}
	}
}

@end
