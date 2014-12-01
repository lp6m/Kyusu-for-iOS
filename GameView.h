//
//  GameView.h
//

#import <SpriteKit/SpriteKit.h>

#import "iAd/iAd.h"
@interface GameView : SKView

-(void) setUpGameView;

-(void) switchingTitleScene;
-(void) switchingGameScene;
-(void) switchingResultScene;
-(void) switchingHowToPlayScene;
-(void) switchingCreditScene;

@end
