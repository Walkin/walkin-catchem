//
//  JSONDesginerTextFieldCell.m
//  JsonEditor
//
//  Created by Paul Wood on 8/10/11.
//  Copyright 2011 Walkin. All rights reserved.
//

#import "JSONDesginerTextFieldCell.h"
#import "PageViewController.h"


@implementation JSONDesginerTextFieldCell




//
// configureForData:tableView:indexPath:
//
// Invoked when the cell is given data. All fields should be updated to reflect
// the data.
//
// Parameters:
//    dataObject - the dataObject (can be nil for data-less objects)
//    aTableView - the tableView (passed in since the cell may not be in the
//		hierarchy)
//    anIndexPath - the indexPath of the cell
//
- (void)configureForData:(id)dataObject
               tableView:(UITableView *)aTableView
               indexPath:(NSIndexPath *)anIndexPath
{
	[super configureForData:dataObject tableView:aTableView indexPath:anIndexPath];
	
	label.text = [(NSDictionary *)dataObject objectForKey:@"key"];
	textField.text = [(NSDictionary *)dataObject objectForKey:@"value"];
	textField.delegate = (PageViewController *)aTableView.delegate;
}

@end
