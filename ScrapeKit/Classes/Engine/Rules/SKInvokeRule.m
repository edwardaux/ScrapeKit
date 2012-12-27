//
//  SKInvokeRule.m
//  ScrapeKit
//
//  Created by Craig Edwards on 21/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKInvokeRule

-(BOOL)executeInFrame:(SKFrame *)frame function:(SKFunction *)functions engine:(SKEngine *)engine {
	NSString *functionName = [self param:0];
	return [engine executeFunction:functionName callingRule:self];
}
@end
