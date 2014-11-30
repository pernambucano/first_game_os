//
//  GameScene.m
//  PlaneDestroyer
//
//  Created by Paulo Fernandes on 11/1/14.
//  Copyright (c) 2014 Paulo Fernandes. All rights reserved.
//

#import "GameScene.h"
//#import "ScoreScene.h"
#import "SecondScene.h"
#import "SplashScreenViewController.h"



@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    self.scaleMode = SKSceneScaleModeAspectFill;
    
  
    
    if(![_player isPlaying]){
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"loop2" ofType:@"mp3"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        _player.numberOfLoops = -1; //infinite
        [_player play];
    }
    
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    
    screenWidth = screenRect.size.width;
    
//    NSLog(@"%f, %f", screenWidth, screenHeight);
    
    _plane = [SKSpriteNode spriteNodeWithImageNamed:@"player.png"];
    
    
    _plane.position = CGPointMake(_plane.size.width/2, self.frame.size.height/2);
    _plane.zPosition = 2;
    
    _plane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_plane.size];
    _plane.physicsBody.dynamic = NO;
    _plane.physicsBody.categoryBitMask = planeCategory;
    _plane.physicsBody.contactTestBitMask = enemyCategory;
    _plane.physicsBody.collisionBitMask = 0;
    _plane.xScale = 1;
    _plane.yScale = 1;
    
    //Begin of Animate Player
    SKTexture *baseTexture = [SKTexture textureWithImageNamed:@"shipAnimation.png"];
    NSMutableArray *mAnimatingFrames = [NSMutableArray array];
    
    float sx = 0;
    float sy = 0;
    float sWidth = 115;
    float sHeight = 69;
    
    for (int i=0; i < 8 ; i++) {
        CGRect cutter = CGRectMake(sx, sy/baseTexture.size.width, sWidth/baseTexture.size.width, sHeight/baseTexture.size.height);
        SKTexture *temp = [SKTexture textureWithRect:cutter inTexture:baseTexture];
        [mAnimatingFrames addObject:temp];
        sx+=sWidth/baseTexture.size.width;
    }
    
    SKAction *animate = [SKAction animateWithTextures:mAnimatingFrames timePerFrame:0.1];
    SKAction *moveForever = [SKAction repeatActionForever:animate];
    
    [_plane runAction:moveForever];
    
    //End of Animate Player
    
    [self addChild:_plane];
    
    //Explosion animation loading
    SKTexture *baseTexture_explosion = [SKTexture textureWithImageNamed:@"explosion.png"];
    _explosionTextures = [NSMutableArray array];
    //NSLog(@"%f", baseTexture_explosion.size.width);
    float sizeX = 0;
    float sizeY = 0;
    float sizeWidth = 133.5;
    float sizeHeight = 134;
    //SKTexture *first;
    for (int i=0; i < 12 ; i++) {
        CGRect cutter = CGRectMake(sizeX, sizeY/baseTexture_explosion.size.width, sizeWidth/baseTexture_explosion.size.width, sizeHeight/baseTexture_explosion.size.height);
        
        SKTexture *temp = [SKTexture textureWithRect:cutter inTexture:baseTexture_explosion];
        [_explosionTextures addObject:temp];
        //NSLog(@"%d added", i);
        sizeX+=sizeWidth/baseTexture_explosion.size.width;
    }
    
  
    //NSLog([_explosionTextures objectAtIndex:0]);
    
    
    //end of Explosion animation loading
    
    
    SKSpriteNode *background  = [SKSpriteNode spriteNodeWithImageNamed:@"mainbackground.png"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    
    background.xScale = 1.3;
    background.yScale = 1.3;
    
    [self addChild:background];
    
    
    //schedule enemies
    
    SKAction *wait = [SKAction waitForDuration:1];
    SKAction *callEnemies = [SKAction runBlock:^{
        [self Enemies];
    }];
    
    SKAction *updateEnemies = [SKAction sequence:@[wait, callEnemies]];
    [self runAction:[SKAction repeatActionForever:updateEnemies]];
    
    //adding scores
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _scoreLabel.text = @"Score : 0 /20";
    _scoreLabel.color =  [SKColor whiteColor];
    _scoreLabel.fontSize = 28;
    _scoreLabel.zPosition = 2;
    _scoreLabel.horizontalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _scoreLabel.position = CGPointMake(_plane.size.width/2, self.frame.size.height/6);
    [self addChild:_scoreLabel];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
}


