//
//  SKPopRule.h
//  ScrapeKit
//
//  Created by Craig Edwards on 21/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

@class SKRule;

// ------------------------------------------------------------------------------------
// Usage:
//   POP
//
// Notes:
//   * Pops a single SKTextBuffer off the text stack.
//   * Returns success if there was a buffer on the stack, failure if the stack was
//     already empty.
// ------------------------------------------------------------------------------------
@interface SKPopRule : SKRule

@end
