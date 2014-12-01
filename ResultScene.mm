//
//  ResultScene.m
//

#import "ResultScene.h"
#import "SceneEscapeProtocol.h"
#import "MyInclude.h"
#import "MyInclude2.h"
@implementation ResultScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
		
		//背景
		SKSpriteNode* space = [SKSpriteNode spriteNodeWithImageNamed:@"ResultBack"];
		space.position = CGPointMake(self.size.width/2, self.size.height/2);
		space.name = @"back";
		[self addChild:space];
		
		//点滅アクション
		SKLabelNode *pleaseTouch = [SKLabelNode labelNodeWithFontNamed:@"Baskerville-Bold"];
		pleaseTouch.text = @"Please, touch the screen";
		pleaseTouch.fontSize = 20;
		pleaseTouch.position = CGPointMake(CGRectGetMidX(self.frame),
										   CGRectGetMidY(self.frame)-20);
		[self addChild:pleaseTouch];
		NSArray*	actions = @[[SKAction fadeAlphaTo:0.0 duration:0.75],
								[SKAction fadeAlphaTo:1.0 duration:0.75]];
		SKAction*	action = [SKAction repeatActionForever:[SKAction sequence:actions]];
		[pleaseTouch runAction:action];
        
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"number_0.png"];
        node.position = CGPointMake(160, 240);
        //touchesBeganで判定に使うため、nameの指定が必要
        node.name = @"button";
        [self addChild:node];
    }
    return self;
}

//スコアとハイスコアを表示
-(void)setScore:(int)score HiScore:(int)hiScore
{
	//ハイスコア
	SKLabelNode *hiScoreTitleNode = [SKLabelNode labelNodeWithFontNamed:@"Baskerville-Bold"];
	hiScoreTitleNode.fontSize = 30;
	hiScoreTitleNode.text = @"HI-SCORE";
	[self addChild:hiScoreTitleNode];
	hiScoreTitleNode.position = CGPointMake(CGRectGetMidX(self.frame)-70,
											CGRectGetMidY(self.frame)+140);
	SKLabelNode*	hiScoreNode = [SKLabelNode labelNodeWithFontNamed:@"Baskerville-Bold"];
	hiScoreNode.fontSize = 30;
	[self addChild:hiScoreNode];
	hiScoreNode.position = CGPointMake(CGRectGetMidX(self.frame)+70,
									   CGRectGetMidY(self.frame)+140);
	hiScoreNode.text = [NSString stringWithFormat:@"%d", hiScore];
	
	//スコア
	SKLabelNode *scoreTitleNode = [SKLabelNode labelNodeWithFontNamed:@"Baskerville-Bold"];
	scoreTitleNode.fontSize = 30;
	scoreTitleNode.position = CGPointMake(CGRectGetMidX(self.frame)-90,
										  CGRectGetMidY(self.frame)+100);
	[self addChild:scoreTitleNode];
	scoreTitleNode.text = @"SCORE";
	SKLabelNode *scoreNode = [SKLabelNode labelNodeWithFontNamed:@"Baskerville-Bold"];
	scoreNode.fontSize = 30;
	scoreNode.position = CGPointMake(CGRectGetMidX(self.frame)+70,
									 CGRectGetMidY(self.frame)+100);
	[self addChild:scoreNode];
	scoreNode.text = [NSString stringWithFormat:@"%d", score];
}

-(void)callPostToTwitter {
    CGRect rect = self.frame;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    [self.view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *dataSaveImage = UIImagePNGRepresentation(image);
    [(ViewController *)[UIApplication sharedApplication].delegate.window.rootViewController postToTwitter:(dataSaveImage)];
}

-(void)callPostToLine {
    CGRect rect = self.frame;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    [self.view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [(ViewController *)[UIApplication sharedApplication].delegate.window.rootViewController postToLine:(image)];
}

-(void)callPostToFacebook {
    CGRect rect = self.frame;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    [self.view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [(ViewController *)[UIApplication sharedApplication].delegate.window.rootViewController postToFacebook:(image)];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if(node != nil && [node.name isEqualToString:@"button"]) {
        [self callPostToLine];
        if([_delegate respondsToSelector:@selector(sceneEscape:)]){
            GameStatus = GAME_TITLE;
            [_delegate sceneEscape:self];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime
{
}

- (void)willMoveFromView:(SKView *)view
{
}

- (void)didMoveToView: (SKView*) view
{
}

@end
