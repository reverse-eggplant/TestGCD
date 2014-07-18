//
//  SXViewController.m
//  TestGCD
//
//  Created by malone on 14-5-8.
//  Copyright (c) 2014年 sanxian. All rights reserved.
//

#import "SXViewController.h"

@interface SXViewController ()
{
    UIProgressView * progressIndicator;
}
@end

@implementation SXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    FYLSwitch * fylswitch = [[FYLSwitch alloc]initWithFrame:CGRectMake(100.0, 200.0, 20.0, 40.0)];
    [self.view addSubview:fylswitch];
    
    [fylswitch addTarget:self action:@selector(testGroupGCD) forControlEvents:NSIntegerMax];
    fylswitch.on = NO;
    
    progressIndicator = [[UIProgressView alloc]initWithFrame:CGRectMake(10.0, 100.0, 300.0, 5.0)];
    progressIndicator.backgroundColor = [UIColor orangeColor];
    progressIndicator.progress = 0.3;
    [self.view addSubview:progressIndicator];
    
    testArrary1 = [NSMutableArray array];
    
    for (int i = 0; i<10; i++) {
        
        [testArrary1 addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
//    [self testBlock1];
//    [self testBlock2];

    
    
    
    
    
    
//    [self testGroupGCD];
    
//    [self testGCDApply];
    
//    [self testGCDSource];
    
//    [self testGCD5];
    
}

#pragma mark Block

//带参数的block
- (void)testBlock1{
    
    //声明可用block
    double (^distanceFromRateAndTime)(double rate, double time) = ^(double rate,double time){
        return rate*time; //创建并给block赋值
    };
    
    //调用block
    double dx = distanceFromRateAndTime(35, 1.5);
    NSLog(@"dx = %f",dx);
    
    
    NSString * firstName = @"ma";
    NSString * (^getfullName)(NSString *) = ^(NSString * string){
        return [NSString stringWithFormat:@"%@%@",firstName,string];
    };
    NSLog(@"name = %@",getfullName(@"long"));
    
}

//不带参数的block
- (void)testBlock2{

    double(^nocanshu)(void) = ^{
        return (double)(arc4random()%200);
    };
    
    NSLog(@"nocanshu = %f",nocanshu()*100);

};



- (void)testBlock3{
    
}

#pragma mark GCD的dispatch group应用
/*
 
 调度组，可以将多个block组建成一个组，以检测这些block全部完成或等待全部完成时发出的消息。
 
 */


- (void)testGroupGCD{
    //普通的异步执行
    //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //
    //    for (id obj in  testArrary1)
    //        dispatch_async(queue, ^{
    //        [self doSomethingWithString:obj];
    //
    //    });
    //    [self doSomethingWithArrary:testArrary1];
    
    
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    for (id obj in  testArrary1)
        dispatch_group_async(group, queue, ^{
            [self doSomethingWithString:obj];
            
        });
    
    //    //当group中的block执行完后，再执行doSomethingWithArrary。doSomethingWithArrary为同步的
    //    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    //    [self doSomethingWithArrary:testArrary1];
    
    
    
    
    //    //当group中的block执行完后，再执行doSomethingWithArrary。doSomethingWithArrary可以异步执行，上述方法可以改成。
    
    dispatch_group_notify(group, queue, ^{
        [self doSomethingWithArrary:testArrary1];
    });
    
    NSLog(@"string");
    
    //注：注意如果-doSomethingWithArrary:需要在主线程中执行，比如操作GUI，那么我们只要将main queue而非全局队列传给dispatch_group_notify函数就行了。
}


#pragma mark GCD的dispatch_apply应用
/*

 这个函数调用单一block多次，并平行运算，然后等待所有运算结束
 
 */

- (void)testGCDApply
{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
////一次执行10次的同步执行
//    dispatch_apply([testArrary1 count], queue, ^(size_t index) {
//        [self doSomethingWithString:[testArrary1 objectAtIndex:index]]; //同时调用该行语句10次
//        
//    });
//    [self doSomethingWithArrary:testArrary1];    //该行代码执行不会快于上诉10个中的任意一个

    
//这很棒，但是异步咋办？dispatch_apply函数可是没有异步版本的。但是我们使用的可是一个为异步而生的API啊！所以我们只要用dispatch_async函数将所有代码推到后台就行了：
    
    dispatch_async(queue, ^{
        dispatch_apply([testArrary1 count], queue, ^(size_t index){
            [self doSomethingWithString:[testArrary1 objectAtIndex:index]];
        });
        [self doSomethingWithArrary:testArrary1];
        
    });
    
}


#pragma mark GCD的Dispatch Sources应用
/*
 dispatch source是一个监视某些类型事件的对象。当这些事件发生时，它自动将一个block放入一个dispatch queue的执行例程中。
 
 Dispatch source启动时默认状态是挂起的，我们创建完毕之后得主动恢复，否则事件不会被传递，也不会被执行
 
 */


- (void)testGCDSource
{
    
    dispatch_queue_t globalqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    
    //用户事件
//    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
//    
//    dispatch_source_set_event_handler(source, ^{
//        
//        progressIndicator.progress = dispatch_source_get_data(source);
//    
//    });
//    
//    dispatch_resume(source);
//    
//    dispatch_apply([testArrary1 count], globalqueue, ^(size_t index) {
//        
//        [self doSomethingWithString:[testArrary1 objectAtIndex:index]];
//
//    });
    
                   
    //内建事件。示例：用GCD读取标准输入
    
    dispatch_source_t stdinsource = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, STDIN_FILENO, 0, globalqueue);
    
    dispatch_source_set_event_handler(stdinsource, ^{
        
        char buf[1024];
        int len = read(STDIN_FILENO, buf, sizeof(buf));
        if(len > 0)
            NSLog(@"Got data from stdin: %.*s", len, buf);
        
    });
    dispatch_resume(stdinsource);
    
    
    
    
    
    
    
}
                   


