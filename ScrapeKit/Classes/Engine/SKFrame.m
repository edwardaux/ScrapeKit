//
//  SKFrame.m
//  ScrapeKit
//
//  Created by Craig Edwards on 20/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKFrame

-(id)initWithFunction:(SKFunction *)function inEngine:(SKEngine *)engine {
	self = [super init];
	if (self != nil) {
		_engine = engine;
		_function = function;
		[self setPC:0];
	}
	return self;
}

-(SKRule *)nextRule {
	if ([self PC] >= [[_function rules] count])
		return nil;
	else {
		SKRule *rule = [_function rules][[self PC]];
		[self setPC:[self PC]+1];
		return rule;
	}
}

@end
