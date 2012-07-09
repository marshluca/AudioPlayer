//
//  ViewController.m
//  AudioPlayerDemo
//
//  Created by Lin Zhang on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AudioCell.h"
#import "AudioPlayer.h"

static NSArray *itemArray;

@interface ViewController ()

@end

@implementation ViewController

@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    itemArray = [NSArray arrayWithObjects:
                 [NSDictionary dictionaryWithObjectsAndKeys:@"", @"song", @"", @"artise", @"", @"url", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"", @"song", @"", @"artise", @"", @"url", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"", @"song", @"", @"artise", @"", @"url", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"", @"song", @"", @"artise", @"", @"url", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"", @"song", @"", @"artise", @"", @"url", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"", @"song", @"", @"artise", @"", @"url", nil],
                 nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.tableView = nil;
}

- (void)playAudio:(AudioButton *)button
{
    if (_audioPlayer) {
        _audioPlayer = [[AudioPlayer alloc] init];
    }
    
    if ([_audioPlayer.button isEqual:button]) {
        [_audioPlayer play];
    } else {
        [_audioPlayer stop];
        
        _audioPlayer.button = [button retain];   
        
        NSDictionary *item = [itemArray objectAtIndex:button.tag];
        _audioPlayer.url = [NSURL URLWithString:[item objectForKey:@"url"]];
        [_audioPlayer play];
    }   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark
#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [itemArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AudioCell";
    
    AudioCell *cell = (AudioCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (AudioCell *)[nibArray objectAtIndex:0];
    }
    
    // Configure the cell...
    cell.titleLabel.text = [NSString stringWithFormat:@"I love you %d", indexPath.row];
    cell.artistLabel.text = @"Lucas";
    cell.audioButton.tag = indexPath.row;
    [cell.audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // to be rewrite in subclass    
}

@end
