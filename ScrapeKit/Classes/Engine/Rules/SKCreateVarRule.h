//
//  SKCreateVarRule.h
//  ScrapeKit
//
//  Created by Craig Edwards on 3/01/13.
//  Copyright (c) 2013 BlackDog Foundry. All rights reserved.
//

@class SKRule;

// ------------------------------------------------------------------------------------
// Usage:
//   CREATEVAR variableName className
//
// Notes:
//   * Creates an instance of 'className' and assigns it to 'variableName'
//   * 'className' must be resolvable using NSClassFromString() and must be able to
//     be instantiated using +(id)alloc and -(id)init
//   * Note that you can't create and assign a variable directly to a container
//     object (such as an NSDictionary or a normal object using KVC).  You need to
//     create it as a temporary object first, and then assign it using ASSIGNVAR
//     once it has beeen populated.
//   * Returns success if the variable is able to be created, failure otherwise.
// ------------------------------------------------------------------------------------
@interface SKCreateVarRule : SKRule

@end
