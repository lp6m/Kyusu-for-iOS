//
//  HowToPlayScene.mm
//  Kyusu for iOS
//
//  Created by lp6m on 2014/11/28.
//
//

#import "HowToPlayScene.h"
#import "SceneEscapeProtocol.h"
#import "MyInclude.h"
#import "MyInclude2.h"
@implementation HowToPlayScene

int nowpage;
vector<SKTexture*> howtobg;
SKTexture *nextArrowTex;
SKTexture *backArrowTex;
#define ArrowDrawSizeWidth (float)60*self.size.width/320
#define ArrowDrawPosX (float)40*self.size.width/320//center
#define ArrowDrawPosY (float)60*self.size.height/518//center
#define ArrowDrawIntervalX (float)250*self.size.width/320

-(void) ButtonCreate:(int)ldx ldy:(int)ldy width:(int)width height:(int)height string:(string)tag
{
    button_set tmp;
    tmp.ldx = ldx;
    tmp.ldy = ldy;
    tmp.width = width;
    tmp.height = height;
    tmp.tag = tag;
    tmp.on = true;
    button_list.push_back(tmp);
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
		
        howtobg.push_back([SKTexture textureWithImageNamed:@"howtoplay1.png"]);
        howtobg.push_back([SKTexture textureWithImageNamed:@"howtoplay2.png"]);
        howtobg.push_back([SKTexture textureWithImageNamed:@"howtoplay3.png"]);
        nextArrowTex = [SKTexture textureWithImageNamed:@"rightArrow.png"];
        backArrowTex = [SKTexture textureWithImageNamed:@"leftArrow.png"];
        nowpage = 0;//はじめのページは1ページ目
        NSLog(@"gdfh");
        [self PageRefresh:(nowpage)];
        
    }
    return self;
}

