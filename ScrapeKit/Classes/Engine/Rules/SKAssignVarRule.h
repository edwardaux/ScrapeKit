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
//   * Variable pool handling is as follows:
//
//     srcValue = the existing value of 'srcVariableName' in the variable pool
//     dstValue = the existing value of 'dstVariableName' in the variable pool
//     if ('srcValue' is not set)
//       'srcVariableName' will be not be saved
//     else
//        if ('dstValue' is an NSString)
//          it will be replaced with 'srcValue'. 'propertyName' is ignored.
//        else if ('dstValue' is an NSMutableArray)
//          'srcValue' will be added to the end of the array. 'propertyName' is ignored.
//        else if ('dstValue' is an NSMutableDictionary)
//          'srcValue' will be added using 'propertyName' as a key.  If 'propertyName'
//          is not passed, 'srcVariable' will not be saved.
//        else
//          'srcValue' will be passed to the setValue:forKey method on 'dstValue'
//          using 'propertyName' as the key.  If 'propertyName' is not passed, 'srcValue'
//          will not be saved.
//
//   * Returns whether the variable is able to be saved.
// ------------------------------------------------------------------------------------
@interface SKAssignVarRule : SKRule

@end
