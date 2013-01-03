//
//  SKAssignVarRule.m
//  ScrapeKit
//
//  Created by Craig Edwards on 3/01/13.
//  Copyright (c) 2013 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKAssignVarRule

-(BOOL)executeInFrame:(SKFrame *)frame function:(SKFunction *)function engine:(SKEngine *)engine {
	NSString *srcVariableName = [self param:0];
	NSString *dstVariableName = [self param:1];
	NSString *propertyName = [self param:2];
	
	// let's figure out the value that we're going to store.
	id value = [engine variableFor:srcVariableName];

	if ([engine isDebugging]) {
		[[engine debugger] outputMessage:self message:[NSString stringWithFormat:@"Assigning from %@(\"%@\") to %@", srcVariableName, value, DEBUG_PROP(dstVariableName, propertyName)]];
	}

	if (value == nil) {
		if ([engine isDebugging])
			[[engine debugger] outputMessage:self message:[NSString stringWithFormat:@"Empty value for \"%@\"", srcVariableName]];
		return NO;
	}
	else {
		return [self saveValue:value intoVariable:dstVariableName propertyName:propertyName engine:engine];
	}
}

@end
