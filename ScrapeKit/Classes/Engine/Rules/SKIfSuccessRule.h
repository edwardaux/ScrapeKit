//
//  SKIfSuccessRule.h
//  ScrapeKit
//
//  Created by Craig Edwards on 2/01/13.
//  Copyright (c) 2013 BlackDog Foundry. All rights reserved.
//

@class SKRule;

// ------------------------------------------------------------------------------------
// Usage:
//   IFSUCCESS labelname
//
// Notes:
//   * Changes the current execution location to the identified label if the previously
//     executed rule returned successfully
//   * Returns success if the label is found, failure otherwise.
// ------------------------------------------------------------------------------------
@interface SKIfSuccessRule : SKRule

@end
