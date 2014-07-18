//
//  FYLSwitch.h
//  CustomView
//
//  Created by feiyanliang on 14-5-7.
//  Copyright (c) 2014年 feiyanliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYLSwitch : UIView
{
    CALayer  * _bgLayer;
    CALayer  * _whiteLayer;
    CALayer  * _indicateLayer;
    int        _chageTimes;
    id         _target;
    SEL        _action;
    NSInteger  _eventType;
}


@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign,getter = isOn) BOOL   on;

- (id) init;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(NSInteger)event;


@end
