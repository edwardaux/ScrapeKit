//
//  SKBreakpointRule.h
//  ScrapeKit
//
//  Created by Craig Edwards on 19/02/13.
//  Copyright (c) 2013 BlackDog Foundry. All rights reserved.
//

@class SKRule;

// ------------------------------------------------------------------------------------
// Usage:
//   BREAK
//
// Notes:
//   * A no-op rule that allows developers to set a break point, and have Xcode stop
//     so they can then inspect the va	riable pool, the text stack, etc.
//
//   * Returns YES always
// ------------------------------------------------------------------------------------
@interface SKBreakpointRule : SKRule

@end
