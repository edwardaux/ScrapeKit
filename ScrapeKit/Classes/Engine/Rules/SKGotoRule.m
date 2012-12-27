//
//  SKGotoRule.m
//  ScrapeKit
//
//  Created by Craig Edwards on 20/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKGotoRule

-(BOOL)executeInFrame:(SKFrame *)frame function:(SKFunction *)function engine:(SKEngine *)engine {
	NSString *label = [self param:0];
	
	for (int i = 0; i < [[function rules] count]; i++) {
		SKRule *rule = [function rules][i];
		if ([rule isKindOfClass:[SKLabelRule class]]) {
			if ([[(SKLabelRule *)rule label] isEqual:label]) {
				[frame setPC:i];
				return YES;
			}
		}
	}
	return NO;
}

@end
