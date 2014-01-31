//
//  Deck.h
//  iFlashcards
//
//  Created by Ian Koller on 5/17/13.
//  Copyright (c) 2013 koller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject
@property(nonatomic, strong) NSMutableArray *cards;
@property(nonatomic, strong) NSString *name;
@end
