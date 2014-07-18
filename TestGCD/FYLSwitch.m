//
//  FYLSwitch.m
//  CustomView
//
//  Created by feiyanliang on 14-5-7.
//  Copyright (c) 2014年 feiyanliang. All rights reserved.
//

#import "FYLSwitch.h"

@implementation FYLSwitch

- (id)initWithFrame:(CGRect)frame
{
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, 52, 32);
    self = [super initWithFrame:newFrame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.exclusiveTouch = YES;
        self.layer.frame = newFrame;
        _bgLayer = [[CALayer alloc] init];
       
        _bgLayer.frame = CGRectMake(0, 0, 52, 32);
//        _bgLayer.borderColor = [UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1].CGColor;
//        _bgLayer.borderWidth = 1.50f;
        _bgLayer.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
        _bgLayer.cornerRadius = 15.0f;
        [self.layer addSublayer:_bgLayer];
        

        
        _whiteLayer = [[CALayer alloc] init];
        _whiteLayer.frame = CGRectMake(1, 1, 50, 30);
        _whiteLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _whiteLayer.cornerRadius = 15.0f;
        [self.layer addSublayer:_whiteLayer];
        
        _indicateLayer = [[CALayer alloc] init];
        _indicateLayer.frame = CGRectMake(1, 1, 30, 30);
        _indicateLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _indicateLayer.cornerRadius = 15.0f;
        _indicateLayer.borderColor = [UIColor grayColor].CGColor;
        _indicateLayer.borderWidth = 0.1f;
        [self.layer addSublayer:_indicateLayer];
        

    }
    return self;
}
- (id) init
{
    return [self initWithFrame:CGRectMake(0, 0, 52, 32)];
}

- (void)setFrame:(CGRect)frame
{
    if (!CGRectEqualToRect(_frame, frame)) {
        CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, 52, 32);
        _frame = newFrame;
        [super setFrame:frame];
    }
}
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(NSInteger)event
{
    _target = target;
    _action = action;
    _eventType = event;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGRect frame = _indicateLayer.frame;
    frame.size.width += 8;
    if (_on) {
        
        frame.origin.x -= 8;
        _indicateLayer.frame = frame;
        
    }else{
        _indicateLayer.frame = frame;
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CATransform3D whiteTrans =  CATransform3DMakeScale(0.4, 0.01, 0.01);
            _whiteLayer.transform = whiteTrans;
            
        } completion:^(BOOL finished) {
            _whiteLayer.backgroundColor = [UIColor clearColor].CGColor;

        }];
      
    }
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch * touche = [touches anyObject];
    CGPoint  location = [touche locationInView:self];
    CGPoint  preLocation = [touche previousLocationInView:self];
    NSLog(@"%@",NSStringFromCGPoint(location));
    if (location.x > 51 && preLocation.x<51) {
        
        _on = YES;
        _chageTimes += 1;
        if (_target && [_target respondsToSelector:_action]) {
            [_target performSelector:_action withObject:self];
        }
        _bgLayer.backgroundColor = [UIColor colorWithRed:76/255.0 green:217/255.0 blue:100/255.0 alpha:1].CGColor;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _indicateLayer.frame;
            frame.origin.x = 13;
            
            _indicateLayer.frame = frame;
            
        }];
        
        
    }else if(location.x < 0 && preLocation.x > 0)
    {
        
        _on = NO;
        _chageTimes += 1;
        if (_target && [_target respondsToSelector:_action]) {
            [_target performSelector:_action withObject:self];
        }
        
    _bgLayer.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _indicateLayer.frame;
            frame.origin.x = 1;
            _indicateLayer.frame = frame;
            
        }];
        
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_chageTimes == 0) {
        _on = !_on;
        if (_target && [_target respondsToSelector:_action]) {
            [_target performSelector:_action withObject:self];
        }
    }
    _chageTimes = 0;
    
    
   __block CGRect frame = _indicateLayer.frame;
    
    if (_on) {
        [UIView animateWithDuration:0.3 animations:^{
            frame.size.width -= 8;
            frame.origin.x = 21;
 
            _indicateLayer.frame = frame;
            
        
        } completion:^(BOOL finished) {
            
        }];
        _bgLayer.backgroundColor = [UIColor colorWithRed:76/255.0 green:217/255.0 blue:100/255.0 alpha:1].CGColor;
    }else
    {
        [UIView animateWithDuration:0.3 animations:^{
            frame.size.width -= 8;
            frame.origin.x = 1;
            _indicateLayer.frame = frame;
           

            _bgLayer.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;



            
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.4 animations:^{
            _whiteLayer.transform = CATransform3DMakeScale(1, 1, 1);
            _whiteLayer.backgroundColor = [UIColor whiteColor].CGColor;
        } completion:^(BOOL finished) {
            
        }];
        
    
    }
    _indicateLayer.frame = frame;
    
   
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  [UIView animateWithDuration:0.3 animations:^{
     CGRect frame = _indicateLayer.frame;
      frame.size = CGSizeMake(30, 30);
      _indicateLayer.frame = frame;
  }];
}


//重写它用来隐藏子视图的触摸事件。
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
