//
//  MasterViewController.m
//  QChords
//
//  Created by hudsioo on 12/8/2556 BE.
//  Copyright (c) 2556 QOOFHOUSE. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "AppDelegate.h"
#import "ChordCell.h"
@interface MasterViewController () {
    NSMutableArray *_objects;
}
@property (strong, nonatomic) NSMutableArray * allArray;
@property (nonatomic, strong) NSMutableArray* itemInTable;
@property (nonatomic, strong) UISearchBar * searchBar;
@end

@implementation MasterViewController

-(AppDelegate*)appDelegate{
	return (AppDelegate*)[[UIApplication sharedApplication]delegate];
}

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
       // self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.allArray = [[NSMutableArray alloc]initWithArray:[self appDelegate].allArray];
    self.itemInTable = [[NSMutableArray alloc]initWithArray:self.allArray];
   
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(60, 0, 260, 44)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"ชื่อเพลง ศิลปิน อัลบัม";
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    UIBarButtonItem * scopeBtn = [[UIBarButtonItem alloc]initWithTitle:@"Sort"
                                                        style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(scopeActionShow)];
    self.navigationItem.leftBarButtonItem = scopeBtn;
    
    isScope = NO;
    self.sortSegment.hidden = YES;
    
    [self.tableView reloadData];
}

- (void)scopeActionShow{
    if (!isScope) {
        [self moveView:self.tableView duration:0.3 curve:UIViewAnimationCurveLinear x:0 y:+45];
        [self moveView:self.scopeBGView duration:0.3 curve:UIViewAnimationCurveLinear x:0 y:+45];
        isScope = YES;
        self.sortSegment.hidden = NO;
    }else{
        [self moveView:self.tableView duration:0.3 curve:UIViewAnimationCurveLinear x:0 y:0];
        [self moveView:self.scopeBGView duration:0.3 curve:UIViewAnimationCurveLinear x:0 y:-45];
        isScope = NO;
        self.sortSegment.hidden = YES;
    }
}

- (IBAction)sortSMToggle:(id)sender {
    UISegmentedControl * segObj = (UISegmentedControl*)sender;
    NSString * keyWord;
    if (segObj.selectedSegmentIndex == 0) keyWord = @"artis";
    else if (segObj.selectedSegmentIndex == 1) keyWord = @"allbum";
    else if (segObj.selectedSegmentIndex == 2) keyWord = @"song";
    else if (segObj.selectedSegmentIndex == 3) keyWord = @"none";
        
    if ([keyWord isEqualToString:@"none"]) {
        self.itemInTable = [self.allArray mutableCopy];
        [self.tableView reloadData];
    }else{
        NSSortDescriptor * aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:keyWord ascending:YES];
        [self.itemInTable sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
        [self.tableView reloadData];
    }
   
}

#pragma mark - SearchBar Delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [self.searchBar resignFirstResponder];
    self.itemInTable = [[NSMutableArray alloc]initWithArray:self.allArray];
    [self.tableView reloadData];
}



- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    if([searchText length] > 0) {
        NSPredicate * pred = [NSPredicate predicateWithFormat:@"artis contains[cd] %@ || song contains[cd] %@ || allbum contains[cd] %@", searchText, searchText,searchText];
        NSMutableArray *filtered = [[NSMutableArray alloc] initWithArray:[self.allArray filteredArrayUsingPredicate:pred]];
        self.itemInTable = filtered;
    }
    else {
        self.itemInTable = self.allArray;
    }
    [self.tableView reloadData];
    
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemInTable.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChordCell *cell = (ChordCell*)[tableView dequeueReusableCellWithIdentifier:@"ChordCell" forIndexPath:indexPath];

    cell.songLB.text = self.itemInTable[indexPath.row][@"song"];
    if ([self.itemInTable[indexPath.row][@"allbum"] isEqualToString:@""]) {
        cell.artisLB.text = [NSString stringWithFormat:@"%@",self.itemInTable[indexPath.row][@"artis"]];
    }else{
        cell.artisLB.text = [NSString stringWithFormat:@"%@ (%@)",self.itemInTable[indexPath.row][@"artis"],self.itemInTable[indexPath.row][@"allbum"]];
    }
    

    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSMutableDictionary * object = self.itemInTable[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}


- (void)moveView:(UIView *)view duration:(NSTimeInterval)duration
           curve:(int)curve x:(CGFloat)x y:(CGFloat)y
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
    view.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
