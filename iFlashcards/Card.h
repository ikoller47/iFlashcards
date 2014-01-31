//
//  Card.h
//  iFlashcards
//
//  Created by Ian Koller on 5/17/13.
//  Copyright (c) 2013 koller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject
@property(nonatomic, strong) NSString *question;
@property(nonatomic, strong) NSString *answer;
@end
