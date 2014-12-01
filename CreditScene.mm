//
//  CreditScene.mm
//  Kyusu for iOS
//
//  Created by lp6m on 2014/11/28.
//
//

#import "CreditScene.h"
#import "SceneEscapeProtocol.h"
#import "MyInclude.h"
#import "MyInclude2.h"
@implementation CreditScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
		//背景
		SKSpriteNode* space = [SKSpriteNode spriteNodeWithImageNamed:@"credit.png"];
        space.size = self.size;
		space.position = CGPointMake(self.size.width/2, self.size.height/2);
		space.name = @"credit";
		[self addChild:space];
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//タッチ通知
	if([_delegate respondsToSelector:@selector(sceneEscape:)]){
        GameStatus = GAME_TITLE;
		[_delegate sceneEscape:self];
	}
}

@end