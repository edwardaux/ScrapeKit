//
//  SKIfSuccessRule.m
//  ScrapeKit
//
//  Created by Craig Edwards on 2/01/13.
//  Copyright (c) 2013 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKIfSuccessRule

-(BOOL)executeInFrame:(SKFrame *)frame function:(SKFunction *)function engine:(SKEngine *)engine {
	NSString *label = [self param:0];
	if ([engine lastRuleWasSuccessful])
		return [self doGoto:label frame:frame function:function];
	else
		return YES;
}

@end
