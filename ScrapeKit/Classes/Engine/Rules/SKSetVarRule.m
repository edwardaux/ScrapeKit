//
//  SKSetVarRule.m
//  ScrapeKit
//
//  Created by Craig Edwards on 3/01/13.
//  Copyright (c) 2013 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKSetVarRule

-(BOOL)executeInFrame:(SKFrame *)frame function:(SKFunction *)function engine:(SKEngine *)engine {
	NSString *value = [self param:0];
	NSString *variableName = [self param:1];
	NSString *propertyName = [self param:2];
	
	if ([engine isDebugging]) {
		[[engine debugger] outputMessage:self message:[NSString stringWithFormat:@"Setting \"%@\" into %@", value, DEBUG_PROP(variableName, propertyName)]];
	}
	
	return [self saveValue:value intoVariable:variableName propertyName:propertyName engine:engine];
}

@end
