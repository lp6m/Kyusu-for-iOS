//
//  GameScene.m
//　変数にもたせる座標はすべて左上原点系でとる.描画の際に左下原点に変換して表示する.

#import "GameScene.h"
#import "SceneEscapeProtocol.h"
#import "MyInclude.h"
#import "MyInclude2.h"

@implementation GameScene{
	BOOL			_gameOver;				//ゲームオーバーフラグ
    //初期位置の設定
    //mapdataに基づいて盤を設置していく
    /*
     number_0.png -- back
     number_1.png -- road
     number_2.png -- block
     number_3.png -- goal
     number_4~15.png -- num 2^(i-3)*/
    vector<SKTexture*> banbg; //盤のテクスチャ
    vector<SKTexture*> playerbg;
    vector<vector<int> > bandata;//マップデータ
    int MAP_WIDTH;
    int MAP_HEIGHT;
    CGFloat BAN_DRAWSIZE;
    int MAP_POSX;//マップの左上座標
    int MAP_POSY;
    int MY_POSX;//プレイヤーの位置
    int MY_POSY;
    int GOAL_POSX;
    int GOAL_POSY;
    int MY_NUM;//現在のプレイヤーの数字
    #define BANSIZE 64
    #define BAN_DRAWSIZE 30
    #define GRID_BLACKBLOCK 0
    #define GRID_STREET 1
    #define GRID_OBSTACLE 2
    #define GRID_GOAL 3
    
    CGPoint _tBegan, _tEnded;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
	{
        //jsonからマップデータを読み込む
        static NSDictionary *config = nil;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"mapdata" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (!config) {
            config = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        }
        MAP_WIDTH = [config[@"map"][@"width"] intValue];
        MAP_HEIGHT = [config[@"map"][@"height"] intValue];
        MY_POSX = [config[@"map"][@"initpos"][0] intValue];
        MY_POSY = [config[@"map"][@"initpos"][1] intValue];
        MY_NUM = [config[@"map"][@"initnum"] intValue];
        for(int i=0;i<MAP_HEIGHT;i++){
            vector <int> tmp;
            for(int j=0;j<MAP_WIDTH;j++){
                int gridnum = [config[@"map"][@"grid"][i][j] intValue];
                if(gridnum==GRID_GOAL){
                    GOAL_POSX = i; GOAL_POSY = j;
                }
                tmp.push_back(gridnum);
            }
            bandata.push_back(tmp);
        }
        
        //背景
		SKSpriteNode* space = [SKSpriteNode spriteNodeWithImageNamed:@"back.png"];
		space.position = CGPointMake(self.size.width/2, self.size.height/2);
		space.name = kBackName;
		[self addChild:space];
        
		//スコア
		//タイトル
		SKLabelNode *scoreTitleNode = [SKLabelNode labelNodeWithFontNamed:@"Baskerville-Bold"];
		scoreTitleNode.fontSize = 20;
		scoreTitleNode.text = @"SCORE";
		[self addChild:scoreTitleNode];
		scoreTitleNode.position = CGPointMake((scoreTitleNode.frame.size.width/2)+20, self.frame.size.height-30);
		//スコア
		SKLabelNode*	scoreNode = [SKLabelNode labelNodeWithFontNamed:@"Baskerville-Bold"];
		scoreNode.name = kScoreName;
		scoreNode.fontSize = 20;
		[self addChild:scoreNode];
		self.score = 0;
		scoreNode.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height-30);
        
        
        //テクスチャの読み込み
        for(int i=0;i<16;i++){
            NSMutableString* bgfname = [NSMutableString	string];
            [bgfname setString:@"number_"];
            NSString *str2 = [NSString stringWithFormat:@"%d.png", i];
            [bgfname appendString:str2];
            SKTexture* tmp;
            tmp = [SKTexture textureWithImageNamed:bgfname];
            banbg.push_back(tmp);
        }
        
        for(int i=0;i<14;i++){
            NSMutableString* bgfname = [NSMutableString	string];
            [bgfname setString:@"player_"];
            NSString *str2 = [NSString stringWithFormat:@"%d.png", i];
            [bgfname appendString:str2];
            SKTexture* tmp;
            tmp = [SKTexture textureWithImageNamed:bgfname];
            playerbg.push_back(tmp);
        }
        
        //シェアするためのアイコンの読み込み
        SKTexture* sharetex_twitter = [SKTexture textureWithImageNamed:@"share_twitter.png"];
        SKTexture* sharetex_facebook = [SKTexture textureWithImageNamed:@"share_facebook.png"];
        SKTexture* sharetex_line = [SKTexture textureWithImageNamed:@"share_line.png"];
        [self BanDraw];
        
        }
    return self;
}



