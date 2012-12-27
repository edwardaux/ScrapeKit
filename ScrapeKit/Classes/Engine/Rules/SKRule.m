//
//  SKRule.m
//  ScrapeKit
//
//  Created by Craig Edwards on 19/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKRule

-(BOOL)validateParams:(NSArray *)params error:(NSError **)error {
	// assume everything is OK, but give each rule a chance to validate itself
	return YES;
}

-(BOOL)executeInFrame:(SKFrame *)frame function:(SKFunction *)function engine:(SKEngine *)engine {
	// this should be overridden by subclasses otherwise the rule is effectively a NOP
	return YES;
}

-(NSString *)param:(NSUInteger)index {
	if (index < [[self params] count])
		return [self params][index];
	else
		return nil;
}

-(NSString *)description {
	return [NSString stringWithFormat:@"%@ %@", [self verb], [[self params] componentsJoinedByString:@" "]];
}

@end
