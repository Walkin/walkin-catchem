//
//  ExplosionParticle.m
//  AerialGun
//
//  Created by Pablo Ruiz on 6/28/10.
//  Copyright 2010 Infinix Software. All rights reserved.
//

#import "ExplosionParticle.h"


@implementation ExplosionParticle

-(id) init
{
	return [self initWithTotalParticles:5];
}

-(id) initWithTotalParticles:(int) p
{
	if( (self=[super initWithTotalParticles:p]) ) {
		
	
		self.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars-grayscale.png"];
		
		// duration
		self.duration = -1;
		
		// Set "Radius" mode (default one)
		self.emitterMode = kCCParticleModeRadius;
		
		self.startRadius =60;
		self.startRadiusVar =53;
		self.endRadius =0;
		self.rotatePerSecond=0;
		self.rotatePerSecondVar =360;
		
		
		// self position
		self.position = ccp(160,240);
		
		// angle
		self.angle = 360;
		self.angleVar = 205;
		
		// life of particles
		self.life = 30.0;
		self.lifeVar = 0.15;
		
		// spin of particles
		self.startSpin = 0;
		self.startSpinVar = 0;
		self.endSpin = 0;
		self.endSpinVar = 2000;
		
		// color of particles
		ccColor4F startColor = {1.0f, 0.15f, 0.65f, 1.0f};
		self.startColor = startColor;
		
		ccColor4F startColorVar = {1,1,1,0};
		self.startColorVar = startColorVar;
		
		ccColor4F endColor = {0.1f, 0.1f, 0, 0};
		self.endColor = endColor;
		
		ccColor4F endColorVar = {0.1f, 0.1f, 0, 0};	
		self.endColorVar = endColorVar;
		
		// size, in pixels
		self.startSize = 12.0f;
		self.startSizeVar = 05.0f;
		self.endSize = 0;
		self.endSizeVar = 39;
		
		// emits per second
		self.emissionRate = self.totalParticles/self.life;
		
		// additive
		self.blendAdditive = NO;
		
		self.autoRemoveOnFinish =YES;
	}
	
	return self;
}
@end
