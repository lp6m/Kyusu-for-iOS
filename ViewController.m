//
//  ViewController.m
//

#import "ViewController.h"
#import "GameView.h"
#import "iAd/iAd.h"
#import "MyInclude2.h"

@implementation ViewController{
	__weak	GameView*	_gameView;
}
bool isadOK = false;
ADBannerView *adView;//広告表示ビュー
//iAd取得成功
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"iAd取得成功");
    isadOK = true;
    adView.hidden = NO;
    if(GameStatus==GAME_TITLE) adView.hidden = YES;
}

//iAd取得失敗
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"iAd取得失敗");
    isadOK = false;
    adView.hidden = YES;
}

-(BOOL)prefersStatusBarHidden
{
	return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Configure the view.    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    
    // Create and configure the scene.
   self.canDisplayBannerAds = YES;

    _gameView = (GameView *)self.view;

    adView
    = [[ADBannerView alloc] initWithFrame:CGRectMake(0.0,_gameView.frame.size.height-50,_gameView.frame.size.width,_gameView.frame.size.height+30)];
    [self.view addSubview:adView];
    adView.hidden = YES;//はじめはHiddenにしておく
    adView.delegate = self;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)postToTwitter:(NSData *)image
{
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:
                                           SLServiceTypeTwitter];
    
    tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
                //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
                break;
                //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
                break;
        }
    };
    
    [tweetSheet setInitialText:@"ゲーム画面のツイートサンプル"];
    
    if (![tweetSheet addImage:[UIImage imageWithData:image]]) {
        NSLog(@"Unable to add the image!");
    }
    
    if (![tweetSheet addURL:[NSURL URLWithString:@"http://twitter.com/"]]){
        NSLog(@"Unable to add the URL!");
    }
    
    [self presentViewController:tweetSheet animated:NO completion:^{
        NSLog(@"Tweet sheet has been presented.");
    }];
}


// LINEに投稿
- (void)postToLine:(UIImage *)image {
    // この例ではUIImageクラスの_resultImageを送る
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    //UIPasteboard *pasteboard = [UIPasteboard pasteboardWithUniqueName]; iOS7以降は🙅
    [pasteboard setData:UIImagePNGRepresentation(image) forPasteboardType:@"public.png"];
    
    // pasteboardを使ってパスを生成
    NSString *LineUrlString = [NSString stringWithFormat:@"line://msg/image/%@",pasteboard.name];
    
    // URLスキームを使ってLINEを起動
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LineUrlString]];
}


// Facebookに投稿
- (void)postToFacebook :(UIImage *)image{
    SLComposeViewController *vc = [SLComposeViewController
                                   composeViewControllerForServiceType:SLServiceTypeFacebook];
    [vc setInitialText:@"via Think Big Act Local"];
    [vc addImage:image];
    [vc addURL:[NSURL URLWithString:@"http://himaratsu.hatenablog.com/"]];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
