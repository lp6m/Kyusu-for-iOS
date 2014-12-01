//
//  ResultScene.h
//

#import <SpriteKit/SpriteKit.h>
#import <Social/Social.h>
#import "ViewController.h"
@interface ResultScene : SKScene
@property	(weak, nonatomic)	id		delegate;

-(void)setScore:(int)score HiScore:(int)hiScore;

@end
