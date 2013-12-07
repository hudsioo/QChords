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
        self.clearsSelectionOnViewWillAppear = NO;
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
   
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"ชื่อเพลง ศิลปิน อัลบัม";
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [self.searchBar resignFirstResponder];
    self.itemInTable = [[NSMutableArray alloc]initWithArray:self.allArray];
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    if([searchText length] > 0) {
        NSPredicate *pred;
        
        pred = [NSPredicate predicateWithFormat:@"artis contains[cd] %@ || song contains[cd] %@ || allbum contains[cd] %@", searchText, searchText,searchText];
        
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
    cell.artisLB.text = [NSString stringWithFormat:@"%@",self.itemInTable[indexPath.row][@"artis"]];

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

@end
