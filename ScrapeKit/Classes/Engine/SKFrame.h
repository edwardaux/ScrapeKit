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

// ------------------------------------------------------------------------------------
// Used to keep track of where execution is up to in each function during runtime
// parsing.  Every time a function gets called, one of these get created and put onto
// the frameStack in the engine.
// ------------------------------------------------------------------------------------
@interface SKFrame : NSObject {
	__weak SKEngine   *_engine;
	__weak SKFunction *_function;
}

@property (nonatomic) NSUInteger PC;

-(id)initWithFunction:(SKFunction *)function inEngine:(SKEngine *)engine;
-(SKRule *)nextRule;

@end
