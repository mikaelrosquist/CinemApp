//
//  ProfileViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-12.
//
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ProfileViewController

-(void)setScrollView:(UIScrollView *)scrollView{
    _scrollView = scrollView;
    [self.scrollView setContentSize:CGSizeMake(1000,1000)];
}

- (UIImageView *) imageView{
    if(!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(1000,1000)];
    [self.scrollView flashScrollIndicators];
    [self.scrollView addSubview:self.imageView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
