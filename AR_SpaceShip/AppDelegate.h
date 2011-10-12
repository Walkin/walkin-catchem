//
//  AppDelegate.h
//  AR
//
//  Created by Zelin Ou on 7/14/11.
//  Copyright iTeam 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    UIView * overlay;
    BOOL paused;
    UIImagePickerController *uip;
}

+(AppDelegate *) get;


@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIImagePickerController *uip;
@property (nonatomic, retain) UIView * overlay;
@property (readwrite) BOOL paused;

@end
