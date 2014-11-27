//
//  GameScene.h
//  PlaneDestroyer
//

//  Copyright (c) 2014 Paulo Fernandes. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SplashScreenViewController.h"
#import <AVFoundation/AVFoundation.h>

static const uint8_t bulletCategory = 1;
static const uint8_t enemyCategory = 2;
static const uint8_t planeCategory = 3;

@interface GameScene : SKScene<SKPhysicsContactDelegate>
{
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    int score;
    
}
@property (weak, nonatomic) SplashScreenViewController *splashScreenViewController;


@property SKSpriteNode *plane;
@property AVAudioPlayer *player;

@end
