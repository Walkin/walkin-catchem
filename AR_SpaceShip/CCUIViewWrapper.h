//
//  CCUIViewWrapper.h
//  AR
//
//  Created by Zelin Ou on 7/29/11.
//  Copyright 2011 iTeam. All rights reserved.
//

#import "cocos2d.h"

@interface CCUIViewWrapper : CCSprite
{
	UIView *uiItem;
	float rotation;
}

@property (nonatomic, retain) UIView *uiItem;

+ (id) wrapperForUIView:(UIView*)ui;
- (id) initForUIView:(UIView*)ui;

- (void) updateUIViewTransform;

@end