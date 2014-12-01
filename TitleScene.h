//
//  TitleScene.h
//

#import <SpriteKit/SpriteKit.h>
#import "MyInclude.h"
@interface TitleScene : SKScene
@property	(weak, nonatomic)	id		delegate;
-(void) ButtonCreate:(int)ldx ldy:(int)ldy width:(int)width height:(int)height string:(string)tag;
@end
