//
//  SKShadowNode.m
//
//  Created on 16/12/2018.
//  Copyright © 2018 Rodolfo Graça. All rights reserved.
//  Created after seeing this post on StackOverflow: https://stackoverflow.com/questions/26072933/sprite-kit-ios-7-how-to-add-a-shadow-to-a-skspritenode

#import "SKShadowNode.h"

@implementation SKShadowNode

- (id) initWithNode:(SKNode*)node shadowColor:(UIColor*)shadowColor alpha:(CGFloat)alpha shadowOffset:(CGPoint)offset {
	if (node==nil) {
		return nil;
	}
	if (node.parent!=nil && [node.parent isKindOfClass:[SKShadowNode class]]) {
		return (SKShadowNode*)(node.parent);
	}
	self = [super init];
	if (self) {
		self.shadowApplied=NO;
		_nodeOriginalParent=node.parent;
		_offset.x=offset.x/2;
		_offset.y=offset.y/2;
		
		self.zPosition=node.zPosition;
		self.position=node.position;
		self.name=node.name;
		node.name=[node.name stringByAppendingString:@"_originalNode"];
		[node moveToParent:self];
		node.position=CGPointZero;
		
		//From https://stackoverflow.com/questions/26072933/sprite-kit-ios-7-how-to-add-a-shadow-to-a-skspritenode
		_shadowNode = [node copy];
		_shadowNode.blendMode = SKBlendModeAlpha;
		_shadowNode.colorBlendFactor = 1;
		_shadowNode.color = shadowColor;
		_shadowNode.alpha = alpha;  // make shadow partly transparent
		_shadowNode.position=CGPointZero;
		_shadowNode.zPosition=1;
		_shadowNode.name=[self.name stringByAppendingString:@"_shadowNode"];
		[self addChild:_shadowNode];
		
		if (_nodeOriginalParent!=nil) {
			[_nodeOriginalParent addChild:self];
		}
	}
	return self;
}

- (void) removeFromParent {
	[_shadowNode removeFromParent];
	[_shadowNode release];
	SKNode* node=[self childNodeWithName:[self.name stringByAppendingString:@"_originalNode"]];
	node.name=self.name;
	if (_nodeOriginalParent!=nil) {
		[node moveToParent:_nodeOriginalParent];
	} else {
		[node removeFromParent];
		node.position=self.position;
	}
	[super removeFromParent];
}


- (void) showShadowWithAnimationDuration:(NSTimeInterval)duration completion:(void (^)(void))block {
	if (self.shadowApplied) {
		return;
	}
	if (self.parent!=nil) {
		[self runAction:[SKAction moveBy:CGVectorMake(-_offset.x, -_offset.y) duration:duration] completion:^{
			if (block!=nil) {
				block();
			}
		}];
		[_shadowNode runAction:[SKAction moveBy:CGVectorMake(_offset.x, _offset.y) duration:duration]];
		self.shadowApplied=YES;
	} else {
		if ([self showShadow]) {
			if (block!=nil) {
				block();
			}
		}
	}
	return;
}

- (BOOL) showShadow {
	if (self.shadowApplied) {
		return NO;
	}
	self.position=CGPointMake(self.position.x-_offset.x,self.position.y-_offset.y);
	_shadowNode.position=CGPointMake(_shadowNode.position.x+_offset.x,_shadowNode.position.y+_offset.y);
	self.shadowApplied=YES;
	return YES;
}

- (void) hideShadowWithAnimationDuration:(NSTimeInterval)duration completion:(void (^)(void))block {
	if (!self.shadowApplied) {
		return;
	}
	if (self.parent!=nil) {
		[self runAction:[SKAction moveBy:CGVectorMake(_offset.x, _offset.y) duration:duration] completion:^{
			if (block!=nil) {
				block();
			}
		}];
		[_shadowNode runAction:[SKAction moveBy:CGVectorMake(-_offset.x, -_offset.y) duration:duration]];
		self.shadowApplied=NO;
	} else {
		if ([self hideShadow]) {
			if (block!=nil) {
				block();
			}
		}
	}
}

- (BOOL) hideShadow {
	if (!self.shadowApplied) {
		return NO;
	}
	self.position=CGPointMake(self.position.x+_offset.x,self.position.y+_offset.y);
	_shadowNode.position=CGPointMake(_shadowNode.position.x-_offset.x,_shadowNode.position.y-_offset.y);
	self.shadowApplied=NO;
	return YES;
}



@end
