//
//  StudySessionViewController.h
//  iFlashcards
//
//  Created by Ian Koller on 5/16/13.
//  Copyright (c) 2013 koller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "Card.h"
#import "BButton.h"

@interface StudySessionViewController : UIViewController
@property(nonatomic, strong) Deck *sentDeck;
@property bool onQuestion;
@property(nonatomic, strong) UIView *flashCard;
@property(nonatomic, strong) Card *currentCard;
@property(nonatomic, strong) UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentlyStudyingLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardsLeftLabel;
@property int currentCardIndex;
@property(nonatomic, strong) BButton *wrongButton;
@property(nonatomic, strong) BButton *rightButton;
@property(nonatomic, strong) BButton *skipButton;
@property(nonatomic, strong) NSMutableArray *studyCards;

@end
