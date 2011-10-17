//
//  DesignerValuesTableView.m
//  FunnyShake
//
//  Created by Zelin Ou on 8/1/11.
//  Copyright 2011 Walkin. All rights reserved.
//

#import "DesignerValuesTableView.h"
#import "JSONDesginerTextFieldCell.h"
#import "GradientBackgroundTable.h"
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"

@implementation DesignerValuesTableView


+ (NSString *)designerPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *diskCachePath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"] retain];
    NSString *designerValuesPath = [diskCachePath stringByAppendingPathComponent:@"designerValues.json"];
   
    //If the values have not been placed in the Cache Yet we should copy and paste it into the cache
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"designerValues" ofType:@"json"]; 
        NSData *data = [NSData dataWithContentsOfFile:path];
        [[NSFileManager defaultManager] createFileAtPath:designerValuesPath contents:data attributes:nil];
    }
    return designerValuesPath;
    
    [diskCachePath release];
}

- (NSString *)jsonPath{
    return [diskCachePath stringByAppendingPathComponent:@"designerValues.json"];
//    return [[NSBundle mainBundle] pathForResource:@"designerValues" ofType:@"json"]; 
}




//
// title
//
// returns the navigation bar text for the front screen
//
- (NSString *)title
{
	return NSLocalizedString(@"TableViewRevisited", @"");
}

- (void)createRows
{
    
    NSString *path = [self jsonPath]; 
    
    NSDictionary *parsedDataObject = (NSDictionary *)[self parsedJSONFromPath:path];
    NSArray *valueArray = [parsedDataObject objectForKey:@"designerValues"];
    
    
    [self addSectionAtIndex:0 withAnimation:UITableViewRowAnimationFade];
    
    for(NSDictionary *dict in valueArray){
        [self
         appendRowToSection:0
         cellClass:[JSONDesginerTextFieldCell class]
         cellData:[[[NSMutableDictionary alloc] initWithDictionary:dict]autorelease]
         withAnimation:UITableViewRowAnimationRight];
        
            }
    
	[self hideLoadingIndicator];
}

//
// refresh
//
// Removes all existing rows and starts a reload (on a 0.5 second timer)
//
- (void)refresh:(id)sender
{
    [self saveData];
	[self removeAllSectionsWithAnimation:UITableViewRowAnimationFade];
	[self performSelector:@selector(createRows) withObject:nil afterDelay:0.5];
	[self showLoadingIndicator];
}

//
// viewDidLoad
//
// On load, refreshes the view (to load the rows)
//
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refresh:nil];
}

//
// loadView
//
// Since the view is so simple (just a GradientBackgroundView) we might as
// well contruct it in code.
//
- (void)loadView
{
	GradientBackgroundTable *aTableView =
    [[[GradientBackgroundTable alloc]
      initWithFrame:CGRectZero
      style:UITableViewStyleGrouped]
     autorelease];
	
	self.view = aTableView;
	self.tableView = aTableView;
}


@end
