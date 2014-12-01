//
//  SceneManager.h
//

#import <Foundation/Foundation.h>
#import "TitleScene.h"
#import "GameScene.h"
#import "ResultScene.h"
#import "HowToPlayScene.h"
#import "CreditScene.h"
@interface SceneManager : NSObject

+(TitleScene*)titleScene:(CGSize)size;
+(GameScene*)gameScene:(CGSize)size;
+(ResultScene*)resultScene:(CGSize)size;
+(HowToPlayScene*)howtoplayScene:(CGSize)size;
+(CreditScene*)creditScene:(CGSize)size;


+(void)sceneChange:(SKView*)view
			   New:(SKScene*)newScene
		  Duration:(NSTimeInterval)sec;
@end
