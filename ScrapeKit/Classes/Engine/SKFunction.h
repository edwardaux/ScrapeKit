//
//  SKFunction.h
//  ScrapeKit
//
//  Created by Craig Edwards on 19/12/12.
//  Copyright (c) 2012 BlackDog Foundry. All rights reserved.
//

@class SKEngine;
@class SKRule;

@interface SKFunction : NSObject

@property (nonatomic, weak)   SKEngine *engine;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *rules;

-(id)initWithEngine:(SKEngine *)engine name:(NSString *)name;
-(void)addRule:(SKRule *)rule;

@end
