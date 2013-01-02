//
//  SKPopIntoVarRule.h
//  ScrapeKit
//
//  Created by Craig Edwards on 2/01/13.
//  Copyright (c) 2013 BlackDog Foundry. All rights reserved.
//

@class SKRule;

// ------------------------------------------------------------------------------------
// Usage:
//   POPINTOVAR variableName [propertyName]
//
// Notes:
//   * Pops a single SKTextBuffer off the text stack and saves it into the global
//     variable pool as 'variableName'.
//   * There are a number of different ways this function can be used:
//       * If variableName does not already exist in the pool, the value will be saved 
//         as an NSString. In this case, 'propertyName' is ignored.
//       * Otherwise, it will retrieve the existing value from the variable pool
//           * If the existing variable is an NSString, it will be replaced with the
//             new value. 'propertyName' is ignored.
//           * If the existing variable is an NSMutableArray, a new NSString element 
//             will be added to the end of the array.  'propertyName' is ignored.
//           * If the existing variable is an NSMutableDictionary, a new NSString value
//             will be added using 'propertyName' as a key.  If 'propertyName' is not
//             passed, the value will not be saved.
//           * Else an NSString value will be passed to the setValue:forKey method on
//             the existing variable using 'propertyName' as the key.  If 'propertyName'
//             is not passed, the value will be saved.
//   * If there is no buffer on the text stack, an empty string will be saved.
//   * Returns success, unless value is not able to be saved.
// ------------------------------------------------------------------------------------
@interface SKPopIntoVarRule : SKRule

@end
