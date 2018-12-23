//
//  SKShadowNode.h
//
//  Created on 16/12/2018.
//  Created after seeing this post on StackOverflow: https://stackoverflow.com/questions/26072933/sprite-kit-ios-7-how-to-add-a-shadow-to-a-skspritenode

#import <SpriteKit/SpriteKit.h>


@interface SKShadowNode : SKNode {
@private
	SKNode* _nodeOriginalParent;
	SKSpriteNode* _shadowNode;
	CGPoint _offset;
}

@property BOOL shadowApplied;

- (id) initWithNode:(SKNode*)node shadowColor:(UIColor*)shadowColor alpha:(CGFloat)alpha shadowOffset:(CGPoint)offset;

- (void) showShadowWithAnimationDuration:(NSTimeInterval)duration completion:(void (^)(void))block;

- (BOOL) showShadow;

- (void) hideShadowWithAnimationDuration:(NSTimeInterval)duration completion:(void (^)(void))block;

- (BOOL) hideShadow;

@end

