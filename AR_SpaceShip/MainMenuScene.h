//  Created by Oliver on 3/14/11.
//  Copyright 2011 iTeam . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <UIKit/UIKit.h>

@class DesignerValuesTableView;

@interface MainMenuScene : CCScene
{
  
}

@end

@interface MainMenuLayer: CCLayer
{
	
	UITableView *tableView;
    UIViewController *tableDelegate;
    DesignerValuesTableView *tableView1;
    UINavigationController *nav;
    UIBarButtonItem *backButton;

}

-(void) TestClick1: (id) sender;
-(void) TestClick2: (id) sender;
-(void) TestClick3: (id) sender;
@end

