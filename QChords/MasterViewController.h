//
//  MasterViewController.h
//  QChords
//
//  Created by hudsioo on 12/8/2556 BE.
//  Copyright (c) 2556 QOOFHOUSE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    BOOL isScope;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (weak, nonatomic) IBOutlet UIView *scopeBGView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)sortSMToggle:(id)sender;
@end
