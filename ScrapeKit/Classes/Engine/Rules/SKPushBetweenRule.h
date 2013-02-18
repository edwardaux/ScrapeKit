//
//  SKPushBetweenRule.h
//  ScrapeKit
//
//  Created by Craig Edwards on 8/01/13.
//  Copyright (c) 2013 BlackDog Foundry. All rights reserved.
//

@class SKRule;

// ------------------------------------------------------------------------------------
// Usage:
//   PUSHBETWEEN string1 {include|exclude} string2 {include|exclude} [includeToEOF]
//
// Notes:
//   * Peeks at the top of the text stack, and attempts to extract the contents between
//     string1 and string2.  If found, the contents will be pushed onto the stack.
//   * The {include|exclude} modifiers designate whether string1 and string2 respectively
//     are included in the text that is pushed onto the stack.
//   * The 'includeToEOF' keyword is an optional value that will force PUSHBETWEEN to
//     to match everything up to the end of the input in the case where string2 cannot
//     be found. This is useful when trying to match lists with trailing delimiters but
//     the last delimiter may not be present.  See below for an example.
//
//   * Returns whether text was matched (ie. whether a new string was pushed onto the
//     text stack)
//
// Examples:
//   * Assuming '<p>xxx</p>' is on the text stack:
//       PUSHBETWEEN <p> include </p> exclude            ==>  '<p>xxx'
//   * Assuming '<p>xxx</p>' is on the text stack:
//       PUSHBETWEEN <X> exclude </X> include            ==>  no match found
//   * Assuming 'a,b,c' is on the text stack:
//       PUSHBETWEEN , exclude , exclude includeToEOF    ==> a
//       POPINTOVAR myarray
//       PUSHBETWEEN , exclude , exclude includeToEOF    ==> b
//       POPINTOVAR myarray
//       PUSHBETWEEN , exclude , exclude includeToEOF    ==> c
//       POPINTOVAR myarray
// ------------------------------------------------------------------------------------
@interface SKPushBetweenRule : SKRule

@end
