//
//  GameScene.h
//

#import <SpriteKit/SpriteKit.h>

//オブジェクト名

#define		kBackName			@"Back"			//背景
#define		kScoreName			@"Score"		//スコア

@interface GameScene : SKScene <SKPhysicsContactDelegate>
@property	(weak, nonatomic)	id				delegate;
@property	(assign, nonatomic)	int				score;			//スコア
@property	(assign, nonatomic)	int				fallenNumber;	//隕石衝突数

-(void)BanDraw;
-(BOOL) IsInRange:(CGPoint)pos;

@end

@interface classname : UIViewController
{
    CGPoint _tBegan, _tEnded;
}
@end