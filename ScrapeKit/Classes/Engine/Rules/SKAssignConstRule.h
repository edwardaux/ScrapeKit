//
//  SKAssignConstRule.h
//  ScrapeKit
//
//  Created by Craig Edwards on 3/01/13.
//  Copyright (c) 2013 BlackDog Foundry. All rights reserved.
//

@class SKRule;

// ------------------------------------------------------------------------------------
// Usage:
//   ASSIGNCONST constant variableName [propertyName]
//
// Notes:
//   * Takes a constant and saves it into the global variable pool 
//   * Variable pool handling is as follows:
//
//     variable = the existing value of 'variableName' in the variable pool
//     if ('variable' is not set)
//       'constant' will be saved as an NSString. 'propertyName' is ignored.
//     else
//        if ('variable' is an NSString)
//          it will be replaced with 'constant'. 'propertyName' is ignored.
//        else if ('variable' is an NSMutableArray)
//          'constant' will be added to the end of the array. 'propertyName' is ignored.
//        else if ('variable' is an NSMutableDictionary)
//          'constant' will be added using 'propertyName' as a key.  If 'propertyName'
//          is not passed, 'constant' will not be saved.
//        else
//          'constant' will be passed to the setValue:forKey method on 'variable'
//          using 'propertyName' as the key.  If 'propertyName' is not passed, 'constant'
//          will not be saved.
//
//   * Returns whether the constant is able to be saved.
// ------------------------------------------------------------------------------------
@interface SKAssignConstRule : SKRule

@end
