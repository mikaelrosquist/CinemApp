//
//  RateViewController.m
//  CinemApp
//
//  Created by mikael on 11/02/14.
//
//

#import "RateViewController.h"

@interface RateViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISlider *sliderValue;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@end

@implementation RateViewController
@synthesize sliderValue;

- (IBAction)rateSlider:(id)sender {
    UISlider *slider = (UISlider *)sender;
    NSInteger val = lround(slider.value);
    self.rateLabel.text = [NSString stringWithFormat:@"%d",val];
}
- (IBAction)segmentAction:(UISegmentedControl *)sender {
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.sliderValue.minimumValue = 0;
    self.sliderValue.maximumValue = 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
