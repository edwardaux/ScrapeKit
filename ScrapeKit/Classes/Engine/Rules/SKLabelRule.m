//
//  SKLabelRule.m
//  ScrapeKit
//
//  Created by Craig Edwards on 20/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKLabelRule

-(NSString *)label {
	return [self param:0];
}

-(BOOL)executeInFrame:(SKFrame *)frame function:(SKFunction *)function engine:(SKEngine *)engine {
	// a label is a NOP operation (so can be safely skipped over)
	return YES;
}

@end
