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
//   * Variable pool handling is as follows:
//
//     stackValue = the value popped off the text stack (will use "" if stack is empty)
//     variable = the existing value of 'variableName' in the variable pool
//     if ('variable' is not set)
//       'stackValue' will be saved as an NSString. 'propertyName' is ignored.
//     else
//        if ('variable' is an NSString)
//          it will be replaced with 'stackValue'. 'propertyName' is ignored.
//        else if ('variable' is an NSMutableArray)
//          'stackValue' will be added to the end of the array. 'propertyName' is ignored.
//        else if ('variable' is an NSMutableDictionary)
//          'stackValue' will be added using 'propertyName' as a key.  If 'propertyName'
//          is not passed, 'stackValue' will not be saved.
//        else
//          'stackValue' will be passed to the setValue:forKey method on 'variable'
//          using 'propertyName' as the key.  If 'propertyName' is not passed, 'stackValue'
//          will not be saved.
//
//   * Returns whether the stack value is able to be saved.
// ------------------------------------------------------------------------------------
@interface SKPopIntoVarRule : SKRule

@end
