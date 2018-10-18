//
//  YNDialView.m
//  
//
//  Created by liyangly on 2018/10/17.
//  Copyright © 2018 liyang. All rights reserved.
//

#import "YNDialView.h"

@interface YNDialView()

@property (nonatomic, strong) NSArray *colorList;

@property (nonatomic, strong) NSMutableArray *btnList;

@property (nonatomic, assign) CGFloat btnWidth;

/************/

@property (nonatomic, assign) CGPoint beginPoint;

@property (nonatomic, assign) CGPoint movePoint;

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) double runAngle;

@property (nonatomic, assign) double panAngle;

@end

@implementation YNDialView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(circleViewGesture:)];
        [self addGestureRecognizer:pan];
        
        _radius = 150;
        _btnWidth = 20;
        
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    self.backgroundColor = [UIColor cyanColor];
    self.layer.cornerRadius = _radius;//self.frame.size.height/2;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_radius].CGPath;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 5;
    
    [self configPieGraph];
    [self configButton];
}

- (void)configPieGraph {
    
    CGPoint center = CGPointMake(_radius, _radius);;
    
    CGFloat redius = _radius;
    CGFloat start = 0;
    CGFloat angle = 0;
    CGFloat end = -(1.f/self.colorList.count) * M_PI;
    
    for (UIColor *bgColor in self.colorList) {
        
        start = end;
        angle = (1.f/self.colorList.count) * M_PI * 2;
        end = start + angle;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:redius startAngle:start endAngle:end clockwise:YES];
        [path addLineToPoint:center];
        
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.fillColor = bgColor.CGColor;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.lineWidth = 0;
        layer.path = path.CGPath;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
        animation.fromValue = @(0);
        animation.toValue = @(1);
        animation.duration = 0.1;
        [layer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
        [self.layer addSublayer:layer];
    }
    
}

- (void)configButton {
    
    self.btnList = [NSMutableArray new];
    NSArray *titleList = @[@"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K", @"A", @"2"];
    for (NSString *title in titleList) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, _btnWidth, _btnWidth);
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 10;
        [self addSubview:btn];
        
        [self.btnList addObject:btn];
    }
    [self btnsLayout];
}

- (void)btnsLayout {
    
    for (NSInteger i = 0; i < self.btnList.count; i++) {
        UIButton *button = self.btnList[i];
        CGFloat number = self.btnList.count;
        CGFloat yy = _radius + sin((i/number)*M_PI*2+_runAngle) * (_radius-_btnWidth/2-20);
        CGFloat xx = _radius + cos((i/number)*M_PI*2+_runAngle) * (_radius-_btnWidth/2-20);
        button.center = CGPointMake(xx, yy);
    }
}

#pragma mark- Private Method
- (void)getSelectButton {
    
    CGFloat start = - (1/self.btnList.count) * M_PI_2;
    CGFloat end = (1/self.btnList.count) * M_PI_2;
    
    // x-axis
    for (UIButton *btn in self.btnList) {
        
        double angle = [self getAngle:btn.center];
        int quadrant = [self getQuadrant:btn.center];
        
        BOOL isQuadrant = (quadrant == 2 || quadrant == 3);
        
        if (isQuadrant && angle >= start && angle <= end) {
            NSString *title = btn.titleLabel.text;
            NSLog(@"%@", title);
        }
        
    }
}

- (double)calculateRunAngle {
    
    double number = self.colorList.count;
    double valuer = 2 * M_PI /number;
    double va = fmod(_runAngle, valuer); //remainder
    
    if (_runAngle > 0 || _runAngle == 0) {
        if (fabs(va) > (valuer/2)) {
            _runAngle -= fabs(va);
            _runAngle += valuer;
        } else {
            _runAngle -= fabs(va);
        }
    } else {
        if (fabs(va) > (valuer/2)) {
            _runAngle += fabs(va);
            _runAngle -= valuer;
        } else {
            _runAngle += fabs(va);
        }
    }
    return _runAngle;
}

- (double)getAngle:(CGPoint)point {
    
    double x = point.x - _radius;
    double y = point.y - _radius;
    return (double)(asin(y / hypot(x, y)));
}


- (int)getQuadrant:(CGPoint)point {
    
    int tmpX = (int)(point.x - _radius);
    int tmpY = (int)(point.y - _radius);
    if (tmpX >= 0) {
        return tmpY >= 0 ? 1 : 4;
    } else {
        return tmpY >= 0 ? 2 : 3;
    }
}

#pragma mark - GestureRecognizer
- (void)circleViewGesture:(UIPanGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _panAngle = 0;
        _beginPoint = [gesture locationInView:self];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        double startAngle = _runAngle;
        _movePoint = [gesture locationInView:self];
        double start = [self getAngle:_beginPoint];
        double move = [self getAngle:_movePoint];
        
        if ([self getQuadrant:_movePoint] == 1 || [self getQuadrant:_movePoint] == 4) {
            _runAngle += move - start;
            _panAngle += move - start;
            
        } else {
            // second and third quadrants
            _runAngle += start - move;
            _panAngle += start - move;
        }
        
        [self btnsLayout];
        _beginPoint = _movePoint;
    }
    else if (gesture.state == UIGestureRecognizerStateEnded){
        
        [self calculateRunAngle];
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            [self btnsLayout];
            self.userInteractionEnabled =YES;
        } completion:^(BOOL finished) {
            [self getSelectButton];
        }];
    }
}

#pragma mark - Getters
- (NSArray *)colorList {
    if (!_colorList) {
        _colorList = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor], [UIColor purpleColor], [UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor], [UIColor purpleColor], [UIColor cyanColor]];
    }
    return _colorList;
}


@end
