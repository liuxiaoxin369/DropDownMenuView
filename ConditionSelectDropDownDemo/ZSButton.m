//
//  ZSButton.m
//  ZhishanFund
//
//  Created by qzwh on 2018/1/25.
//  Copyright © 2018年 qzwh. All rights reserved.
//

#import "ZSButton.h"

@implementation ZSButton

/**
 重新布局button的内容
 */
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (!self.titleLabel.text.length || !self.imageView.image || self.customstyle == ZSButtonCustomStyleNomal) {
        return;
    }
    
    [self.titleLabel sizeToFit];
    CGRect labelFrame = self.titleLabel.frame;
    if (self.labelSize.width || self.labelSize.height) {
        labelFrame.size = self.labelSize;
    }
    
    [self.imageView sizeToFit];
    CGRect imageFrame = self.imageView.frame;
    if (self.imageSize.width || self.imageSize.height) {
        imageFrame.size = self.imageSize;
    }
    
    switch (self.customstyle) {
        case ZSButtonCustomStylePicTop:
        {
            imageFrame.origin.x = (self.frame.size.width-imageFrame.size.width)*0.5;
            imageFrame.origin.y = (self.frame.size.height-imageFrame.size.height-labelFrame.size.height-self.customSpace)*0.5;
            
            labelFrame.origin.x = (self.frame.size.width-labelFrame.size.width)*0.5;
            labelFrame.origin.y = imageFrame.origin.y+imageFrame.size.height+self.customSpace;
            
            break;
        }
        case ZSButtonCustomStylePicLeft:
        {
            imageFrame.origin.x = (self.frame.size.width-imageFrame.size.width-labelFrame.size.width-self.customSpace)*0.5;
            imageFrame.origin.y = (self.frame.size.height-imageFrame.size.height)*0.5;
            
            labelFrame.origin.x = imageFrame.origin.x+imageFrame.size.width+self.customSpace;
            labelFrame.origin.y = (self.frame.size.height-labelFrame.size.height)*0.5;
            
            break;
        }
        case ZSButtonCustomStylePicDown:
        {
            labelFrame.origin.x = (self.frame.size.width-labelFrame.size.width)*0.5;
            labelFrame.origin.y = (self.frame.size.height-labelFrame.size.height-imageFrame.size.height-self.customSpace)*0.5;
            
            imageFrame.origin.x = (self.frame.size.width-imageFrame.size.width)*0.5;
            imageFrame.origin.y = labelFrame.origin.y+labelFrame.size.height+self.customSpace;
            
            break;
        }
        case ZSButtonCustomStylePicRight:
        {
            labelFrame.origin.x = (self.frame.size.width-imageFrame.size.width-labelFrame.size.width-self.customSpace)*0.5;
            labelFrame.origin.y = (self.frame.size.height-labelFrame.size.height)*0.5;
            
            imageFrame.origin.x = labelFrame.origin.x+labelFrame.size.width+self.customSpace;
            imageFrame.origin.y = (self.frame.size.height-imageFrame.size.height)*0.5;
            break;
        }
        default:
            break;
    }
    
    imageFrame.origin.x += self.imageEdgeInsets.left-self.imageEdgeInsets.right+self.contentEdgeInsets.left-self.contentEdgeInsets.right;
    imageFrame.origin.y += self.imageEdgeInsets.top-self.imageEdgeInsets.bottom+self.contentEdgeInsets.top-self.contentEdgeInsets.bottom;
    self.imageView.frame = imageFrame;
    
    labelFrame.origin.x += self.titleEdgeInsets.left-self.titleEdgeInsets.right+self.contentEdgeInsets.left-self.contentEdgeInsets.right;
    labelFrame.origin.y += self.titleEdgeInsets.top-self.titleEdgeInsets.bottom+self.contentEdgeInsets.top-self.contentEdgeInsets.bottom;
    self.titleLabel.frame = labelFrame;
}

- (void)imageViewAnimateRotateWithState:(BOOL)state {
    [UIView animateWithDuration:0.2 animations:^{
        if (state) {
            self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        } else {
            self.imageView.transform = CGAffineTransformIdentity;
        }
    }];
}

@end
