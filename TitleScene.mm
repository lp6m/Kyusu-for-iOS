//
//  TitleScene.m
//

#import "TitleScene.h"
#import "SceneEscapeProtocol.h"
#import "MyInclude.h"
#import "MyInclude2.h"
@implementation TitleScene




vector<button_set> button_list;

-(void) ButtonCreate:(int)ldx ldy:(int)ldy width:(int)width height:(int)height string:(string)tag
{
    button_set tmp;
    tmp.ldx = ldx;
    tmp.ldy = ldy;
    tmp.width = width;
    tmp.height = height;
    tmp.tag = tag;
    button_list.push_back(tmp);
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
		//背景
		SKSpriteNode* space = [SKSpriteNode spriteNodeWithImageNamed:@"title"];
		space.position = CGPointMake(self.size.width/2, self.size.height/2);
        space.size = CGSizeMake(self.size.width,self.size.height);
		space.name = @"back";
		[self addChild:space];
		
        //ボタンをつくる 座標は左下x,左下y,sizeX,sizeY
        const int TITLE_BUTTON_WIDTH = 180*(int)self.size.width/320;//iPhone5/5Sの横幅は320
        const int TITLE_BUTTON_HEIGHT = 30*(int)self.size.height/518;//iPhone5/5Sの縦幅は518
        const int TITLE_BUTTON_INTERVAL_Y = 40*(int)self.size.height/518+TITLE_BUTTON_HEIGHT;
        const int TITLE_BUTTON_POSX = ((int)self.size.width - TITLE_BUTTON_WIDTH)/2;
        const int TITLE_BUTTON_POSY_bottom = 90*(int)self.size.height/518;
        int buttonx,buttony,buttonwidth,buttonheight;
        //クレジットボタン
        SKShapeNode* creditbutton = [SKShapeNode node];
        buttonx = TITLE_BUTTON_POSX; buttony = TITLE_BUTTON_POSY_bottom; buttonwidth =TITLE_BUTTON_WIDTH; buttonheight = TITLE_BUTTON_HEIGHT;
        [creditbutton setPath:CGPathCreateWithRoundedRect(CGRectMake(buttonx,buttony,buttonwidth,buttonheight),10,10, nil)];
        creditbutton.strokeColor = creditbutton.fillColor = [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:255.0/255.0 alpha:0.7];
        [self ButtonCreate:buttonx ldy:buttony width:buttonwidth height:buttonheight string:"creditbutton"];
        creditbutton.name=@"creditbutton";
        [self addChild:creditbutton];
        SKLabelNode *creditstring = [SKLabelNode labelNodeWithFontNamed:@"HiraKakuProN-W6"];
		creditstring.text = @"クレジット";
        creditstring.fontColor = [UIColor blackColor];
		creditstring.fontSize = 20;
        creditstring.name=@"creditbutton";
		creditstring.position = CGPointMake(buttonx+buttonwidth/2,buttony+buttonheight/2-(int)creditstring.fontSize/2);
		[self addChild:creditstring];
        
        //スタートボタン
        SKShapeNode* startbutton = [SKShapeNode node];
        buttony+=TITLE_BUTTON_INTERVAL_Y;
        [startbutton setPath:CGPathCreateWithRoundedRect(CGRectMake(buttonx,buttony,buttonwidth,buttonheight),10,10, nil)];
        startbutton.strokeColor = startbutton.fillColor = [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:255.0/255.0 alpha:0.7];
        startbutton.name=@"gamestartbutton";
        [self addChild:startbutton];
        SKLabelNode *startstring = [SKLabelNode labelNodeWithFontNamed:@"HiraKakuProN-W6"];
        [self ButtonCreate:buttonx ldy:buttony width:buttonwidth height:buttonheight string:"gamestartbutton"];
		startstring.text = @"GAME START";
        startstring.fontColor = [UIColor blackColor];
		startstring.fontSize = 20;
        //startstring.name=@"gamestartbutton";
		startstring.position = CGPointMake(buttonx+buttonwidth/2,buttony+buttonheight/2-(int)startstring.fontSize/2);
		[self addChild:startstring];
        //遊び方ボタン
        SKShapeNode* howtoplaybutton = [SKShapeNode node];
        buttony+=TITLE_BUTTON_INTERVAL_Y;
        [howtoplaybutton setPath:CGPathCreateWithRoundedRect(CGRectMake(buttonx,buttony,buttonwidth,buttonheight),10,10, nil)];
        howtoplaybutton.strokeColor = howtoplaybutton.fillColor = [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:255.0/255.0 alpha:0.7];
        howtoplaybutton.name=@"howtoplaybutton";
        [self addChild:howtoplaybutton];
        SKLabelNode *howtoplaystring = [SKLabelNode labelNodeWithFontNamed:@"HiraKakuProN-W6"];
        [self ButtonCreate:buttonx ldy:buttony width:buttonwidth height:buttonheight string:"howtoplaybutton"];
		howtoplaystring.text = @"遊び方";
        howtoplaystring.fontColor = [UIColor blackColor];
		howtoplaystring.fontSize = 20;
        howtoplaystring.name=@"howtoplaybutton";
		howtoplaystring.position = CGPointMake(buttonx+buttonwidth/2,buttony+buttonheight/2-(int)howtoplaystring.fontSize/2);
		[self addChild:howtoplaystring];

		//点滅アクション
		/*NSArray*	actions = @[[SKAction fadeAlphaTo:0.0 duration:0.75],
								[SKAction fadeAlphaTo:1.0 duration:0.75]];
		SKAction*	action = [SKAction repeatActionForever:[SKAction sequence:actions]];
		[pleaseTouch runAction:action];*/
		
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    /*SKNode *node = [self nodeAtPoint:location];
    if(node != nil && [node.name isEqualToString:@"creditbutton"]) { これうまく動かん死んでくれ*/
    for(int i=0;i<button_list.size();i++){
        if(button_list[i].ldx<location.x&&location.x<button_list[i].ldx+button_list[i].width&&button_list[i].ldy<location.y&&location.y<button_list[i].ldy+button_list[i].height){
            if(button_list[i].tag=="creditbutton"){
                if([_delegate respondsToSelector:@selector(sceneEscape:)]){
                    GameStatus = GAME_STAFFCREDIT;
                    [_delegate sceneEscape:self];
                }
            }
            if(button_list[i].tag=="gamestartbutton"){
                if([_delegate respondsToSelector:@selector(sceneEscape:)]){
                    GameStatus = GAME_MAIN;
                    [_delegate sceneEscape:self];
                }
            }
            if(button_list[i].tag=="howtoplaybutton"){
                if([_delegate respondsToSelector:@selector(sceneEscape:)]){
                    GameStatus = GAME_HOWTOPLAY;
                    [_delegate sceneEscape:self];
                }

            }
        }
    }
}

@end

