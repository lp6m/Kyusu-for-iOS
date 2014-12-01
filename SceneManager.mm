//
//  SceneManager.m
//

#import "SceneManager.h"
@implementation SceneManager

//シーンの作成
+(TitleScene*)titleScene:(CGSize)size
{
	TitleScene*	scene = [[TitleScene alloc] initWithSize:size];
	return scene;
}
+(GameScene*)gameScene:(CGSize)size
{
	GameScene*	scene = [[GameScene alloc] initWithSize:size];
	return scene;
}
+(ResultScene*)resultScene:(CGSize)size
{
	ResultScene*	scene = [[ResultScene alloc] initWithSize:size];
	return scene;
}
+(HowToPlayScene*)howtoplayScene:(CGSize)size
{
	HowToPlayScene*	scene = [[HowToPlayScene alloc] initWithSize:size];
	return scene;
}

+(CreditScene*)creditScene:(CGSize)size
{
	CreditScene*	scene = [[CreditScene alloc] initWithSize:size];
	return scene;
}
//シーンの変更
+(void)sceneChange:(SKView*)view
			   New:(SKScene*)newScene
		  Duration:(NSTimeInterval)sec
{
    SKTransition *tr = [SKTransition fadeWithDuration:sec];
	[view presentScene:newScene transition:tr];
	
}

@end
