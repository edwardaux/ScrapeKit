//
//  SKTextBuffer.m
//  ScrapeKit
//
//  Created by Craig Edwards on 20/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

#import "SKTextBuffer.h"

@implementation SKTextBuffer

-(id)initWithString:(NSString *)string {
	return [self initWithString:string range:NSMakeRange(0, [string length])];
}

-(id)initWithString:(NSString *)string range:(NSRange)range {
	self = [super init];
	if (self != nil) {
		_text = string;
		_range = range;
		[self reset];
	}
	return self;
}

-(void)reset {
	_head = _range.location;
}

-(SKTextBuffer *)betweenString1:(NSString *)string1 include1:(BOOL)include1 string2:(NSString *)string2 include2:(BOOL)include2 includeToEOF:(BOOL)includeToEOF {
	// move the head to string1
	NSUInteger head = _head;
	NSRange range = [_text rangeOfString:string1 options:0 range:NSMakeRange(head, NSMaxRange(_range)-head)];
	if (range.location == NSNotFound)
		head = NSNotFound;
	else
		head = include1 ? range.location : NSMaxRange(range);
	
	NSUInteger newHead = head;
	// now move the tail to string2
	NSUInteger tail = head;
	// not much point looking if we haven't found string1
	if (head != NSNotFound) {
		// note that we look from the end of the first string
		// regardless of what we are consuming
		range = [_text rangeOfString:string2 options:0 range:NSMakeRange(NSMaxRange(range), NSMaxRange(_range)-NSMaxRange(range))];
		if (range.location == NSNotFound) {
			if (includeToEOF) {
				tail = NSMaxRange(_range);
				newHead = tail;
			}
			else {
				tail = NSNotFound;
				newHead = NSNotFound;
			}
		}
		else {
			tail = include2 ? NSMaxRange(range) : range.location;
			newHead = NSMaxRange(range);
		}
	}
	
	if (head == NSNotFound || tail == NSNotFound)
		return nil;
	else {
		// commit the consumed head position
		_head = newHead;
		return [[SKTextBuffer alloc] initWithString:_text range:NSMakeRange(head, tail-head)];
	}
}

-(NSString *)stringValue {
	return [_text substringWithRange:_range];
}

-(NSString *)remainingStringValue {
	return [_text substringWithRange:NSMakeRange(_head, NSMaxRange(_range)-_head)];
}

-(NSString *)debugDescription {
	NSUInteger leadingTrailing = 30;
	NSString *orig = [self remainingStringValue];
	orig = [orig stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
	orig = [orig stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
	if ([orig length] < 80)
		return orig;
	else {
		NSString *leading = [orig substringToIndex:leadingTrailing];
		NSString *trailing = [orig substringFromIndex:[orig length]-leadingTrailing];
		return [leading stringByAppendingFormat:@"...%@", trailing];
	}
}

@end
