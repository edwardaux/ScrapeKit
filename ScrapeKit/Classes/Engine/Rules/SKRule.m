//
//  SKRule.m
//  ScrapeKit
//
//  Created by Craig Edwards on 19/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

#import <ScrapeKit/ScrapeKit.h>

@implementation SKRule

-(BOOL)validateParams:(NSArray *)params error:(NSError **)error {
	// assume everything is OK, but give each rule a chance to validate itself
	return YES;
}

-(BOOL)executeInFrame:(SKFrame *)frame function:(SKFunction *)function engine:(SKEngine *)engine {
	// this should be overridden by subclasses otherwise the rule is effectively a NOP
	return YES;
}

#
#pragma mark - Useful methods that subclasses may want to call
#
-(NSString *)param:(NSUInteger)index {
	if (index < [[self params] count])
		return [self params][index];
	else
		return nil;
}

-(BOOL)doGoto:(NSString *)label frame:(SKFrame *)frame function:(SKFunction *)function {
	for (NSUInteger i = 0; i < [[function rules] count]; i++) {
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

-(BOOL)saveValue:(id)value intoVariable:(NSString *)variableName propertyName:(NSString *)propertyName engine:(SKEngine *)engine {
	BOOL ableToBeSaved = YES;
	id variable = [engine variableFor:variableName];
	if (variable == nil) {
		// no pre-existing variable, so we're going to save it as a string
		[engine setVariableFor:variableName value:value];
	}
	else {
		if ([variable isKindOfClass:[NSString class]]) {
			// replace it
			[engine setVariableFor:variableName value:value];
		}
		else if ([variable isKindOfClass:[NSMutableArray class]]) {
			// let's add it to the end of the array
			[variable addObject:value];
		}
		else if ([variable isKindOfClass:[NSMutableDictionary class]]) {
			// let's add it as a value in the dictionary (assuming propertyName
			// is present)
			if (propertyName != nil)
				variable[propertyName] = value;
			else
				ableToBeSaved = NO;
		}
		else {
			// let's add it as a property of a normal object
			@try {
				if (propertyName != nil)
					[variable setValue:value forKey:propertyName];
				else
					ableToBeSaved = NO;
			}
			@catch (NSException *exception) {
				ableToBeSaved = NO;
			}
		}
	}
	return ableToBeSaved;
}

-(NSString *)description {
	return [NSString stringWithFormat:@"%@ %@", [self verb], [[self params] componentsJoinedByString:@" "]];
}

@end