-(void) BanDraw
{
    //盤データが変更されたときに実行する
    //以前のノードを削除
    [self enumerateChildNodesWithName:@"ban" usingBlock:^(SKNode *node,BOOL *stop){
        [node removeFromParent];
    }];
    
    for(int i=0;i<MAP_HEIGHT;i++){
        for(int j=0;j<MAP_WIDTH;j++){
            SKSpriteNode *ban;
        //左上から描画していく
            ban = [SKSpriteNode spriteNodeWithTexture:banbg[bandata[i][j]] size:CGSize{BAN_DRAWSIZE,BAN_DRAWSIZE}];
            //はじめは左上原点座標系で計算
            int BanPosX = j*BAN_DRAWSIZE;
            int BanPosY = i*BAN_DRAWSIZE;
            BanPosX += (self.frame.size.width - BAN_DRAWSIZE * MAP_WIDTH)/2;
            BanPosY += (self.frame.size.height - BAN_DRAWSIZE * MAP_HEIGHT)/2;
            BanPosY = self.frame.size.height - BanPosY;
            BanPosX += BAN_DRAWSIZE/2;
            BanPosY += BAN_DRAWSIZE/2;
            ban.position = CGPointMake(BanPosX,BanPosY);
            ban.name = @"ban";
            [self addChild:ban];
        }
    }
    
    SKSpriteNode *playerban;
    playerban = [SKSpriteNode spriteNodeWithTexture:playerbg[MY_NUM] size:CGSize{BAN_DRAWSIZE,BAN_DRAWSIZE}];
    int BanPosX = MY_POSY*BAN_DRAWSIZE;
    int BanPosY = MY_POSX*BAN_DRAWSIZE;
    BanPosX += (self.frame.size.width - BAN_DRAWSIZE * MAP_WIDTH)/2;
    BanPosY += (self.frame.size.height - BAN_DRAWSIZE * MAP_HEIGHT)/2;
    BanPosY = self.frame.size.height - BanPosY;
    BanPosX += BAN_DRAWSIZE/2;
    BanPosY += BAN_DRAWSIZE/2;
    playerban.position = CGPointMake(BanPosX,BanPosY);
    playerban.name = @"ban";
    [self addChild:playerban];
}

-(BOOL) IsInRange:(CGPoint)pos
{
    if(pos.x<0||pos.y<0||pos.x > MAP_HEIGHT-1|| pos.y>MAP_WIDTH-1) return NO;
    else return YES;
}