-(void)PageRefresh:(int)page
{
    NSLog(@"%d",page);
    const int BUTTON_WIDTH = 180*(int)self.size.width/320;//iPhone5/5Sの横幅は320
    const int BUTTON_HEIGHT = 100*(int)self.size.height/1136;//iPhone5/5Sの縦幅は1136
    const int BUTTON_POSX = ((int)self.size.width - BUTTON_WIDTH)/2;
    const int BUTTON_POSY_bottom = 190*(int)self.size.height/1136;
    //以前のノードを削除
    [self enumerateChildNodesWithName:@"howtocomponent" usingBlock:^(SKNode *node,BOOL *stop){
        [node removeFromParent];
    }];
    [self enumerateChildNodesWithName:@"returntotitlebutton" usingBlock:^(SKNode *node,BOOL *stop){
        [node removeFromParent];
    }];
    [self enumerateChildNodesWithName:@"nextbutton" usingBlock:^(SKNode *node,BOOL *stop){
        [node removeFromParent];
    }];
    [self enumerateChildNodesWithName:@"backbutton" usingBlock:^(SKNode *node,BOOL *stop){
        [node removeFromParent];
    }];
    //新しくはる
    SKSpriteNode* backbg;
    backbg = [SKSpriteNode spriteNodeWithTexture:howtobg[page] size:CGSize{self.size.width,self.size.height}];
    backbg.position = CGPointMake(self.size.width/2, self.size.height/2);
    backbg.name = @"howtocomponent";
    [self addChild:backbg];
    if(page!=howtobg.size()-1){
        //次へ
        SKSpriteNode *nextArrowNode;
        nextArrowNode = [SKSpriteNode spriteNodeWithTexture:nextArrowTex size:CGSizeMake(ArrowDrawSizeWidth,ArrowDrawSizeWidth*7/12)];
        nextArrowNode.position = CGPointMake(ArrowDrawPosX+ArrowDrawIntervalX,ArrowDrawPosY);
        nextArrowNode.name = @"nextbutton";
        [self ButtonCreate:nextArrowNode.position.x - nextArrowNode.size.width/2 ldy:nextArrowNode.position.y - nextArrowNode.size.height/2 width:nextArrowNode.size.width height:nextArrowNode.size.height string:"nextbutton" ];
        [self addChild:nextArrowNode];
    }else{
        for(int i=0;i<button_list.size();i++){
            if(button_list[i].tag == "nextbutton"){
                button_list.erase(button_list.begin()+i);
                break;
            }
        }
    }
    if(page!=0){
        //前へ
        SKSpriteNode *backArrowNode;
        backArrowNode = [SKSpriteNode spriteNodeWithTexture:backArrowTex size:CGSizeMake(ArrowDrawSizeWidth,ArrowDrawSizeWidth*7/12)];
        backArrowNode.position = CGPointMake(ArrowDrawPosX,ArrowDrawPosY);
        backArrowNode.name = @"backbutton";
        [self ButtonCreate:backArrowNode.position.x - backArrowNode.size.width/2 ldy:backArrowNode.position.y - backArrowNode.size.height/2 width:backArrowNode.size.width height:backArrowNode.size.height string:"backbutton" ];
        [self addChild:backArrowNode];
    }else{
        for(int i=0;i<button_list.size();i++){
            if(button_list[i].tag == "backbutton"){
                button_list.erase(button_list.begin()+i);
                break;
            }
        }
    }
    if(page==howtobg.size()-1){
        SKShapeNode* returntotitlebutton = [SKShapeNode node];
        [returntotitlebutton setPath:CGPathCreateWithRoundedRect(CGRectMake(BUTTON_POSX,BUTTON_POSY_bottom,BUTTON_WIDTH,BUTTON_HEIGHT),10,10, nil)];
        returntotitlebutton.strokeColor = returntotitlebutton.fillColor = [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:255.0/255.0 alpha:0.7];
        returntotitlebutton.name=@"returntotitlebutton";
        [self addChild:returntotitlebutton];
        SKLabelNode *returntotitlestring = [SKLabelNode labelNodeWithFontNamed:@"HiraKakuProN-W6"];
		returntotitlestring.text = @"タイトルに戻る";
        returntotitlestring.fontColor = [UIColor blackColor];
		returntotitlestring.fontSize = 20;
        returntotitlestring.name=@"returntotitlebutton";
		returntotitlestring.position = CGPointMake(BUTTON_POSX+BUTTON_WIDTH/2,BUTTON_POSY_bottom+BUTTON_HEIGHT/2-(int)returntotitlestring.fontSize/2);
        [self ButtonCreate:BUTTON_POSX ldy:BUTTON_POSY_bottom width:BUTTON_WIDTH height:BUTTON_HEIGHT string:"returntotitlebutton"];
		[self addChild:returntotitlestring];
    }else{
        for(int i=0;i<button_list.size();i++){
            if(button_list[i].tag == "returntotitlebutton"){
                button_list.erase(button_list.begin()+i);
                break;
            }
        }
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    /*SKNode *node = [self nodeAtPoint:location];
     if(node != nil && [node.name isEqualToString:@"creditbutton"]) { これうまく動かん死んでくれ*/
    bool pushed = false;
    for(int i=0;i<button_list.size();i++){
        if(button_list[i].ldx<location.x&&location.x<button_list[i].ldx+button_list[i].width&&button_list[i].ldy<location.y&&location.y<button_list[i].ldy+button_list[i].height){
            if(button_list[i].tag=="nextbutton"){
                if(pushed==false){
                    nowpage++;
                    pushed = true;
                    [self PageRefresh:nowpage];
                }
                
            }
            if(button_list[i].tag=="backbutton"){
                if(pushed==false){
                    nowpage--;
                    pushed = true;
                    [self PageRefresh:nowpage];
                }
                
            }
            if(button_list[i].tag=="returntotitlebutton"){
                if([_delegate respondsToSelector:@selector(sceneEscape:)]){
                    GameStatus = GAME_TITLE;
                    [_delegate sceneEscape:self];
                }
            }
        }
    }

}

@end