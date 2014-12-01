//
//  HowToPlay.h
//  Kyusu for iOS
//
//  Created by lp6m on 2014/11/28.
//
//

#import <SpriteKit/SpriteKit.h>
#import "MyInclude.h"
@interface HowToPlayScene : SKScene
@property	(weak, nonatomic)	id		delegate;
-(void)PageRefresh:(int)page;
-(void) ButtonCreate:(int)ldx ldy:(int)ldy width:(int)width height:(int)height string:(string)tag;
@end

