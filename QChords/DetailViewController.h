//
//  DetailViewController.h
//  QChords
//
//  Created by hudsioo on 12/8/2556 BE.
//  Copyright (c) 2556 QOOFHOUSE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
