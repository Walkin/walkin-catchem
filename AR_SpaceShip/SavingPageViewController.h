//
//  SavingPageViewController.h
//  JsonEditor
//
//  Created by Paul Wood on 8/10/11.
//  Copyright 2011 Walkin. All rights reserved.
//

#import "PageViewController.h"

@interface SavingPageViewController : PageViewController{
    NSString *diskCachePath;
}

- (NSString *)jsonPath;
- (void)saveData;


@end
