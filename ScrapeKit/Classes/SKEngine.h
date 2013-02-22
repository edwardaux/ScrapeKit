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

// ------------------------------------------------------------------------------------
// Coordinates the compilation of the rules, the parsing at runtime, storage of the
// text buffer stack, and the global variable pool.
// ------------------------------------------------------------------------------------
@interface SKEngine : NSObject {
	/**
	 * The list of rule implementations that are available for the current script.
	 *   Key:    NSString (the name of the rule)
	 *   Value:  Subclass of SKRule (an instance of the rule)
	 */
	NSMutableDictionary *_ruleImplementations;
	
	/**
	 * The list of functions in the current script
	 *   Key:   NSString (the name of the function)
	 *   Value: SKFunction (the function itself)
	 */
	NSMutableDictionary *_functionMap;
	
	/**
	 * LIFO stack maintaining the function call stack during runtime parsing
	 *   Values:  SKFrame objects
	 */
	NSMutableArray      *_frameStack;

	/**
	 * LIFO stack containing the text buffers as they are pushed/popped by rules 
	 * during runtime parsing
	 *   Values:  SKTextBuffer objects
	 */
	NSMutableArray      *_textStack;
	
	/**
	 * The global variable pool
	 *   Key:   NSString (the name of the variable)
	 *   Value: id (the variable itself)
	 */
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
-(void)push:(SKTextBuffer *)buffer;
-(SKTextBuffer *)pop;
-(SKTextBuffer *)peek;
-(id)variableFor:(NSString *)varName;
-(void)setVariableFor:(NSString *)varName value:(id)value;

@end