-(void) GridMove:(CGPoint)vec
{
    bandata[MY_POSX][MY_POSY] = MY_NUM+3;
    int nx = MY_POSX;
    int ny = MY_POSY;
    bool isunited = false;
    bool cannotmove = false;
    while(isunited==false){
        if(bandata[nx][ny]==GRID_OBSTACLE){
            cannotmove = true;
            break;
        }
        if(bandata[nx][ny]==GRID_STREET||bandata[nx][ny]==GRID_GOAL){
            break;
        }
        if([self IsInRange:CGPointMake(nx+vec.x,ny+vec.y)]==NO) {
            cannotmove = true;
            break;
        }
        if(bandata[nx][ny] == bandata[nx+vec.x][ny+vec.y]){
            //合体したときの処理
            isunited = true;
            bandata[nx+(int)vec.x][ny+(int)vec.y]++;
            if(nx==MY_POSX&&ny==MY_POSY){
                bandata[MY_POSX][MY_POSY] = GRID_STREET;
                MY_POSX += vec.x;
                MY_POSY += vec.y;
                MY_NUM++;
            }else{
                //bandata[nx+vec.x][ny+vec.y]++;
                bandata[MY_POSX][MY_POSY] = GRID_STREET;
                int px = nx; int py = ny;
                while(1){
                    if(px==MY_POSX&&py==MY_POSY) break;
                    bandata[px][py] = bandata[px-vec.x][py-vec.y];
                    px -= vec.x; py -= vec.y;
                }
                MY_POSX += vec.x; MY_POSY += vec.y;
            }
        }
        nx += vec.x; ny += vec.y;
    }
    if(isunited==false&&cannotmove==false){
        //周辺ブロックが移動する処理
        if(nx==MY_POSX&&ny==MY_POSY){
            //ブロックが一つのとき
            MY_POSX += vec.x;
            MY_POSY += vec.y;
            bandata[MY_POSX][MY_POSY] = GRID_STREET;
            MY_POSX += vec.x;
            MY_POSY += vec.y;
            return;
        }
        //周辺ブロックが移動可能がどうかを判定
        int px = nx; int py = ny;
        while(1){
            if(px==MY_POSX&&py==MY_POSY) break;
            if(bandata[px][py]>bandata[px-vec.x][py-vec.y]){
                return; //移動不可能
            }
            px -= vec.x; py-=vec.y;
        }
        bandata[MY_POSX][MY_POSY] = GRID_STREET;
        while(1){
            if(nx==MY_POSX&&ny==MY_POSY) break;
            bandata[nx][ny] = bandata[nx-vec.x][ny-vec.y];
            nx -= vec.x; ny -= vec.y;
        }
        MY_POSX += vec.x; MY_POSY += vec.y;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touchBegan = [touches anyObject];
    _tBegan = [ touchBegan locationInView: self.view ];
    
	if(_gameOver){
		if([_delegate respondsToSelector:@selector(sceneEscape:)]){
            GameStatus = GAME_OVER;
			[_delegate sceneEscape:self];
		}
		return;
	}

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touchEnded = [touches anyObject];
    _tEnded = [ touchEnded locationInView: self.view ];
    NSInteger distanceHorizontal = ABS( _tEnded.x - _tBegan.x );
    NSInteger distanceVertical = ABS( _tEnded.y - _tBegan.y );
    
    //NSLog(@"%ld", distanceHorizontal);
    //NSLog(@"%ld",  distanceVertical);
    static const NSInteger kFlickMinimumDistance = 10;
    if (kFlickMinimumDistance > distanceHorizontal && kFlickMinimumDistance > distanceVertical) {
        //縦にも横にもあまり移動していなければreturn
        return;
    }
    if ( distanceHorizontal > distanceVertical ) {
        if ( _tEnded.x > _tBegan.x ) {
            //NSLog(@"RIGHT Flick");
            [self GridMove:CGPointMake(0,1)];
        } else {
            //NSLog(@"LEFT Flick");
            [self GridMove:CGPointMake(0,-1)];
        }
    } else {
        if ( _tEnded.y > _tBegan.y ) {
            //NSLog(@"DOWN Flick");
            [self GridMove:CGPointMake(1,0)];
        } else {
            //NSLog(@"UP Flick");
            [self GridMove:CGPointMake(-1,0)];
        }
    }
    [self BanDraw];
    //ゲームクリア判定
    if(MY_POSX==GOAL_POSX&MY_POSY==GOAL_POSY){
        _gameOver = true;
        
    }
    
}


//スコア更新
-(void)setScore:(int)score
{
	_score = score;
	//ラベル更新
	SKLabelNode*	scoreNode;
	scoreNode = (SKLabelNode*)[self childNodeWithName:kScoreName];
	scoreNode.text = [NSString stringWithFormat:@"%d", _score];
}
@end
