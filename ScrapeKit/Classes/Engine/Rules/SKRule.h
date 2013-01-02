//
//  SKRule.h
//  ScrapeKit
//
//  Created by Craig Edwards on 19/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

@class SKEngine;
@class SKFunction;
@class SKFrame;

@interface SKRule : NSObject

@property (nonatomic, weak) SKFunction *function;
@property (nonatomic, strong) NSString *verb;
@property (nonatomic, strong) NSArray *params;

-(BOOL)validateParams:(NSArray *)params error:(NSError **)error;
-(BOOL)executeInFrame:(SKFrame *)frame function:(SKFunction *)function engine:(SKEngine *)engine;

-(NSString *)param:(NSUInteger)index;
-(BOOL)doGoto:(NSString *)label frame:(SKFrame *)frame function:(SKFunction *)function;
-(BOOL)saveValue:(id)value intoVariable:(NSString *)variableName propertyName:(NSString *)propertyName engine:(SKEngine *)engine;

@end