- (void)doSomethingWithString:(NSString *)string{
    
    string = [NSString stringWithFormat:@"%@+%@",string,string];
    NSLog(@"string = %@",string);
    
}

- (void)doSomethingWithArrary:(NSMutableArray *)arrary
{
    NSLog(@"arrary = %@",arrary);
}





-(void)testGCD1{
    
    
    //创建自己的队列
    
    static BOOL flag=NO;
    
    
    dispatch_queue_t myQueue=dispatch_queue_create("identifier", NULL);
    
    dispatch_async(myQueue, ^{
        
        for (int i=0; i<10; i++) {
            NSLog(@"%d",i);
        }
        flag=YES;
    });
    
    
    NSLog(@"before");
    
    while (!flag){
        NSLog(@"after");
        
    }
    NSLog(@"after2");
    
    
}


-(void)testGCD2{
    //信号
    __block dispatch_semaphore_t testdiaodu= dispatch_semaphore_create(0);
    //创建一个自己的队列
    dispatch_queue_t queue = dispatch_queue_create("identifier", NULL);
    
    dispatch_async(queue, ^{
        for (int i=0; i<10; i++) {
            NSLog(@"%d",i);
            if (i == 5) {
                dispatch_semaphore_signal(testdiaodu);

            }
        }
        

        
        
    });
    
    dispatch_semaphore_wait(testdiaodu, DISPATCH_TIME_FOREVER);
    
    NSLog(@"afterme");
    
    
    
}


-(void)testGCD3{
    
    /**
     *  利用dispatch queue的先进先出，确保任务一先执行，再执行任务2，再进行下面的操作
     */
    
       __block dispatch_semaphore_t sem1=dispatch_semaphore_create(0);
       __block dispatch_semaphore_t sem2=dispatch_semaphore_create(0);

    dispatch_queue_t myqueue1= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//dispatch_queue_create("s", NULL);
    
    dispatch_block_t sysytemblock1=^(){
        for (int i=0; i<10; i++) {
            NSLog(@"111111");
        }
        dispatch_semaphore_signal(sem1);
    };
    
    
    
    dispatch_block_t sysytemblock2=^{
        dispatch_semaphore_wait(sem1, DISPATCH_TIME_FOREVER);
        for (int i=0; i<10; i++) {
            NSLog(@"22222");
        }
        dispatch_semaphore_signal(sem2);
        
    };
    
    dispatch_async(myqueue1, sysytemblock1);
    dispatch_async(myqueue1, sysytemblock2);
    
    
    dispatch_semaphore_wait(sem2, DISPATCH_TIME_FOREVER);
    NSLog(@"after");
    
    
    
}




-(void)testGCD4{
    
    /**
     *  group
     */
    
    //myqueue默认是串行的，所以将如下两个block放在myqueue中执行，会先执行某一个，再执行其他。直到group中的都执行完了，才执行wait后面的代码
    dispatch_queue_t myqueue=dispatch_queue_create("", NULL);
    
    
    dispatch_group_t group=dispatch_group_create();
    
    
    dispatch_block_t block1=^{
        for (int i=0; i<10; i++) {
            NSLog(@"111111");
        }
    };
    
    dispatch_block_t block2=^{
        for (int i=0; i<10; i++) {
            NSLog(@"22222");
        }
    };
    
    dispatch_group_async(group, myqueue, block1);
    dispatch_group_async(group, myqueue, block2);
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"xxxxxx");
    
}


/**
 *  自己创建的queue，默认是串行的，系统globalqueue是并行的
 */

-(void)testGCD5{
    
    //queue中的DISPATCH_QUEUE_CONCURRENT参数代表该队列是并行行的，所以将如下两个block放在myqueue中执行，会并发执行，等最慢的那个block执行完，wait后面的代码开始执行
    
    dispatch_queue_t queue=dispatch_queue_create("ss", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_block_t block1=^{
        for (int i=0; i<10; i++) {
            NSLog(@"11111");
        }
        
    };
    
    dispatch_block_t block2=^{
        for (int i=0; i<10; i++) {
            NSLog(@"22222");
        }
        
    };
    
    dispatch_group_t group=dispatch_group_create();
    
    dispatch_group_async(group, queue, block1);
    dispatch_group_async(group, queue, block2);
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"after");
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
