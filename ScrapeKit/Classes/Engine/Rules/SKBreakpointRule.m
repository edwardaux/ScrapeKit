//
//  SKBreakpointRule.m
//  ScrapeKit
//
//  Created by Craig Edwards on 19/02/13.
//  Copyright (c) 2013 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKBreakpointRule

-(BOOL)executeInFrame:(SKFrame *)frame function:(SKFunction *)function engine:(SKEngine *)engine {
	// set a break point on the next line if you want Xcode to stop
	return YES;
}

@end
