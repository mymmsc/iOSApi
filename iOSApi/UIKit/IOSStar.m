//
//  Star.m
//  NewZhiyou
//
//  Created by user on 11-8-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "iOSStar.h"

@implementation iOSStar
@synthesize delegate;
@synthesize font_size, max_star, show_star;
@synthesize empty_color, full_color, isSelect;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        max_star = 100;
        show_star = 0;
        isSelect = NO;
        
        self.backgroundColor = [UIColor clearColor];
        font_size = 13.0f;
        self.empty_color = [UIColor colorWithRed:167.0f / 255.0f green:167.0f / 255.0f blue:167.0f / 255.0f alpha:1.0f];
        self.full_color = [UIColor colorWithRed:255.0f / 255.0f green:121.0f / 255.0f blue:22.0f / 255.0f alpha:1.0f];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSString* stars = @"★★★★★";
    
    rect = self.bounds;
    UIFont *font = [UIFont boldSystemFontOfSize: font_size];
    CGSize starSize = [stars sizeWithFont: font];
    rect.size = starSize;
    [empty_color set];
    [stars drawInRect:rect withFont:font];
    //[@"☆☆☆☆☆" drawInRect:rect withFont:font];
    
    CGRect clip=rect;
    clip.size.width = clip.size.width * show_star / max_star;
    CGContextClipToRect(context,clip);
    [full_color set];
    [stars drawInRect:rect withFont:font];
}

- (void)onChangeValue:(int)value{
    if (value < 0) {
        value = 0;
    } else if (value > max_star) {
        value = max_star;
    }
    show_star = value;
    if ([delegate respondsToSelector:@selector(star:onChange:)]) {
        [delegate star:self onChange:value];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if (isSelect) {
        CGPoint pt = [[touches anyObject] locationInView:self];
        UIFont *font = [UIFont boldSystemFontOfSize: font_size];
        CGSize starSize = [@"★★★★★" sizeWithFont: font];
        if (pt.x > starSize.width + 5) {
            return;
        }
        show_star = (NSInteger)(100.0f * pt.x / starSize.width);
        [self setNeedsDisplay];
        [self onChangeValue:show_star];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if (isSelect) {
        CGPoint pt = [[touches anyObject] locationInView:self];
        UIFont *font = [UIFont boldSystemFontOfSize: font_size];
        CGSize starSize = [@"★★★★★" sizeWithFont: font];
        if (pt.x > starSize.width + 5) {
            return;
        }
        show_star = (NSInteger)(100.0f * pt.x / starSize.width);
        [self setNeedsDisplay];
        [self onChangeValue:show_star];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{

}

- (void)dealloc
{
    [empty_color release];
    empty_color = nil;
    [full_color release];
    full_color = nil;
    
    [super dealloc];
}

@end
