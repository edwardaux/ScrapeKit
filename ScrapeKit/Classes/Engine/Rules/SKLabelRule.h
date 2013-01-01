//
//  SKLabelRule.h
//  ScrapeKit
//
//  Created by Craig Edwards on 20/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

@class SKRule;

// ------------------------------------------------------------------------------------
// Usage:
//   :labelname
//
// Notes:
//   * Identifies a label within the current function.
//   * Must contain a leading colon.
//   * Does nothing other than identify a label location.
//   * Returns success always
// ------------------------------------------------------------------------------------
@interface SKLabelRule : SKRule

-(NSString *)label;

@end
