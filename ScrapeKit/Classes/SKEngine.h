//
//  SKEngine.h
//  ScrapeKit
//
//  Created by Craig Edwards on 19/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

@class SKDebugger;
@class SKFunction;
@class SKRule;
@class SKTextBuffer;

@interface SKEngine : NSObject {
	NSMutableDictionary *_ruleImplementations;
	NSMutableDictionary *_functionMap;
	NSMutableArray      *_textStack;
	NSMutableArray      *_frameStack;
}

@property (nonatomic, strong) SKDebugger *debugger;

-(BOOL)compile:(NSString *)script error:(NSError **)error;
-(void)parse:(NSString *)inputString;

-(void)addRuleImplementationClass:(Class)clazz forVerb:(NSString *)verb;
-(BOOL)executeFunction:(NSString *)functionName callingRule:(SKRule *)rule;
-(void)push:(SKTextBuffer *)buffer;
-(SKTextBuffer *)pop;
-(SKTextBuffer *)peek;
-(BOOL)isDebugging;

@end
