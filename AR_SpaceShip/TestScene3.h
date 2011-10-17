//
//  TestScene3.h
//  AR_SpaceShip
//
//  Created by Zelin Ou on 8/11/11.
//  Copyright 2011 Walkin. All rights reserved.
//


#import "TestScene.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedJoystickExample.h"
#import "SneakyJoystickSkinnedDPadExample.h"
#import "ColoredCircleSprite.h"



@class PauseLayer3;

@interface TestScene3 : TestScene {
    
}

@end

@interface TestLayer3: TestLayer <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    PauseLayer3 *p;
    SneakyJoystick *joystick;
    SneakyJoystickSkinnedBase *leftJoy;
    
}


-(void)addJoyStick;


@end