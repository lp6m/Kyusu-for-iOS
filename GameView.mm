//
//  GameView.m
//

#import "GameView.h"
#import "SceneManager.h"
#import "SceneEscapeProtocol.h"
#import "MyInclude.h"
#import "MyInclude2.h"

int GameStatus;

    
@implementation GameView{
	
	int			_hiScore;
	int			_score;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpGameView];
    }
    return self;
}

-(void)awakeFromNib
{
	[self setUpGameView];
}

-(void) setUpGameView
{
    //self.showsFPS = YES;
    self.showsNodeCount = YES;
	
	//タイトル画面
    GameStatus = GAME_TITLE;
	[self switchingTitleScene];
    
}



//シーンの切り替え
//タイトル
-(void) switchingTitleScene
{
    TitleScene * scene = [SceneManager titleScene:self.bounds.size];
	scene.delegate = self;
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
	[SceneManager sceneChange:self New:scene Duration:0.5];
}
//ゲーム
-(void) switchingGameScene
{
    GameScene * scene = [SceneManager gameScene:self.bounds.size];
	scene.delegate = self;
    scene.scaleMode = SKSceneScaleModeAspectFill;
	[SceneManager sceneChange:self New:scene Duration:0.5];
}
//結果
-(void) switchingResultScene
{
    ResultScene * scene = [SceneManager resultScene:self.bounds.size];
	scene.delegate = self;
    scene.scaleMode = SKSceneScaleModeAspectFill;
	[SceneManager sceneChange:self New:scene Duration:0.5];
	
	//スコアとハイスコアを設定
	[scene setScore:_score HiScore:_hiScore];
}

-(void) switchingHowToPlayScene
{
    HowToPlayScene * scene = [SceneManager howtoplayScene:self.bounds.size];
	scene.delegate = self;
    scene.scaleMode = SKSceneScaleModeAspectFill;
	[SceneManager sceneChange:self New:scene Duration:0.5];
}

-(void) switchingCreditScene
{
    CreditScene * scene = [SceneManager creditScene:self.bounds.size];
	scene.delegate = self;
    scene.scaleMode = SKSceneScaleModeAspectFill;
	[SceneManager sceneChange:self New:scene Duration:0.5];
}

#pragma mark - SceneEscapeProtocol

//デリゲートメソッド
-(void)sceneEscape:(SKScene *)scene
{
    switch(GameStatus){
        case GAME_TITLE:
            if(isadOK==true) adView.hidden = YES;
            [self switchingTitleScene];
            break;
        case GAME_MAIN:
            [self switchingGameScene];
            break;
        case GAME_STAFFCREDIT:
            [self switchingCreditScene];
            break;
        case GAME_HOWTOPLAY:
            [self switchingHowToPlayScene];
            break;
        case GAME_OVER:
            [self switchingResultScene];
    }
	/*if([scene isKindOfClass:[TitleScene class]]){
		[self switchingGameScene];		//ゲーム
	}
	else if([scene isKindOfClass:[GameScene class]]){
		//ハイスコアをNSUserDefaultsから読み込む
		NSUserDefaults* userdef = [NSUserDefaults standardUserDefaults];
		_hiScore = (int)[userdef integerForKey:@"hi_score"];
		//スコアを比較
		GameScene* game = (GameScene*)scene;
		_score = game.score;
		if(_hiScore < _score){
			//ハイスコア更新
			_hiScore = _score;
			[userdef setInteger:_hiScore forKey:@"hi_score"];
		}
		[self switchingResultScene];	//結果
		
	}
	else if([scene isKindOfClass:[ResultScene class]]){
		[self switchingTitleScene];		//タイトル
	}
    else if([scene isKindOfClass:[CreditScene class]]){
		[self switchingTitleScene];//タイトルに戻る
	}*/
}

@end
