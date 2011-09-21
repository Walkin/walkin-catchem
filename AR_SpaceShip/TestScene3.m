//
//  AboutScene.m
//  FunnyShake
//
//  Created by Oliver on 3/14/11.
//  Copyright 2011 iTeam . All rights reserved.


#import "TestScene3.h"
#import "SimpleAudioEngine.h"
#import "Catchable.h"
#import "CombineMovement.h"
#import "StableCatchable.h"
#import "MainMenuScene.h"
#import "AppDelegate.h"
#import "PauseLayer3.h"
#import "CCSlider.h"
#import "CCUIViewWrapper.h"
#import "DesignValues.h"
#import "Tag.h"


@implementation TestScene3



-(id) init
{
	self = [super init];
	if (self != nil)
	{
		[self addChild:[TestLayer3 node] z:0 tag:kTestLayer3Tag];
	}
	return self;
	
}


-(void) dealloc
{
	[super dealloc];
}

@end

@implementation TestLayer3


-(id) init
{
	
	if( (self=[super init] )) {
        
     //   self.isAccelerometerEnabled = YES;
        

/////////////////////////////Create the pause layer//////////////////////////////
        p = [[[PauseLayer3 alloc]init]autorelease];
        [self addChild:p z:10];
        p.visible = NO;
        
        [p.mnuBackToMenu setIsEnabled:NO];
        
        MaximumYaw = 45;
        
        [self addMenuItems];
        [self dataInitialize];
		
		[[CCDirector sharedDirector] setDisplayFPS:NO];
        
      //  [self presentWinCondition];
      //   [self presentCoreMotionData];
        
        [self addScopeCrosshairs];
        
        
        // Allow touches with the layer
        [self registerWithTouchDispatcher];

        
        [self addAudio];
        
        [self addRadar];
        
        [self scheduleUpdate];
        
        ///////////////////////////Show Ready,Set,Go before start playing game/////////////////////////
        [self startGame];
        
     //   [self addScoreLabel];
    

        
	}
	return self;
}


-(void)update:(ccTime)delta {
    
    
    //NSLog(@"The catchable count is %d", catchableCount);
    
    changePic = (int)(CCRANDOM_0_1()*10);
    
    CMDeviceMotion *currentDeviceMotion = motionManager.deviceMotion;
    CMAttitude *currentAttitude = currentDeviceMotion.attitude;
    
    
    yaw = (float)(CC_RADIANS_TO_DEGREES(currentAttitude.yaw));
    float roll = (float)(CC_RADIANS_TO_DEGREES(currentAttitude.roll));
    
    [yawLabel setString:[NSString stringWithFormat:@"Yaw: %.0f", yaw]];
    [rollLabel setString:[NSString stringWithFormat:@"roll: %.0f", roll]];
    
    
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        [self checkCatchablePositionX:catchable withYaw:yaw];
        [self checkCatchablePositionY:catchable withRoll:roll];
        
     //   NSLog(@"Yaw: %f, Roll: %f ", catchable.position.x, catchable.position.y);
        
        
        [catchable radarSystem];
    }
}



-(void) ChangeCloths: (id) sender
{
    
    //  NSLog(@"the num of change pic is %d",changePic);
    NSString *spritePic = [NSString stringWithFormat:@"stableCatchable_00%d.png", changePic];
    
    
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        
        
        [catchable setTexture:[[CCTextureCache sharedTextureCache] addImage:spritePic]];
        
    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    
    UIAlertView *alert;
    
    // Unable to save the image  
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                           message:@"Unable to save image to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success" 
                                           message:@"Image saved to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}


- (void)captureScreen: (id) sender
{
    CGImageRef screen = UIGetScreenImage();
    UIImage* image = [UIImage imageWithCGImage:screen];
    CGImageRelease(screen);
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"takePicture.mp3"];
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}


-(void) MoveUp: (id) sender
{
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        
        
        catchable.rollPosition -= 1.0;
        
    }
    
}

-(void) MoveDown: (id) sender
{
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        
        
        catchable.rollPosition += 1.0;
        
    }
    
}

-(void) MoveLeft: (id) sender
{
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        
        
        catchable.yawPosition += 1.0;
        
    }
}

-(void) MoveRight: (id) sender
{
    
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        
        
        catchable.yawPosition -= 1.0;
        
    }
    
}


-(void) ScaleBig: (id) sender
{
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        
        catchable.scale += 0.1;
        
    }
    
}


-(void) ScaleSmall: (id) sender
{
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        
        catchable.scale -= 0.1;
        
    }
    
}



-(void)removeSpriteAndAddCatchemSpritesBegin:(CCNode *)n
{


    
    catchableCount = 0;
    

    
//    for(int i = 0; i < [[DesignValues sharedDesignValues]getFloaterCombined]; i++) {
      for(int i = 0; i < 1; i++) {
        Catchable *catchable = [self addStableCatchable:i];
        [[DesignValues sharedDesignValues].catchableSprites  addObject:catchable];
        catchableCount += 1;
        catchable.MaximumYaw = 45;
        [catchable addRedSpot];
        [self addChild:catchable.redSpot z:4];
        
    }
    
    enableTouch = YES;
    
    
}


