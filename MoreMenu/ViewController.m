//
//  ViewController.m
//  MoreMenu
//
//  Created by 123 on 16/4/26.
//  Copyright © 2016年 asura. All rights reserved.
//

#import "ViewController.h"
#import "MoreMenuView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *titles = @[@"电影",@"全城",@"好评优先",@"特价"];
    MoreMenuView *menuView = [[MoreMenuView alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 60) titles:titles];
    menuView.cornerMarkLocationType = CornerMarkLocationTypeRight;
    
    NSMutableArray *array  =[NSMutableArray array];
    for (int i = 0; i < 10; i ++) {
        [array addObject:[NSString stringWithFormat:@"%d",i]];
    };
    menuView.indexsOneFist = array;

    menuView.indexsOneSecond = @[@[@"sd",@"add",@"qrfqe",@"gr",@"dfht",@"qfw",@"wtrt",@"teryt",@"wetry",@"eyyt"],@[@"sfd",@"add",@"qrsaffqe",@"sadgr",@"dfhast",@"qfadsdw",@"wtrt",@"tcxeryt",@"wetry",@"eyyt"],@[@"sddd",@"add",@"qrfczqe",@"gr",@"dfhzcxt",@"qfw",@"wtrt",@"teryt",@"wczxetry",@"eyyt"]
                                 ,@[@"ssdad",@"add",@"qrfqe",@"gr",@"ewrdfht",@"qfw",@"wtrt",@"teryt",@"wetry",@"eyyt"]
                                 ,@[@"srgd",@"add",@"qrfqcze",@"gr",@"dfht",@"qf66w",@"wtrt",@"teryt",@"wetrczy",@"eyyt"]
                                 ,@[@"sd",@"add",@"qrfqe",@"gr",@"dfc23zht",@"qfw",@"q54wtrt",@"t54eryt",@"wetry",@"eyyt"]
                                 ,@[@"s234d",@"add",@"qrfczqe",@"afagr",@"dfht",@"qfw",@"wtrt",@"teryt",@"wetry",@"eyyt"]
                                 ,@[@"sdaf",@"add",@"qrfqe",@"gr",@"dfht",@"qfw",@"wt23rt",@"teryt",@"wetry",@"eyyqrqt"]
                                 ,@[@"s57d",@"add",@"qrfqe",@"gr",@"dfht",@"qfw",@"wtrt32",@"teryt",@"wetry",@"eyyt"]
                                 ,@[@"serwed",@"add",@"qrfafsqe",@"gr",@"dfht",@"qfw",@"wtrt",@"t436eryt",@"wetry",@"eyyt"]
                                 ,@[@"s6487d",@"add",@"qrfqe",@"gr",@"dfhvfrt",@"qfw",@"w2trt",@"teryt",@"wetry",@"eyyt"]];
    menuView.indexsTwoFist = menuView.indexsOneFist;
    menuView.indexsThirFist = menuView.indexsOneFist;
    menuView.indexsThirSecond = menuView.indexsOneSecond;

    [self.view addSubview:menuView];
    menuView.selectedIndex = ^(NSString *string){
        NSLog(@"得到的数据为:%@",string);
    };
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end