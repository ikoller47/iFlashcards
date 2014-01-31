//
//  StudySessionViewController.m
//  iFlashcards
//
//  Created by Ian Koller on 5/16/13.
//  Copyright (c) 2013 koller. All rights reserved.
//

#import "StudySessionViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface StudySessionViewController ()

@end

@implementation StudySessionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setShowsTouchWhenHighlighted:YES];
    UIImage *backBtnImage = [UIImage imageNamed:@"5-blue-back-button.png"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 55, 44);
    UIBarButtonItem *backButton2 = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton2;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"5-blue-background.jpg"]];
    
    _flashCard = [[UIView alloc] initWithFrame:CGRectMake(20.0, 70.0, 280.0, 175.0)];
    _flashCard.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_flashCard];
    
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchButton addTarget:self
                     action:@selector(switchView:)
     forControlEvents:UIControlEventTouchDown];
    switchButton.frame = CGRectMake(0.0, 0.0, 280.0, 175.0);        
    [_flashCard addSubview:switchButton];
    
    _cardLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 20.0, 240.0, 140.0)];
    _cardLabel.text = @"This is a test of the label.  This is a test of the label.  This is a test of the label.  This is a test of the label.";
    _cardLabel.numberOfLines = 0;
    _cardLabel.textAlignment = NSTextAlignmentCenter;
    [_flashCard addSubview:_cardLabel];
    
    [_flashCard.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_flashCard.layer setBorderWidth:1.5f];
    [_flashCard.layer setShadowColor:[UIColor blackColor].CGColor];
    [_flashCard.layer setShadowOpacity:0.8];
    [_flashCard.layer setShadowRadius:3.0];
    [_flashCard.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    _currentlyStudyingLabel.text = [NSString stringWithFormat:@"Currently Studying %@", _sentDeck.name];
    
    _cardsLeftLabel.text = [NSString stringWithFormat:@"Cards Left: %lu", (unsigned long)[_sentDeck.cards count]];
    
    _skipButton = [[BButton alloc] initWithFrame:CGRectMake(20, 300, 280, 44) type:BButtonTypeInverse];
    
    [_skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    
    [_skipButton addTarget:self
                         action:@selector(skipPressed)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_skipButton];
    
    _wrongButton = [[BButton alloc] initWithFrame:CGRectMake(20, 300, 130, 44) type:BButtonTypeInverse];
    
    [_wrongButton setTitle:@"Try Again" forState:UIControlStateNormal];
    
    [_wrongButton addTarget:self
                   action:@selector(skipPressed)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_wrongButton];
    
    _rightButton = [[BButton alloc] initWithFrame:CGRectMake(170, 300, 130, 44) type:BButtonTypeInverse];
    
    [_rightButton setTitle:@"Got It!" forState:UIControlStateNormal];
    
    [_rightButton addTarget:self
                   action:@selector(rightPressed)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightButton];
    
    
    [self setupSession];
    
}

-(void)setupSession{
    _onQuestion = YES;
    _currentCardIndex = 0;
    _studyCards = [[NSMutableArray alloc] initWithArray:_sentDeck.cards];
    _currentCard = [_studyCards objectAtIndex:_currentCardIndex];
    _cardLabel.text = _currentCard.question;
    _wrongButton.enabled = NO;
    _wrongButton.hidden = YES;
    _rightButton.enabled = NO;
    _rightButton.hidden = YES;
}

-(void)skipPressed{
    NSLog(@"Index: %d  Count: %lu", _currentCardIndex, (unsigned long)[_studyCards count]);
    if(_currentCardIndex < ([_studyCards count] - 1)){
        _currentCardIndex += 1;
        
    }
    else{
        _currentCardIndex = 0;
    }

    _currentCard = [_studyCards objectAtIndex:_currentCardIndex];
    _onQuestion = NO;
    [self switchView:nil];
    
}

-(void)rightPressed{
    [_studyCards removeObject:_currentCard];
    if(![_studyCards count]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Great Job!"
                              message: @"It looks like you know your stuff."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        if(_currentCardIndex > ([_studyCards count] - 1)){
            _currentCardIndex = 0;
            
        }

        _currentCard = [_studyCards objectAtIndex:_currentCardIndex];
        _onQuestion = NO;
        _cardsLeftLabel.text = [NSString stringWithFormat:@"Cards Left: %lu", (unsigned long)[_studyCards count]];
        [self switchView:nil];
    }
    
}

- (IBAction)switchView:(id)sender {
    
    if(_onQuestion){
        [UIView beginAnimations:@"View Flip" context:nil];
        [UIView setAnimationDuration:.7];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:_flashCard cache:YES];
        _cardLabel.text = _currentCard.answer;
        _onQuestion = NO;
        _wrongButton.enabled = YES;
        _wrongButton.hidden = NO;
        _rightButton.enabled = YES;
        _rightButton.hidden = NO;
        _skipButton.enabled = NO;
        _skipButton.hidden = YES;
        
    }
    else{
        [UIView beginAnimations:@"View Flip" context:nil];
        [UIView setAnimationDuration:.7];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:_flashCard cache:YES];
        _cardLabel.text = _currentCard.question;
        _onQuestion = YES;
        _wrongButton.enabled = NO;
        _wrongButton.hidden = YES;
        _rightButton.enabled = NO;
        _rightButton.hidden = YES;
        _skipButton.enabled = YES;
        _skipButton.hidden = NO;
        
    }
    
    [UIView commitAnimations];
}


-(void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
