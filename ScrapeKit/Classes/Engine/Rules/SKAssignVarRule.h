//
//  SKAssignVarRule.h
//  ScrapeKit
//
//  Created by Craig Edwards on 3/01/13.
//  Copyright (c) 2013 BlackDog Foundry. All rights reserved.
//

@class SKRule;

// ------------------------------------------------------------------------------------
// Usage:
//   ASSIGNVAR srcVariableName dstVariableName [propertyName]
//
// Notes:
//   * Takes the variable identified by srcVariableName and saves it into the global
//     variable pool as 'dstVariableName'.
//   * There are a number of different ways this function can be used:
//       * It will retrieve the value of 'srcVariableName' from the variable pool and
//           * If 'dstVariableName' is an NSString, it will be replaced with the
//             new value. 'propertyName' is ignored.
//           * If 'dstVariableName' is an NSMutableArray, a new element will be added
//             to the end of the array.  'propertyName' is ignored.
//           * If 'dstVariableName' is an NSMutableDictionary, a new value will be
//             added using 'propertyName' as a key.  If 'propertyName' is not passed,
//             the value will not be saved.
//           * Else the value of 'srcVariableName' will be passed to the setValue:forKey
//             method on the existing variable using 'propertyName' as the key.  If
//             'propertyName' is not passed, the value will be saved.
//   * If there is no variable named 'srcVariableName', no processing will occur.
//   * Returns success, unless value is not able to be saved.
// ------------------------------------------------------------------------------------
@interface SKAssignVarRule : SKRule

@end
