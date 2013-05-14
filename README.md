### AudioPlayer

An online iOS audio player based on AVAudioStreamer with a custom UI.

<!-- MacBuildServer Install Button -->
<div class="macbuildserver-block">
    <a class="macbuildserver-button" href="http://macbuildserver.com/project/github/build/?xcode_project=AudioPlayerDemo%2FAudioPlayerDemo.xcodeproj&amp;target=AudioPlayerDemo&amp;repo_url=git%3A%2F%2Fgithub.com%2Fmarshluca%2FAudioPlayer.git&amp;build_conf=Release" target="_blank"><img src="http://com.macbuildserver.github.s3-website-us-east-1.amazonaws.com/button_up.png"/></a><br/><sup><a href="http://macbuildserver.com/github/opensource/" target="_blank">by MacBuildServer</a></sup>
</div>
<!-- MacBuildServer Install Button -->

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
