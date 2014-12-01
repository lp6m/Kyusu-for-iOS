//
//  ViewController.h
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <Social/Social.h>
@interface ViewController : UIViewController
- (void)postToTwitter:(NSData *)image;
- (void)postToLine:(UIImage *)image;
- (void)postToFacebook:(UIImage *)image;
@end
