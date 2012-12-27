//
//  SKEngine.m
//  ScrapeKit
//
//  Created by Craig Edwards on 19/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKEngine

-(id)init {
	self = [super init];
	if (self != nil) {
		_ruleImplementations = [NSMutableDictionary dictionary];
		_functionMap = [NSMutableDictionary dictionary];
		[self setDebugger:nil];
		
		[self addRuleImplementationClass:[SKLabelRule class] forVerb:@"LABEL"];
		[self addRuleImplementationClass:[SKLabelRule class] forVerb:@"GOTO"];
	}
	return self;
}

-(void)reset {
	_textStack = [NSMutableArray array];
	_frameStack = [NSMutableArray array];
}

-(BOOL)isDebugging {
	return [self debugger] != nil;
}

-(void)addRuleImplementationClass:(Class)clazz forVerb:(NSString *)verb {
	_ruleImplementations[verb] = clazz;
}

-(SKFunction *)functionForName:(NSString *)functionName {
	return _functionMap[functionName];
}

#
#pragma mark - Compilation
#
-(BOOL)compile:(NSString *)script error:(NSError **)error {
	SKFunction *currentFunction = nil;
	NSArray *ruleStrings = [script componentsSeparatedByString:@"\\n"];
	for (NSString *tmpRuleString in ruleStrings) {
		NSString *ruleString = [tmpRuleString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if ([ruleString isEqual:@""] || [ruleString hasPrefix:@"#"]) {
			// blank lines and comments are just skipped
			continue;
		}
		else if ([ruleString hasPrefix:@"@"]) {
			// a new function
			NSString *functionName = [ruleString substringFromIndex:1];
			currentFunction = [[SKFunction alloc] initWithEngine:self name:functionName];
			_functionMap[functionName] = currentFunction;
		}
		else {
			// must be a rule
			if (currentFunction == nil) {
				[self populateCompilationError:error withMessage:[NSString stringWithFormat:@"Rule \"%@\" declared outside of a function", ruleString]];
				return NO;
			}
			if ([self compileRule:ruleString inFunction:currentFunction error:error] == nil) {
				// if we can't compile the individual rule, we bail.  Note that we're
				// relying on the rule compilation to have set the error
				return NO;
			}
		}
	}
	if (_functionMap[@"main"] == nil) {
		[self populateCompilationError:error withMessage:@"No main function"];
		return NO;
	}
	
	// well, looks like we're a go...
	return YES;
}

-(SKRule *)compileRule:(NSString *)ruleString inFunction:(SKFunction *)function error:(NSError **)error {
	
	// TODO parse verb and params
	NSString *verb = @"";
	NSArray *params = @[ @"a", @"b" ];
	
	Class clazz = _ruleImplementations[verb];
	if (clazz == nil) {
		[self populateCompilationError:error withMessage:[NSString stringWithFormat:@"Unable to find rule implementation for %@", verb]];
		return nil;
	}

	NSObject *object = [[clazz alloc] init];
	if (![object isKindOfClass:[SKRule class]]) {
		[self populateCompilationError:error withMessage:[NSString stringWithFormat:@"Implementation for %@ is not a valid SKRule class", NSStringFromClass(clazz)]];
		return nil;
	}
	SKRule *rule = (SKRule *)object;
	if ([rule validateParams:params error:error]) {
		return nil;
	}
	[rule setVerb:verb];
	[rule setParams:params];
	[rule setFunction:function];
	[function addRule:rule];
	
	return nil;
}
			
-(void)populateCompilationError:(NSError **)error withMessage:(NSString *)message {
	if (error != NULL)
		*error = [NSError errorWithDomain:@"ScrapeKit" code:0 userInfo:@{ NSLocalizedDescriptionKey : message }];
}

#
#pragma mark - Runtime evaluation 
#
-(void)parse:(NSString *)inputString {
	[self reset];

	[self push:[[SKTextBuffer alloc] initWithString:inputString]];
	[self executeFunction:@"main" callingRule:nil];
}

-(BOOL)executeFunction:(NSString *)functionName callingRule:(SKRule *)callingRule {
	SKFunction *function = _functionMap[functionName];
	if (function == nil) {
		if ([self isDebugging])
			[[self debugger] outputMessage:callingRule message:[NSString stringWithFormat:@"Unable to find function: %@", functionName]];
		return NO;
	}
	
	SKFrame *frame = [[SKFrame alloc] initWithFunction:function inEngine:self];

	if ([self isDebugging])
		[[self debugger] enteringFunction:function textStack:_textStack];
	[_frameStack addObject:frame];
	
	SKRule *rule = [frame nextRule];
	while (rule != nil) {
		if ([self isDebugging]) {
			[[self debugger] executingRule:rule textStack:_textStack];
		}
		BOOL lastSuccess = [rule executeInFrame:frame function:function engine:self];
		[frame setLastSuccess:lastSuccess];
		if ([self isDebugging]) {
			[[self debugger] outputMessage:rule message:[NSString stringWithFormat:@"Success=%@", lastSuccess?@"YES":@"NO"]];
		}
		rule = [frame nextRule];
	}

	if ([self isDebugging])
		[[self debugger] exitingFunction:function textStack:_textStack];
	[_frameStack removeLastObject];
	
	return YES;
}

-(void)push:(SKTextBuffer *)buffer {
	[_textStack addObject:buffer];
}

-(SKTextBuffer *)pop {
	SKTextBuffer *buffer = [_textStack lastObject];
	[_textStack removeLastObject];
	return buffer;
}

-(SKTextBuffer *)peek {
	return [_textStack lastObject];
}
@end