-(void)addScore {
    NSMutableArray *scores = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"scores"]];
    [scores addObject:@{@"name" : self.splashScreenViewController.userName.text,
                        @"score" : @(score)}];
    [[NSUserDefaults standardUserDefaults] setObject:scores forKey:@"scores"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void) Enemies {
    int go = [self getRandomNumberBetween:0 to:1];

    if(go == 1){
        
        SKSpriteNode *enemy;
        //SKNodeEnemy *enemy;
        enemy = [SKSpriteNode spriteNodeWithImageNamed:@"mine.png"];
        //enemy.position = CGPointMake(screenRect.size.width*1.4, screenRect.size.height);
        enemy.zPosition = 1;
        enemy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:enemy.size];
        enemy.physicsBody.dynamic = YES;
        enemy.physicsBody.categoryBitMask = enemyCategory;
        enemy.physicsBody.contactTestBitMask = bulletCategory;
        enemy.physicsBody.collisionBitMask = 0;
        //enemy.collided = NO;
        //enemy.userData = @"something";

        // Determine where to spawn the monster along the Y axis
        int minY = 2*enemy.size.height;
        int maxY = self.frame.size.height - 2*enemy.size.height;
        int rangeY = maxY - minY;
        int actualY = (arc4random() % rangeY) + minY;
        
        enemy.position = CGPointMake(self.frame.size.width + enemy.size.width/2, actualY);
//        
//        CGMutablePathRef cgpath = CGPathCreateMutable();
//        
//        //random values
//        float xStart = [self getRandomNumberBetween:0+enemy.size.width to:screenRect.size.width-enemy.size.width];
//        //printf("%f/n", xStart);
//        float xEnd = [self getRandomNumberBetween:0+enemy.size.width to:screenRect.size.width-enemy.size.width];
//        
//        //ControlPoint1
//        float cp1X = [self getRandomNumberBetween:0+enemy.size.width to:screenRect.size.width-enemy.size.width];
//        float cp1Y = [self getRandomNumberBetween:0+enemy.size.width to:screenRect.size.width-enemy.size.width ];
//        
//        //ControlPoint2
//        float cp2X = [self getRandomNumberBetween:0+enemy.size.height to:screenRect.size.height-enemy.size.height ];
//        float cp2Y = [self getRandomNumberBetween:0 to:cp1Y];
//        
//        CGPoint s = CGPointMake( 1050.0, xStart*2);
//        CGPoint e = CGPointMake(-xEnd, 500.0);
//        CGPoint cp1 = CGPointMake(cp1X, cp1Y);
//        CGPoint cp2 = CGPointMake(cp2X, cp2Y);
//        CGPathMoveToPoint(cgpath,NULL, s.x, s.y);
//        CGPathAddCurveToPoint(cgpath, NULL, cp1.x, cp1.y, cp2.x, cp2.y, e.x, e.y);
        
     //   SKAction *planeDestroy = [SKAction followPath:cgpath asOffset:NO orientToPath:YES duration:7];
//        SKAction *planeD = [SKAction followPath:cgpath asOffset:NO orientToPath:YES duration:5];
        [self addChild:enemy];
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(-enemy.size.width/2, actualY) duration:7];
        SKAction *remove = [SKAction removeFromParent];
        //[enemy runAction:[SKAction sequence:@[actionMove,remove]]];
        
        SKAction * loseAction = [self won:NO];
        [enemy runAction:[SKAction sequence:@[actionMove, loseAction, remove]]];
        
//        CGPathRelease(cgpath);
        
    }
}

