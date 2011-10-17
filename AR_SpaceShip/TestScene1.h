//
//  AboutScene.h
//  FunnyShake
//
//  Created by Oliver on 3/14/11.
//  Copyright 2011 Walkin . All rights reserved.
//

#import "TestScene.h"
#import "ExplosionParticle.h"
@class PauseLayer;


@interface TestScene1 : TestScene {

}

@end



@interface TestLayer1 : TestLayer
{
    PauseLayer * p;
    CMDeviceMotion *currentDeviceMotion;
    CMAttitude *currentAttitude;
}




@end