//
//  GameOverScene.m
//  PlaneDestroyer
//
//  Created by Paulo Fernandes on 11/26/14.
//  Copyright (c) 2014 Paulo Fernandes. All rights reserved.
//
//gameoverWin.jpg can be found here : http://digital-art-gallery.com/oid/112/640x359_19374_Fleet_killer_titan_2d_sci_fi_alien_spaceship_titan_picture_image_digital_art.jpg
// gameoverLoose.jpg can be found here http://i.imgur.com/R23iJqB.jpg

// button_restart.png can be found here: http://opengameart.org/sites/default/files/styles/watermarked/public/button_restart.png




#import "GameOverScene.h"
#import "GameScene.h"

@implementation GameOverScene
-(id)initWithSize:(CGSize)size won:(BOOL)won {
    if (self = [super initWithSize:size]) {
    
        _my_size = size;
    
    
    self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    NSString * message;
    if (won) {
        message = @"You Won! ";
        NSString *message1 = @"Everyone is safe from the Markvits!";
        self.scaleMode = SKSceneScaleModeAspectFill;
        SKSpriteNode *background  = [SKSpriteNode spriteNodeWithImageNamed:@"gameoverWin.jpg"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        
        background.xScale = 1.7;
        background.yScale = 1.7;
        
        [self addChild:background];
        
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label.text = message;
        label.fontSize = 40;
        label.fontColor = [SKColor whiteColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:label];
        
        
        SKLabelNode *label1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label1.text = message1;
        label1.fontSize = 40;
        label1.fontColor = [SKColor whiteColor];
        label1.position = CGPointMake(self.size.width/2, self.size.height/2 -100);
        [self addChild:label1];
       
        SKSpriteNode *fireNode = [SKSpriteNode spriteNodeWithImageNamed:@"button_restart.png"];
        fireNode.position = CGPointMake(self.frame.size.width/2 ,self.frame.size.height/4);
        fireNode.name = @"fireButtonNode";//how the node is identified later
        fireNode.zPosition = 1.0;
        fireNode.xScale = 0.4;
        fireNode.yScale = 0.4;
        [self addChild:fireNode];
        
        
        
    } else {
        message = @"You Lose! ";
        NSString *message1 = @"The earth is now under Markvits' control! ";
        NSString * message2 = @"what a tragedy!";
        self.scaleMode = SKSceneScaleModeAspectFill;
        SKSpriteNode *background  = [SKSpriteNode spriteNodeWithImageNamed:@"gameoverLoose.jpg"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        
        background.xScale = 0.7;
        background.yScale = 0.7;
        
        [self addChild:background];
        
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        SKLabelNode *label1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        SKLabelNode *label2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        
        
        label.text = message;
        label.fontSize = 40;
        label.fontColor = [SKColor redColor];
        label.position = CGPointMake(self.size.width/2, self.size.height -200);
        [self addChild:label];
        
        label1.text = message1;
        label1.fontSize = 40;
        label1.fontColor = [SKColor redColor];
        label1.position = CGPointMake(self.size.width/2, self.size.height- 300);
        [self addChild:label1];
        
        label2.text = message2;
        label2.fontSize = 40;
        label2.fontColor = [SKColor redColor];
        label2.position = CGPointMake(self.size.width/2, self.size.height- 400);
        [self addChild:label2];
        
        SKSpriteNode *fireNode = [SKSpriteNode spriteNodeWithImageNamed:@"button_restart.png"];
        fireNode.position = CGPointMake(self.frame.size.width/2 ,self.frame.size.height/4);
        fireNode.name = @"fireButtonNode";//how the node is identified later
        fireNode.zPosition = 1.0;
        fireNode.xScale = 0.4;
        fireNode.yScale = 0.4;
        [self addChild:fireNode];
        
    }
//        self.scaleMode = SKSceneScaleModeAspectFill;
//        SKSpriteNode *background  = [SKSpriteNode spriteNodeWithImageNamed:@"mainbackground.png"];
//        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
//        
//        
//        background.xScale = 1.3;
//        background.yScale = 1.3;
//        
//        [self addChild:background];
//        
//        
//        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//        label.text = message;
//        label.fontSize = 40;
//        label.fontColor = [SKColor blackColor];
//        label.position = CGPointMake(self.size.width/2, self.size.height/2);
//        [self addChild:label];
        
//        [self runAction:
//         [SKAction sequence:@[
//                              [SKAction waitForDuration:3.0],
//                              [SKAction runBlock:^{
//             
//             SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
//             SKScene * myScene = [[GameScene alloc] initWithSize:size] ;
//             [self.view presentScene:myScene transition: reveal];
//         }]
//                              ]]
//         ];
    
    }
  
    
    return self;
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"fireButtonNode"]) {
        
        [self runAction:
         [SKAction sequence:@[
                              
                              [SKAction runBlock:^{
             
             SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
             SKScene * myScene = [[GameScene alloc] initWithSize:_my_size] ;
             [self.view presentScene:myScene transition: reveal];
         }]
                              ]]
         ];
    }
    
}
@end
