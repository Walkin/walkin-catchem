//
//  AboutScene.m
//  FunnyShake
//
//  Created by Oliver on 3/14/11.
//  Copyright 2011 iTeam . All rights reserved.
//

#import "TestScene1.h"
#import "SimpleAudioEngine.h"
#import "Catchable.h"
#import "CombineMovement.h"
#import "MainMenuScene.h"
#import "AppDelegate.h"
#import "PauseLayer.h"
#import "CCSlider.h"
#import "CCUIViewWrapper.h"
#import "Tag.h"
#import "AppDelegate.h"
#import "DesignValues.h"


@implementation TestScene1

-(id) init
{
	self = [super init];
	if (self != nil)
	{
		[self addChild:[TestLayer1 node] z:0 tag:kTestLayer1Tag];
        
	}
	return self;
	
}


-(void) dealloc
{
	[super dealloc];
}

@end

@implementation TestLayer1
@synthesize updateYaw;


-(id) init
{
	
	if( (self=[super init] )) {
        

        self.isAccelerometerEnabled = YES;
        
/////////////////////////////Create the pause layer//////////////////////////////
        p = [[[PauseLayer alloc]init]autorelease];
        [self addChild:p z:10];
        p.visible = NO;
        [p.mnuBackToMenu setIsEnabled:NO];
        
        
        MaximumYaw = 45;
        
        [self addMenuItems];
        [self dataInitialize];
		
		[[CCDirector sharedDirector] setDisplayFPS:NO];

        [self presentCoreMotionData];
        [self presentWinCondition];
        [self addScopeCrosshairs];
        
        
        // Allow touches with the layer
        [self registerWithTouchDispatcher];

        
        [self addAudio];
        
        [self addRadar];
        
        ///////////////////////////Show Ready,Set,Go before start playing game/////////////////////////
        
        [self scheduleUpdate];
        
        [self startGame];
        
        [self addScoreLabel];

        
	}
	return self;
}


-(void)removeSpriteAndAddCatchemSpritesBegin:(CCNode *)n
{
    
    catchableCount = 0;
    
    
    for(int i = 0; i < [[DesignValues sharedDesignValues] getFloaterCombined]; i++) {
        Catchable *catchable = [self addCombinedCatchable:i];
        [[DesignValues sharedDesignValues].catchableSprites  addObject:catchable];
        catchableCount += 1;
        catchable.MaximumYaw = 45;
        [catchable addRedSpot];
        [self addChild:catchable.redSpot z:4];

        
    }

      enableTouch = YES;
    
}
 
-(Catchable *)addCombinedCatchable:(int)shipTag{
    
    Catchable *catchable;
    
    int picChoose = (int)(CCRANDOM_0_1()*10);
    
    
    float x;
    float y;
    float randomX;
    float randomY;
    x = 0;
    y = 0;
    
    catchable = [CombineMovement spriteWithFile:[NSString stringWithFormat:@"catchable_00%d.png",picChoose]];
    CombinedCatchemCount += catchable.CombineMoveCount;
    
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
    
    return catchable;
}
    

-(void) GoToPauseLayer
{
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
    
	if (acceleration.x > violence * 0.6 || acceleration.x < (-1.5* violence))
	{
		
		shake = TRUE;
        NSLog(@"You are shaking in the x axis");  
		
	}
    
	if (acceleration.y > violence * 0.6 || acceleration.y < (-1.5 * violence))
	{
		shake = TRUE;
        NSLog(@"You are shaking in the y axis");
	}
	
	if (acceleration.z > violence * 0.5 || acceleration.z < (-1.5 * violence))
	{
		shake = TRUE;
		NSLog(@"You are shaking in the z axis");

        
        if (catchableCount != 0) {
            if (playTouchSound && pauseGame) {
                
                [[SimpleAudioEngine sharedEngine] playEffect:@"catch.wav"];
            }
        }
        
        
        
        for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
            
            // Check to see if yaw position is in range
      //      BOOL wasTouched = [self circle:location withRadius:50 collisionWithCircle:catchable.position collisionCircleRadius:50];

            if (catchable.EnableCatch && catchable.wasTouched) {
                
                CCParticleSystemQuad *particle = [CCParticleSystemQuad particleWithFile:@"Explosion.plist"];
                particle.position = ccp(240,160);
                [self addChild:particle z:20];
                particle.autoRemoveOnFinish = YES;
                
                //            catchable.wasTouched = NO;
                //            catchable.visible = false;
                //            catchable.redSpot.visible = false;
                //            catchableCount -= 1;
                
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
