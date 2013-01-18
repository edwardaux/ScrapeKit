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
		
		[self addRuleImplementationClass:[SKAssignVarRule class]   forVerb:@"ASSIGNVAR"];
		[self addRuleImplementationClass:[SKCreateVarRule class]   forVerb:@"CREATEVAR"];
		[self addRuleImplementationClass:[SKGotoRule class]        forVerb:@"GOTO"];
		[self addRuleImplementationClass:[SKIfSuccessRule class]   forVerb:@"IFSUCCESS"];
		[self addRuleImplementationClass:[SKIfFailureRule class]   forVerb:@"IFFAILURE"];
		[self addRuleImplementationClass:[SKInvokeRule class]      forVerb:@"INVOKE"];
		[self addRuleImplementationClass:[SKLabelRule class]       forVerb:@"LABEL"];
		[self addRuleImplementationClass:[SKPopRule class]         forVerb:@"POP"];
		[self addRuleImplementationClass:[SKPopIntoVarRule class]  forVerb:@"POPINTOVAR"];
		[self addRuleImplementationClass:[SKPushBetweenRule class] forVerb:@"PUSHBETWEEN"];
		[self addRuleImplementationClass:[SKSetVarRule class]      forVerb:@"SETVAR"];
	}
	return self;
}

-(void)reset {
	_frameStack = [NSMutableArray array];

	_textStack = [NSMutableArray array];
	_variablePool = [NSMutableDictionary dictionary];
}

-(BOOL)isDebugging {
	return [self debugger] != nil;
}

-(void)addRuleImplementationClass:(Class)clazz forVerb:(NSString *)verb {
	_ruleImplementations[[verb uppercaseString]] = clazz;
}

-(SKFunction *)functionForName:(NSString *)functionName {
	return _functionMap[functionName];
}

#
#pragma mark - Compilation
#
-(BOOL)compile:(NSString *)script error:(NSError **)error {
	SKFunction *currentFunction = nil;
	NSArray *ruleStrings = [script componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
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
		else if ([ruleString hasPrefix:@":"]) {
			// a label
			SKRule *rule = [self newRuleForVerb:@"LABEL" error:error];
			[rule setVerb:@"LABEL"];
			[rule setParams:@[ruleString]];
			[rule setFunction:currentFunction];
			[currentFunction addRule:rule];
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
	
	NSArray *tokens = [self tokenizeRule:ruleString error:error];
	if (tokens == nil)
		return nil;
	
	NSString *verb = tokens[0];
	NSArray *params = [tokens subarrayWithRange:NSMakeRange(1, [tokens count]-1)];
	
	SKRule *rule = [self newRuleForVerb:verb error:error];
	if (![rule validateParams:params error:error]) {
		return nil;
	}
	[rule setVerb:verb];
	[rule setParams:params];
	[rule setFunction:function];
	[function addRule:rule];
	
	return rule;
}
			
-(BOOL)populateCompilationError:(NSError **)error withMessage:(NSString *)message {
	if (error != NULL)
		*error = [NSError errorWithDomain:@"ScrapeKit" code:0 userInfo:@{ NSLocalizedDescriptionKey : message }];
	return YES;
}

-(SKRule *)newRuleForVerb:(NSString *)verb error:(NSError **)error {
	Class clazz = _ruleImplementations[[verb uppercaseString]];
	if (clazz == nil) {
		[self populateCompilationError:error withMessage:[NSString stringWithFormat:@"Unable to find rule implementation for \"%@\"", verb]];
		return nil;
	}
	
	NSObject *object = [[clazz alloc] init];
	if (![object isKindOfClass:[SKRule class]]) {
		[self populateCompilationError:error withMessage:[NSString stringWithFormat:@"Implementation for \"%@\" is not a valid SKRule class", NSStringFromClass(clazz)]];
		return nil;
	}
	
	return (SKRule *)object;
}

-(NSArray *)tokenizeRule:(NSString *)paramString error:(NSError **)error {
	NSMutableArray *tokens = [NSMutableArray array];
	NSString *pattern = @"(\"(\\\\.|[^\\\"])*\")|(\\S+)";
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:error];
	[regex enumerateMatchesInString:paramString options:NSMatchingReportProgress range:NSMakeRange(0, [paramString length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
		if (flags != NSMatchingProgress) {
			NSString *word = [paramString substringWithRange:[result range]];
			if ([word hasPrefix:@"\""] && [word hasSuffix:@"\""]) {
				word = [word substringWithRange:NSMakeRange(1, [word length]-2)];
			}
			[tokens addObject:word];
		}
	}];
	return tokens;
}

#
#pragma mark - Runtime evaluation
#
-(void)parse:(NSString *)inputString {
	[self reset];

	[self push:[[SKTextBuffer alloc] initWithString:inputString]];
	[self executeFunction:@"main" callingRule:nil];
	if ([self isDebugging])
		[[self debugger] outputMessage:nil message:[_variablePool debugDescription]];
}

-(BOOL)executeFunction:(NSString *)functionName callingRule:(SKRule *)callingRule {
	SKFunction *function = _functionMap[functionName];
	if (function == nil) {
		if ([self isDebugging])
			[[self debugger] outputMessage:callingRule message:[NSString stringWithFormat:@"Unable to find function \"%@\"", functionName]];
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
		[self setLastRuleWasSuccessful:lastSuccess];
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

-(id)variableFor:(NSString *)varName {
	return _variablePool[varName];
}

-(void)setVariableFor:(NSString *)varName value:(id)value {
	_variablePool[varName] = value;
}

@end
