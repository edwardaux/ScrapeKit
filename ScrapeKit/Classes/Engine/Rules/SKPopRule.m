//
//  SKPopRule.m
//  ScrapeKit
//
//  Created by Craig Edwards on 21/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKPopRule

-(BOOL)executeInFrame:(SKFrame *)frame function:(SKFunction *)function engine:(SKEngine *)engine {
	SKTextBuffer *buffer = [engine pop];
	return buffer != nil;
}

@end
