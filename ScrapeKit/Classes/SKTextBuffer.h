//
//  SKTextBuffer.h
//  ScrapeKit
//
//  Created by Craig Edwards on 20/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

#import <Foundation/Foundation.h>

// ------------------------------------------------------------------------------------
// This is the heart of the text buffer storage for ScrapeKit.  The nature of the
// implementation is such that there is only ever a single NSString (the very original
// input string) used across all instances of SKTextBuffer within a single script. Each
// SKTextBuffer does, however, have an instance of NSRange that specifies the working
// window for that instance of the the SKTextBuffer.
//
// For example, imagine that the input string is "xx yy aaaa yy xx".  Upon entry to the
// [SKEngine parse:] method, a single SKTextBuffer is created with a range of (0,16).
// Then, if a PushBetween rule pushes everything between "xx" and "xx", then a new
// SKTextBuffer is created with the original string as input, but a range of (2,12).
// Again, if that buffer is modified to push between "yy" and "yy", then a new instance
// of SKTextBuffer is created with the original string and a range of (5,6).  In this
// way, we can efficiently have many instances of SKTextBuffer without blowing memory
// because they all share the same input NSString.
//
// In addition to the input text and the range, an SKTextBuffer has an internal
// position tracker called 'head'.  As text is "extracted" from an instance of
// SKTextBuffer using the betweenString1:include1:string2:include2:includeToEOF:
// method, head is advanced past the string that was just extracted.  For example,
// consider the following code:
//
//     SKTextBuffer *buffer = [[SKTextBuffer alloc] initWithString:@"(a)(b)(c)"];
//     SKTextBuffer *a = [buffer betweenString1:@"(" include:NO string2:@")" include:NO includeToEOF:NO];
//     SKTextBuffer *b = [buffer betweenString1:@"(" include:NO string2:@")" include:NO includeToEOF:NO];
//     SKTextBuffer *c = [buffer betweenString1:@"(" include:NO string2:@")" include:NO includeToEOF:NO];
//     SKTextBuffer *d = [buffer betweenString1:@"(" include:NO string2:@")" include:NO includeToEOF:NO];
//
// The first call returns an SKTextBuffer with a range of (1,1) and the head variable
// in the buffer object has been advanced to 3.  The second call returns an SKTextBuffer
// with a range of (4,1) and the head variable in the buffer object has been advanced
// to 6.  The third call returns an SKTextBuffer with a range of (7,1) and the head
// variable has been advanced to 9.  The last call will return a nil, because there
// is no more readable text beyond head.
//
// The [SKTextBuffer stringValue] method uses the range to return the actual text that
// is being represented by this SKTextBuffer.  It ignores the position of head.
//
// The [SKTextBuffer remainingStringValue] method returns a string containing everything
// from head to the end of the range.
// ------------------------------------------------------------------------------------
@interface SKTextBuffer : NSObject {
	NSString  *_text;
	NSRange    _range;
	NSUInteger _head;
}

-(id)initWithString:(NSString *)string;
-(id)initWithString:(NSString *)string range:(NSRange)range;

/**
 * Starting at the internal head position, search for string1.
 * 
 *   If found, search for string2.
 *     If found 
 *       return the text between the two strings (if include1 is set, string1
 *       will be included in the returned buffer. Likewise, for include2).
 *     Else
 *       If includeToEOF == YES
 *         return the text between string1 and the end of this buffers range
 *       Else
 *         return nil
 *   else
 *     return nil
 *
 * If a non-nil value is returned, the internal head position is advanced to the
 * end of string2 (regardless of the value of include1 or include2)
 */
-(SKTextBuffer *)betweenString1:(NSString *)string1 include1:(BOOL)include1 string2:(NSString *)string2 include2:(BOOL)include2 includeToEOF:(BOOL)includeToEOF;

/**
 * Resets the internal head position to the start of the range
 */
-(void)reset;

-(NSString *)stringValue;
-(NSString *)remainingStringValue;

@end
