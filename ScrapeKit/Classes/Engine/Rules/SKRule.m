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
	return [self saveValue:value intoVariable:variableName propertyName:propertyName engine:engine saveInto:YES];
}

-(BOOL)saveValue:(id)value intoVariable:(NSString *)variableName propertyName:(NSString *)propertyName engine:(SKEngine *)engine saveInto:(BOOL)saveInto {
	BOOL ableToBeSaved = YES;
	id variable = [engine variableFor:variableName];
	if (variable == nil) {
		// no pre-existing variable, so we're going to save it directly
		[engine setVariableFor:variableName value:value];
	}
	else {
		if ([variable isKindOfClass:[NSMutableArray class]] && saveInto) {
			// let's add it to the end of the array
			[variable addObject:value];
		}
		else if ([variable isKindOfClass:[NSMutableDictionary class]] && saveInto) {
			// let's add it as a value in the dictionary (assuming propertyName
			// is present)
			if (propertyName != nil)
				variable[propertyName] = value;
			else
				ableToBeSaved = NO;
		}
		else {
			@try {
				if (propertyName != nil) {
					id existingValue = [variable valueForKey:propertyName];
					if (existingValue == nil) {
						// existing property doesn't have a value, so we just save it directly
						[variable setValue:value forKey:propertyName];
					}
					else {
						if ([existingValue isKindOfClass:[NSMutableArray class]] && saveInto) {
							// let's add it to the end of the array
							[existingValue addObject:value];
						}
						else {
							// it is already set to an object, but we have no special casing for it,
							// so we just save directly
							[variable setValue:value forKey:propertyName];
						}
					}
				}
				else {
					// we've found an variable called 'variableName' but it isn't
					// one of the special cases, so we just replace it.
					[engine setVariableFor:variableName value:value];
				}
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