-(Catchable *)addStableCatchable:(int)shipTag{
    
    Catchable *catchable;
    
    int picChoose = (int)(CCRANDOM_0_1()*10);
    
    
    float x;
    float y;
    float randomX;
    float randomY;
    x = 0;
    y = 0;
    
    catchable = [StableCatchable spriteWithFile:[NSString stringWithFormat:@"stableCatchable_00%d.png",picChoose]];
    StableCatchableCount += catchable.StableCount;
    
    randomX = CCRANDOM_MINUS1_1()*MaximumYaw;
    randomY = -CCRANDOM_0_1()*100;
    
    if (yaw <= -0.0 && yaw >= -180.0) {
        yaw = yaw +360.0;
    }
    
    
    x = randomX + yaw;
    
    
    while ( randomY > -10 && randomY < -150 ) {
        randomY = -CCRANDOM_0_1()*100;
    }
    
    y = randomY;
    
    
    //    catchable.yawPosition = x;   
    //    catchable.rollPosition = y;
    CGPoint positionPoint = ccp(x, y);
    [catchable setInitialPosition:positionPoint];
    
    // Set the position of the space ship off the screen
    // we will update it in another method
    [catchable setPosition:ccp(5000, 5000)];
    
    catchable.visible = true;
    
    
    [self addChild:catchable z:3 tag:shipTag];
    
    ///////////////////////////Make catchable Wave itself/////////////////////// 
    
 //       id waves = [CCWaves actionWithWaves:5 amplitude:20 horizontal:YES vertical:NO grid:ccg(15,10) duration:5];
 //       [catchable runAction: [CCRepeatForever actionWithAction: waves]];
    
    return catchable;
}



-(void) GoToPauseLayer
{
    
    [self unschedule:@selector(GoToPauseLayer)];
    
    p.visible = YES;
    [p.mnuBackToMenu setIsEnabled:YES];
    [self pauseSchedulerAndActions];
    playTouchSound = NO;
    
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        [catchable pauseSchedulerAndActions];
    }
    

}



#pragma mark Accelerometer Input

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	
	
	const float violence = 1.8;
	static BOOL beenhere;
	BOOL shake = FALSE;
    
    
	if (beenhere) return;
	beenhere = TRUE;
    
    CGPoint location = CGPointMake(240,160);
    
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        
        // Check to see if yaw position is in range
        BOOL wasTouched = [self circle:location withRadius:50 collisionWithCircle:catchable.position collisionCircleRadius:50];
        
        if(wasTouched)
        {
            catchable.EnableCatchTimer = [[DesignValues sharedDesignValues]getEnableCatchTimer];
            //  NSLog(@"I am in the scope!");
        }
        
    }
    
//	if (acceleration.x > violence * 0.6 || acceleration.x < (-1.5* violence))
//	{
//		
//		shake = TRUE;
//        //  NSLog(@"You are shaking in the x axis");  
//        
//		
//	}
    
	if (acceleration.y > violence * 0.25 || acceleration.y < (-1.5 * violence))
	{
		shake = TRUE;
        //  NSLog(@"You are shaking in the y axis");
        
	}
	
	if (acceleration.x > violence * 0.3 || acceleration.x < (-1.5* violence) || acceleration.z > violence * 0.5 || acceleration.z < (-1.5 * violence))
	{
		shake = TRUE;
        //	NSLog(@"You are shaking in the z axis");
        
        
        if (catchableCount != 0) {
            if (playTouchSound && pauseGame) {
                
                [[SimpleAudioEngine sharedEngine] playEffect:@"catch.wav"];
            }
        }
        
        
        for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
            
            
            if (catchable.EnableCatch && catchable.wasTouched) {
                
                CCParticleSystemQuad *particle = [CCParticleSystemQuad particleWithFile:@"Explosion.plist"];
                particle.position = ccp(240,160);
                [self addChild:particle z:20];
                particle.life = 1.5;
                particle.autoRemoveOnFinish = YES;
                
                
                //////////////////////////Set the catchable randomly to another position of the range///////////////////////
                
                
                float randomY = -CCRANDOM_0_1()*100;
                
                
                while ( randomY > -10 && randomY < -150 ) {
                    randomY = -CCRANDOM_0_1()*100;
                }
                
                if (yaw >= catchable.Xorg) {
                    catchable.Xdest = catchable.Xorg - catchable.MaximumYaw;
                    catchable.Ydest = randomY;
                    
                }
                
                if (yaw < catchable.Xorg) {
                    
                    catchable.Xdest = catchable.Xorg + catchable.MaximumYaw;
                    catchable.Ydest = randomY;
                    
                }
                
                
                ///////////////////////////////////////////////////////////////////////////////////////////////////////////
                playTouchSound = YES;
                score++;
                
                [[SimpleAudioEngine sharedEngine] playEffect:@"getCatchable.wav"];
            }
            
        }
        
        
        //////////////////////////////////////////When you clean up the Catchable,You Win!/////////////////////////////////
        if (score >= 20 && pauseGame == YES) {
            if(enableTouch)
            {
                // Show end game
                CGSize winSize = [CCDirector sharedDirector].winSize;
                CCLabelBMFont *winLabel = [CCLabelBMFont labelWithString:@"You win!" fntFile:@"Arial.fnt"];
                winLabel.scale = 2.0;
                winLabel.position = ccp(winSize.width/2, winSize.height/2);
                [self addChild:winLabel z:4];
                [mnuBack setVisible:YES];
                pauseGame = NO;
                
                
                for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
                    catchable.wasTouched = NO;
                }
            }   
        }

        
	}
	
	beenhere = FALSE;
	
}

- (BOOL) AccelerationIsShakingLast:(UIAcceleration *)last current:(UIAcceleration *)current threshold:(double)threshold {
    double
    deltaX = fabs(last.x - current.x),
    deltaY = fabs(last.y - current.y),
    deltaZ = fabs(last.z - current.z);
	
    return
    (deltaX > threshold && deltaY > threshold) ||
    (deltaX > threshold && deltaZ > threshold) ||
    (deltaY > threshold && deltaZ > threshold);
}



- (void) dealloc
{



	[super dealloc];
}

@end

