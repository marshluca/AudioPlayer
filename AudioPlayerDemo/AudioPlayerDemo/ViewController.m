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
    
    self.title = @"音乐列表";
    
    itemArray = [[NSArray arrayWithObjects:
                  [NSDictionary dictionaryWithObjectsAndKeys:@"温柔", @"song", @"五月天", @"artise", @"http://y1.eoews.com/assets/ringtones/2012/5/18/34049/oiuxsvnbtxks7a0tg6xpdo66exdhi8h0bplp7twp.mp3", @"url", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"今天", @"song", @"刘德华", @"artise", @"http://y1.eoews.com/assets/ringtones/2012/5/18/34045/hi4dwfmrxm2citwjcc5841z3tiqaeeoczhbtfoex.mp3", @"url", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"K歌之王", @"song", @"陈奕迅", @"artise", @"http://y1.eoews.com/assets/ringtones/2012/5/17/34031/axiddhql6nhaegcofs4hgsjrllrcbrf175oyjuv0.mp3", @"url", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"知足", @"song", @"五月天", @"artise", @"http://y1.eoews.com/assets/ringtones/2012/5/17/34016/eeemlurxuizy6nltxf2u1yris3kpvdokwhddmeb0.mp3", @"url", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"桔子香水", @"song", @"任贤齐", @"artise", @"http://y1.eoews.com/assets/ringtones/2012/6/29/36195/mx8an3zgp2k4s5aywkr7wkqtqj0dh1vxcvii287a.mp3", @"url", nil],
                  
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
