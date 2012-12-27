//
//  SKFunction.m
//  ScrapeKit
//
//  Created by Craig Edwards on 19/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKFunction

-(id)initWithEngine:(SKEngine *)engine name:(NSString *)name {
	self = [super init];
	if (self != nil) {
		[self setName:name];
	}
	return self;
}

-(void)addRule:(SKRule *)rule {
	[[self rules] addObject:rule];
}

@end
