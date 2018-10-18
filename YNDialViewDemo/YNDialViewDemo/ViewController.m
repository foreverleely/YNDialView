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
    
    YNDialView *dialView = [[YNDialView alloc] initWithFrame:CGRectMake(100, 200, 300, 300)];
    [self.view addSubview:dialView];
}


@end
