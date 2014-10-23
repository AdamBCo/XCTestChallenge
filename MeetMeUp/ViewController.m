//
//  ViewController.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Event.h"
#import "EventDetailViewController.h"
#import "ViewController.h"

@interface ViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *searchBar;
@property (nonatomic, strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    //Since viewDidLoad is the first thing that happnes when the MeetMeUp app loads, we perform the things below FIRST:
    
    //Load Super
    [super viewDidLoad];
    //Perform the search method by calling it and passing in an NSString.
    [self performSearchWithKeyword:@"mobile"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //We are creating an isntance of the EventDetailViewController and assigning it as the destination for the segue.
    EventDetailViewController *detailVC = [segue destinationViewController];
    //We create an instance of Event and assign it to an Event stored in the DataArray.
    Event *event = self.dataArray[self.tableView.indexPathForSelectedRow.row];
    //We are telling the Event on the Destination Controller that it is equal to the event we pulled out of the DataArray.
    detailVC.event = event;
}

- (void)performSearchWithKeyword:(NSString *)keyword
{
    //Class method on Event perfomrs a search by passing in a keyword.
    //It returns an array of events.
    [Event performSearchWithKeyword:keyword andComplete:^(NSArray *events)
    {
        //The dataArray is equal to all the events returned.
        self.dataArray = events;
        //Reload tableview.
        [self.tableView reloadData];
    }];
}


#pragma mark - Tableview Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //The number of cells loaded on the tableview is equal to the number of items in our dataArray.
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //The prototype cell on the tableview in the Storyboard is labeled "eventCell".
    //We need to create an instance of the cell, so we can reger to it.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    //We also create an instance of Event, so we can refer to to the Event stored at the index of the tablview in DataArray.
    Event *event = self.dataArray[indexPath.row];
    //The text in the textlabel of the cell is assigned to the name property of the "Event" event.
    cell.textLabel.text = event.name;
    //The text in the textlabel of the cell is assigned to the address property of the "Event" event.
    cell.detailTextLabel.text = event.address;

    //We call a method on the event that allows us to get the Image Data for that sepcific event.
    [event retreiveImageWithComplete:^(NSData *data)
    {
        //The image in the cell is set to a protype image "logo", until the request finishes and returns an image.
        [cell.imageView setImage:[UIImage imageNamed:@"logo"]];
        //If data is returned, we change image to the image we recieved.
        if (data)
            [cell.imageView setImage:[UIImage imageWithData:data]];

        [cell layoutSubviews];
    }];

    return cell;
}


#pragma searchbar delegate

//We create a delegate method that allows us to take the text from the search bar, plug it into a method Called "performSearchWithKeword"
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self performSearchWithKeyword:searchBar.text];
    //Once the searchBarButton is clicked, we resign the first responder and the keyboard goes away.
    [searchBar resignFirstResponder];
}

@end
