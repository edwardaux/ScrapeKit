//
//  SKSetVarRule.h
//  ScrapeKit
//
//  Created by Craig Edwards on 3/01/13.
//  Copyright (c) 2013 BlackDog Foundry. All rights reserved.
//

@class SKRule;

// ------------------------------------------------------------------------------------
// Usage:
//   SETVAR constant variableName [propertyName]
//
// Notes:
//   * Takes the constant saves it into the global variable pool as 'variableName'.
//   * There are a number of different ways this function can be used:
//       * Using the constant value provided:
//           * If 'variableName' is an NSString, it will be replaced with the
//             new value. 'propertyName' is ignored.
//           * If 'variableName' is an NSMutableArray, a new element will be added
//             to the end of the array.  'propertyName' is ignored.
//           * If 'variableName' is an NSMutableDictionary, a new value will be
//             added using 'propertyName' as a key.  If 'propertyName' is not passed,
//             the value will not be saved.
//           * Else the value of the constant will be passed to the setValue:forKey
//             method on the existing variable using 'propertyName' as the key.  If
//             'propertyName' is not passed, the value will be saved.
//   * Returns success, unless value is not able to be saved.
// ------------------------------------------------------------------------------------
@interface SKSetVarRule : SKRule

@end
