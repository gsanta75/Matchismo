//
//  SetCardView.m
//  Matchismo
//
//  Created by Giuseppe Santaniello on 07/03/13.
//  Copyright (c) 2013 Giuseppe Santaniello. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:12.0];
    [roundedRect addClip];
    
    if (self.chosen) {
        [[UIColor colorWithWhite:0.7 alpha:1.0] setFill];
    } else {
        [[UIColor whiteColor] setFill];
    }
    UIRectFill(self.bounds);
    
    [[UIColor colorWithWhite:0.8 alpha:1.0] setStroke];
    [roundedRect stroke];
    
    [self drawSymbols];
}

#define SYMBOL_OFFSET 0.3;
#define SYMBOL_LINE_WIDTH 0.02;

- (void)drawSymbols
{
    [[self symbolColors] setStroke];
    CGPoint point = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)); //CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    if (self.number == 1) {
        [self drawSymbolAtPoint:point];
        return;
    }
    CGFloat dx = self.bounds.size.width * SYMBOL_OFFSET;
    if (self.number == 2) {
        [self drawSymbolAtPoint:CGPointMake(point.x - dx / 2, point.y)];
        [self drawSymbolAtPoint:CGPointMake(point.x + dx / 2, point.y)];
        return;
    }
    if (self.number == 3) {
        [self drawSymbolAtPoint:point];
        [self drawSymbolAtPoint:CGPointMake(point.x - dx, point.y)];
        [self drawSymbolAtPoint:CGPointMake(point.x + dx, point.y)];
        return;
    }
}

- (UIColor *)symbolColors
{
    if ([self.color isEqualToString:@"red"]) return [UIColor redColor];
    if ([self.color isEqualToString:@"green"]) return [UIColor greenColor];
    if ([self.color isEqualToString:@"purple"]) return [UIColor purpleColor];
    return nil;
}

- (void)drawSymbolAtPoint:(CGPoint)point
{
    if ([self.symbol isEqualToString:@"oval"]) [self drawCircleAtPoint:point];
    else if ([self.symbol isEqualToString:@"squiggle"]) [self drawSquiggleAtPoint:point];
    else if ([self.symbol isEqualToString:@"diamond"]) [self drawDiamondAtPoint:point];
}

#define CIRCLE_DIAMETER 0.25

- (void)drawCircleAtPoint:(CGPoint)point
{
    CGFloat radius = self.bounds.size.width * CIRCLE_DIAMETER / 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:0 endAngle:2*M_PI clockwise:NO];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

#define SQUIGGLE_WIDTH 0.20
#define SQUIGGLE_HEIGHT 0.20

- (void)drawSquiggleAtPoint:(CGPoint)point
{
    CGFloat dx = self.bounds.size.width * SQUIGGLE_WIDTH / 2;
    CGFloat dy = dx;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(point.x - dx, point.y - dy, 2*dx, 2*dy)];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

#define DIAMOND_WIDTH 0.25
#define DIAMOND_HEIGHT 0.25

- (void)drawDiamondAtPoint:(CGPoint)point
{
    CGFloat dx = self.bounds.size.width * DIAMOND_WIDTH / 2;
    CGFloat dy = self.bounds.size.height * DIAMOND_HEIGHT / 2;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(point.x, point.y - dy)];
    [path addLineToPoint:CGPointMake(point.x + dx, point.y)];
    [path addLineToPoint:CGPointMake(point.x, point.y + dy)];
    [path addLineToPoint:CGPointMake(point.x - dx, point.y)];
    [path closePath];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

- (void)shadePath:(UIBezierPath *)path
{
    if ([self.shading isEqualToString:@"solid"]) {
        [[self symbolColors] setFill];
        [path fill];
    } else if ([self.shading isEqualToString:@"striped"]) {
        [[[self symbolColors] colorWithAlphaComponent:0.3] setFill];
        [path fill];
    } else if ([self.shading isEqualToString:@"open"]) {
        [[UIColor clearColor] setFill];
    }
}

@end

