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
@protocol SKDebugger;

@interface SKEngine : NSObject {
	NSMutableDictionary *_ruleImplementations;
	NSMutableDictionary *_functionMap;
	NSMutableArray      *_frameStack;

	NSMutableArray      *_textStack;
	NSMutableDictionary *_variablePool;
}

@property (nonatomic, strong) id<SKDebugger> debugger;
@property (nonatomic)         BOOL lastRuleWasSuccessful;

// -------------------------------------------------------------------------------
// Normally called from users of scripts
// -------------------------------------------------------------------------------
-(BOOL)compile:(NSString *)script error:(NSError **)error;
-(void)parse:(NSString *)inputString;

// -------------------------------------------------------------------------------
// Normally called by implementors of custom rules
// -------------------------------------------------------------------------------
-(void)addRuleImplementationClass:(Class)clazz forVerb:(NSString *)verb;
-(BOOL)executeFunction:(NSString *)functionName callingRule:(SKRule *)rule;

// -------------------------------------------------------------------------------
// Normally called from within rule implementations
// -------------------------------------------------------------------------------
-(BOOL)isDebugging;
-(void)dumpTextStack;
-(void)push:(SKTextBuffer *)buffer;
-(SKTextBuffer *)pop;
-(SKTextBuffer *)peek;
-(id)variableFor:(NSString *)varName;
-(void)setVariableFor:(NSString *)varName value:(id)value;

@end