-(SKAction *)won:(BOOL)won_ {
    
    if(!won_) {
    
        SKAction * loseAction = [SKAction runBlock:^{
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
            [self.view presentScene:gameOverScene transition: reveal];
            
                    [_player stop];
            
            
            
        }];
        return loseAction;
}
    else {
        SKAction * loseAction = [SKAction runBlock:^{
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            SKScene * Secondscene = [[SecondScene alloc] initWithSize:self.size ];
            [self.view presentScene:Secondscene transition: reveal];
            
            [_player stop];
            
        }];
        return loseAction;

    }
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & bulletCategory) != 0)
    {
        if(secondBody.contactTestBitMask == bulletCategory)
        {
            _monstersDestroyed++;
        }
        secondBody.contactTestBitMask = 0;
    
        CGPoint position=   CGPointMake(contact.bodyA.node.position.x, contact.bodyA.node.position.y);
        [_scoreLabel setText:[NSString stringWithFormat:@"Score: %d /20", _monstersDestroyed]];
        SKNode *projectile = (contact.bodyA.categoryBitMask & bulletCategory) ? contact.bodyA.node : contact.bodyB.node;
        SKNode *enemy = (contact.bodyA.categoryBitMask & bulletCategory) ? contact.bodyB.node : contact.bodyA.node;
        [projectile runAction:[SKAction removeFromParent]];
        [enemy runAction:[SKAction playSoundFileNamed:@"explosion_lw.wav" waitForCompletion:NO ]];
        if (self.monstersDestroyed >= 3) {
            [enemy runAction:[self won:YES]];
            //            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            //            SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:YES];
            //            [self.view presentScene:gameOverScene transition: reveal];
        }
        
        //[SKAction waitForDuration:3];
        [enemy runAction:[SKAction removeFromParent]];
        
        SKSpriteNode *explosion = [SKSpriteNode spriteNodeWithTexture:[_explosionTextures objectAtIndex:0]];
//        SKSpriteNode *explosion = [SKSpriteNode spriteNodeWithImageNamed:@"mine.png"];
        explosion.zPosition = 1;
        //explosion.scale = 0.6;
        explosion.position = position;
        
        [self addChild:explosion];
//
        SKAction *explosionAction = [SKAction animateWithTextures:_explosionTextures timePerFrame:0.07];
//
        SKAction *remove = [SKAction removeFromParent];
        [explosion runAction:[SKAction sequence:@[explosionAction,remove]]];
       
        
    }
    
    //user dies
    else  if ((firstBody.categoryBitMask &  planeCategory) != 0)
    {
        CGPoint position=   CGPointMake(contact.bodyA.node.position.x, contact.bodyA.node.position.y);
        SKNode *plane = (contact.bodyA.categoryBitMask & planeCategory) ? contact.bodyA.node : contact.bodyB.node;
        SKNode *enemy = (contact.bodyA.categoryBitMask & planeCategory) ? contact.bodyB.node : contact.bodyA.node;
        
        
        [plane runAction:[SKAction removeFromParent]];
        [enemy runAction:[SKAction removeFromParent]];
        
        SKSpriteNode *explosion = [SKSpriteNode spriteNodeWithTexture:[_explosionTextures objectAtIndex:0]];
        //        SKSpriteNode *explosion = [SKSpriteNode spriteNodeWithImageNamed:@"mine.png"];
        explosion.zPosition = 1;
        //explosion.scale = 0.6;
        explosion.position = position;
        
        [self addChild:explosion];
        //
        SKAction *explosionAction = [SKAction animateWithTextures:_explosionTextures timePerFrame:0.07];
        //
        
        SKAction *wait = [SKAction waitForDuration:1];
        SKAction *remove = [SKAction removeFromParent];
        [explosion runAction:[SKAction sequence:@[explosionAction,remove ]]];
    
        [self runAction:wait completion:^
         {[self runAction:[self won:NO]];}];
        
        
       // [plane runAction:[self won:NO]];
        
//        GameScene *game = [[GameScene alloc] initWithSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
//        
//
//            [self.view presentScene:game transition:[SKTransition doorsCloseHorizontalWithDuration:0.5]];
        
    }

}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //We wont use this for the final project
    [_plane runAction:[SKAction moveTo:[[touches anyObject] locationInNode:self] duration:0.1]];
    
    //Bullets
    CGPoint location = [_plane position];
    SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithImageNamed:@"laser.png"];
    
    bullet.position = CGPointMake(location.x+_plane.size.width/2,location.y);
    //bullet.position = location;
    bullet.zPosition = 1;
    bullet.scale = 0.8;
    bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bullet.size];
    bullet.physicsBody.dynamic = NO;
    bullet.physicsBody.categoryBitMask = bulletCategory;
    bullet.physicsBody.contactTestBitMask = enemyCategory;
    bullet.physicsBody.collisionBitMask = 0;
    //bullet.physicsBody.velocity = CGVectorMake(10, 0);
 
    
    SKAction *action = [SKAction moveToX:self.frame.size.width+bullet.size.height duration:3];
    SKAction *remove = [SKAction removeFromParent];
    
    [bullet runAction:[SKAction sequence:@[action,remove]]];
    
    [self addChild:bullet];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
