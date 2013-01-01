//
//  SKGotoRule.h
//  ScrapeKit
//
//  Created by Craig Edwards on 20/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

@class SKRule;

// ------------------------------------------------------------------------------------
// Usage:
//   GOTO :labelname
//
// Notes:
//   * Changes the current execution location to the identified label
//   * Returns success if the label is found, failure otherwise.
// ------------------------------------------------------------------------------------
@interface SKGotoRule : SKRule

@end
