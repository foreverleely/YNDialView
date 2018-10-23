//
//  ViewController.m
//  YNDialViewDemo
//
//  Created by liyangly on 2018/10/18.
//  Copyright © 2018 liyang. All rights reserved.
//

#import "ViewController.h"
// view
#import "YNDialView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    YNDialView *dialView = [[YNDialView alloc] initWithFrame:CGRectMake((375 - 600)/2, 600, 600, 600)];
    [self.view addSubview:dialView];
    
    YNDialView *dialView2 = [[YNDialView alloc] initWithFrame:CGRectMake((375 - 600)/2, -400, 600, 600) radius:300 btnWidth:20];
    [self.view addSubview:dialView2];
}


@end
