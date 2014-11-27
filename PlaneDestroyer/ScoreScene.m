//
//  ScoreScene.m
//  PlaneDestroyer
//
//  Created by Paulo Fernandes on 11/3/14.
//  Copyright (c) 2014 Paulo Fernandes. All rights reserved.
//

#import "ScoreScene.h"
#import "GameScene.h"

@implementation ScoreScene
-(instancetype) initWithSize:(CGSize)size
{
    SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Avenir"];
    title.fontColor = [SKColor colorWithHue:0 saturation:0 brightness:1 alpha:1.0];
    title.text = @"You scored 10 points";
    title.fontSize = 70;
    title.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    [self addChild:title];
    
    SKLabelNode *tapToPlay = [SKLabelNode labelNodeWithFontNamed:@"Avenir"];
    tapToPlay.fontSize = 40;
    tapToPlay.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    tapToPlay.fontColor = [SKColor colorWithHue:0 saturation:0 brightness:1 alpha:1.0];
    
    [self addChild:tapToPlay];
    
    return self;
}

- (void) touchesEnded: (NSSet * )touches withEvent:(UIEvent *) event
{
    GameScene *game = [[GameScene alloc] initWithSize:self.size];
    
    [self.view presentScene:game transition:[SKTransition doorsCloseHorizontalWithDuration:0.5]];
}
@end


