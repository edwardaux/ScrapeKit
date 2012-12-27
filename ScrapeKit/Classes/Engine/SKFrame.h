//
//  SKFrame.h
//  ScrapeKit
//
//  Created by Craig Edwards on 20/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

@class SKEngine;
@class SKFunction;
@class SKRule;

@interface SKFrame : NSObject {
	__weak SKEngine   *_engine;
	__weak SKFunction *_function;
}

@property (nonatomic) NSUInteger PC;
@property (nonatomic) BOOL lastSuccess;

-(id)initWithFunction:(SKFunction *)function inEngine:(SKEngine *)engine;
-(SKRule *)nextRule;

@end
