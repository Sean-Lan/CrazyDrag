//
//  ViewController.m
//  CrazyDrag
//
//  Created by Xiang on 15/4/3.
//  Copyright (c) 2015年 X-Company. All rights reserved.
//

#import "ViewController.h"
#import "AboutViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () {
    int currentValue;
    int targetValue;
    int score;
    int round;
}
- (IBAction)startOver:(id)sender;
- (IBAction)showAlert:(id)sender;
- (IBAction)showInfo:(id)sender;
- (IBAction)sliderMoved:(UISlider *)sender;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *targetLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *roundLabel;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation ViewController

@synthesize slider;
@synthesize targetLabel;
@synthesize scoreLabel;
@synthesize roundLabel;
@synthesize audioPlayer;
-(void)playBackgroundMusic{
    NSString *musicPath = [[NSBundle mainBundle]pathForResource:@"no" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:musicPath];
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = -1;
    if (audioPlayer == nil) {
        NSString *errorInfo = [NSString stringWithString:[error description]];
        NSLog(@"the error is%@", errorInfo);
    } else {
        [audioPlayer play];
    }
}

-(void)updateLabels {
    self.targetLabel.text = [NSString stringWithFormat:@"%d", targetValue];
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    self.roundLabel.text = [NSString stringWithFormat:@"%d", round];
}

- (void)startNewRound {
    targetValue = 1 + arc4random()%100;
    currentValue = 50;
    self.slider.value = currentValue;
    ++round;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *thumbImageNormal = [UIImage imageNamed:@"SliderThumb-Normal"];
    [self.slider setThumbImage:thumbImageNormal forState:UIControlStateNormal];
    
    UIImage *thumbImageHighlighted = [UIImage imageNamed:@"SliderThumb-Highlighted"];
    [self.slider setThumbImage:thumbImageHighlighted forState:UIControlStateHighlighted];
    
    UIImage *trackLeftImage = [[UIImage imageNamed:@"SliderTrackLeft"]
                               stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    [self.slider setMinimumTrackImage:trackLeftImage forState:UIControlStateNormal];
    
    UIImage *trackRightImage = [[UIImage imageNamed:@"SliderTrackRight"]
                                stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    [self.slider setMaximumTrackImage:trackRightImage forState:UIControlStateNormal];
    [self startNewGame];
    [self updateLabels];
    [self playBackgroundMusic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startOver:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self startNewGame];
    [self updateLabels];
    
    [self.view.layer addAnimation:transition forKey:nil];
}

- (void)startNewGame {
    score = 0;
    round = 0;
    [self startNewRound];
}

- (IBAction)showAlert:(id)sender {
    int difference = abs(currentValue - targetValue);
    int points = 100 - difference;
    NSString *title;
    if (difference == 0) {
        title = @"土豪，你太牛逼了！";
        points += 100;
    } else if (difference < 5) {
        title = @"土豪太棒了，差一点！";
        if (difference == 1)
            points += 50;
    } else if (difference < 10) {
        title = @"好吧，勉强算个土豪！";
    } else {
        title = @"不是土豪少来装！";
    }
    score += points;
    NSString *message = [NSString stringWithFormat:@"恭喜高富帅，您的得分是：%d", points];
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"朕知晓了，爱卿辛苦了" otherButtonTitles:nil, nil]show];
}

- (IBAction)showInfo:(id)sender {
    AboutViewController *controller = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)sliderMoved:(UISlider *)sender {
    //NSLog(@"滑动条当前的数值是：%f", slider.value);
    currentValue = (int)lround(sender.value);
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self startNewRound];
    [self updateLabels];
}
@end
