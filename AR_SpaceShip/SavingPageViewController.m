//
//  SavingPageViewController.m
//  JsonEditor
//
//  Created by Paul Wood on 8/10/11.
//  Copyright 2011 Walkin. All rights reserved.
//

#import "SavingPageViewController.h"
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"

@implementation SavingPageViewController

- (id)init{
    
    if ((self = [super init]))
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        diskCachePath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"] retain];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"designerValues" ofType:@"json"]; 
            NSString *responseString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            NSData *data = [NSData dataWithContentsOfFile:path];
            
            [[NSFileManager defaultManager] createFileAtPath:[diskCachePath stringByAppendingPathComponent:@"designerValues.json"] contents:data attributes:nil];

        }
    }
    
    return self;
}


- (NSString *)jsonPath{
    //return [diskCachePath stringByAppendingPathComponent:@"designerValues.json"];
    return nil;
}


- (id)parsedJSONFromPath:(NSString *)path{
    NSString *responseString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    return [responseString JSONValue];
}


- (void)saveData{
    NSString *path = [self jsonPath];    
    NSArray *updatedData = [self allDataInSection:0];
    
    if (updatedData == nil) {
        return;
    }
    
    NSDictionary *finishedDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  updatedData,@"designerValues",
                                  nil];
    
    NSString *json = [finishedDict JSONRepresentation];
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [fileManager createFileAtPath:path contents:data attributes:nil];
}
//
// saveDataForTextField:
//
// Saves the Data in the JSON Object
//
- (void)saveDataForTextField:(UITextView *)textField
{
    UIView *superView = textField.superview;
    superView = superView.superview;
    NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell *)superView];
    //(TextFieldCell *)superView 
    NSMutableDictionary *dict = (NSMutableDictionary *)[self dataForRow:path.row inSection:path.section];
    [dict setObject:textField.text forKey:@"value"];
}

@end
