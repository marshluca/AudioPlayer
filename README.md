### AudioPlayer

An online iOS audio player based on AVAudioStreamer with a custom UI.

#### How to use
1. link CFNetwork.framework, AudioToolbox.framework, QuartCore.framework
2. import AudioPlayer floder
3. create an instance of AudioPlayer with AudioButton and url, like below:

```  
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
```

![screenshots](https://github.com/marshluca/AudioPlayer/raw/master/AudioPlayer/images/screenshots.png)