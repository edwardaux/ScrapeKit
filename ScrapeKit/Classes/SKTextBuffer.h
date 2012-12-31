//
//  SKTextBuffer.h
//  ScrapeKit
//
//  Created by Craig Edwards on 20/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKTextBuffer : NSObject {
	NSString *_text;
	NSRange    _range;
	NSUInteger _head;
}

-(id)initWithString:(NSString *)string;
-(id)initWithString:(NSString *)string range:(NSRange)range;

-(SKTextBuffer *)betweenString1:(NSString *)string1 include1:(BOOL)include1 string2:(NSString *)string2 include2:(BOOL)include2 includeToEOF:(BOOL)includeToEOF;
-(void)reset;
-(NSString *)stringValue;
-(NSString *)remainingStringValue;

@end
