//
//  SecondScene.h
//  PlaneDestroyer
//
//  Created by Paulo Fernandes on 11/30/14.
//  Copyright (c) 2014 Paulo Fernandes. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SplashScreenViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "GameOverScene.h"


static const uint8_t bulletCategory2 = 1;
static const uint8_t enemyCategory2 = 2;
static const uint8_t planeCategory2 = 3;

@interface SecondScene : SKScene<SKPhysicsContactDelegate>
{
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    int score;
    
}
@property (weak, nonatomic) SplashScreenViewController *splashScreenViewController;
@property (nonatomic) int monstersDestroyed;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property NSMutableArray *explosionTextures;

@property SKSpriteNode *plane;
@property AVAudioPlayer *player_music;

@end
