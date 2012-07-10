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

@synthesize tableView = _tableView;

- (void)dealloc
{
    [super dealloc];
    
    [_tableView release];    
    [_audioPlayer release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    itemArray = [[NSArray arrayWithObjects:
                 [NSDictionary dictionaryWithObjectsAndKeys:@"需要你的爱", @"song", @"飞儿乐团", @"artise", @"http://y1.eoews.com/assets/ringtones/2012/6/29/36232/eialz31cbktv21nyfhyoxeygzmhr6hw1w8rshpkj.mp3", @"url", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"对不起谢谢", @"song", @"陈奕迅", @"artise", @"http://y1.eoews.com/assets/ringtones/2012/6/29/36212/ohdu07cbss0miqwdelq2zurp654t2y7xmvuysej8.mp3", @"url", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"桔子香水", @"song", @"任贤齐", @"artise", @"http://y1.eoews.com/assets/ringtones/2012/6/29/36195/mx8an3zgp2k4s5aywkr7wkqtqj0dh1vxcvii287a.mp3", @"url", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"Could this be love", @"song", @"艾薇儿", @"artise", @"http://y1.eoews.com/assets/ringtones/2012/6/29/36183/mlrqllqafo1xoemkkwili0al2pt8nwotyhed3mmv.mp3", @"url", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"天涯海角", @"song", @"王力宏", @"artise", @"http://y1.eoews.com/assets/ringtones/2012/6/28/36080/71b7tpk44lbmxuu7gagzlnpzt7i3okitvg5el3it.mp3", @"url", nil],
                 nil] retain];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.tableView = nil;
}

- (void)playAudio:(AudioButton *)button
{    
    NSInteger index = button.tag;
    NSDictionary *item = [itemArray objectAtIndex:index];
    
    if (_audioPlayer == nil) {
        _audioPlayer = [[AudioPlayer alloc] init];
    }
        
    if ([_audioPlayer.button isEqual:button]) {
        [_audioPlayer play];
    } else {
        [_audioPlayer stop];
        
        _audioPlayer.button = button; 
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
        [cell configurePlayerButton];
    }
    
    // Configure the cell..
    NSDictionary *item = [itemArray objectAtIndex:indexPath.row];

    cell.titleLabel.text = [item objectForKey:@"song"];
    cell.artistLabel.text = [item objectForKey:@"artise"];
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
