//
//  ViewController.m
//  LoudSpeakerDemo
//
//  Created by luowanglin on 2017/4/6.
//  Copyright © 2017年 luowanglin. All rights reserved.
//

#import "ViewController.h"
#import <AudioKit/AudioKit.h>
#import "ActionSheetPicker.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController
{
    UIButton *hf;//hour button
    UIButton *mf;//minue button
    UIButton *sf;//second button
    NSMutableArray *containerH;//hour container
    NSMutableArray *container;//other time container
    AKOscillator *oscillator;
    NSDictionary *dicHZ;
    NSMutableArray<NSString*> *keyArr;
    AKPlaygroundLoop *playLoop;
    BOOL flag;
    int count;
    CADisplayLink *playLink;
    UIButton *operateBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self elemnetLayout];//init for layout
    
    container = [NSMutableArray array];//time container for other element
    containerH = [NSMutableArray array];//time container for hour
    
    for (int i = 0; i < 24; i++) {
        [containerH addObject:[NSString stringWithFormat:@"%.2d",i]];
    }

    for (int i = 0; i < 60; i++) {
        [container addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    
    dicHZ = @{@"0":@1760.000,@"1":@1864.655,@"2":@1975.533,@"3":@2093.005,@"4":@2217.461,@"5":@2349.318,@"6":@2489.016,@"7":@2637.021,@"8":@2793.826,@"9":@2959.956,@"O":@3135.964,@"F":@3322.438,@"STX":@523.251};
    
    keyArr = [NSMutableArray arrayWithCapacity:9];
    
    oscillator = [[AKOscillator alloc] init];
    [AudioKit setOutput:oscillator];
    [AudioKit start];
   
    count = 0;//init for count falg

}


- (void)loudAction:(UIButton*)sender{
   //loud to speaker....
    if (keyArr.count == 0) {
//        [self.view makeToast:@"参数为空😅"];
        return;
    }
    count = -1;
    if (playLink) {
        [playLink invalidate];
        playLink = nil;
    }
    playLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(playLinkAction)];
    playLink.frameInterval = 0.04;//40ms
    [playLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)playLinkAction{
    
    oscillator.frequency = [dicHZ[@"STX"] doubleValue];
    printf("execute ....%i",count);
    count ++;
    if (count % 2 != 0) {
        NSLog(@"not zero...");
        return;
    }
    if (count/2 == 9) {
        [oscillator stop];
        [playLink invalidate];
        playLink = nil;
        return ;
    }
    
    oscillator.frequency = [dicHZ[keyArr[count/2]] doubleValue];
    [oscillator start];

}

//Binary transfrom......
- (NSString *)binaryTransfrom:(NSString *)valueStr{
    NSString *a = @"";
    
    long long tmpid = [valueStr longLongValue];
    while ([valueStr longLongValue])
    {
        a = [[NSString stringWithFormat:@"%lld",tmpid%2] stringByAppendingString:a];
        if (tmpid/2 < 1)
        {
            break;
        }
        tmpid = tmpid/2 ;
    }

    return a;
}

//init for layout style...
- (void)elemnetLayout{
    
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH - 120)/2, 60.f, 120.f, 120.f)];
    imgv.image = [UIImage imageNamed:@"lamp"];
    [self.view addSubview:imgv];
    
    hf = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - 296)/2, CGRectGetMaxY(imgv.frame) + 60.f, 40.f, 40.f)];
    [hf setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [hf setTitle:@"--" forState:(UIControlStateNormal)];
    hf.layer.borderColor = [UIColor grayColor].CGColor;
    hf.layer.borderWidth = 1.f;
    hf.layer.cornerRadius = 4.f;
    hf.tag = 10;
    [hf addTarget:self action:@selector(hourAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:hf];
    
    UILabel *hl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(hf.frame)+2, CGRectGetMinY(hf.frame), 20.f, 40.f)];
    hl.textAlignment = NSTextAlignmentCenter;
    hl.text = @"时";
    hl.textColor = [UIColor grayColor];
    [self.view addSubview:hl];
    
    mf = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(hl.frame)+10, CGRectGetMinY(hf.frame), 40.f, 40.f)];
    mf.layer.borderColor = [UIColor grayColor].CGColor;
    mf.layer.borderWidth = 1.f;
    mf.layer.cornerRadius = 4.f;
    mf.tag = 11;
    [mf setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [mf setTitle:@"--" forState:(UIControlStateNormal)];
    [mf addTarget:self action:@selector(hourAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:mf];
    
    UILabel *ml = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mf.frame)+2, CGRectGetMinY(hf.frame), 20.f, 40.f)];
    ml.textAlignment = NSTextAlignmentCenter;
    ml.text = @"分";
    ml.textColor = [UIColor grayColor];
    [self.view addSubview:ml];
    
    sf = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ml.frame)+10, CGRectGetMinY(hf.frame), 40.f, 40.f)];
    sf.layer.borderColor = [UIColor grayColor].CGColor;
    sf.layer.borderWidth = 1.f;
    sf.layer.cornerRadius = 4.f;
    sf.tag = 12;
    [sf setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [sf setTitle:@"--" forState:(UIControlStateNormal)];
    [sf addTarget:self action:@selector(hourAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:sf];
    
    UILabel *sl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sf.frame)+2, CGRectGetMinY(hf.frame), 20.f, 40.f)];
    sl.textAlignment = NSTextAlignmentCenter;
    sl.text = @"秒";
    sl.textColor = [UIColor grayColor];
    [self.view addSubview:sl];
    
    NSMutableAttributedString *astr = [[NSMutableAttributedString alloc]initWithString:@"开/关"];
    [astr addAttribute:NSForegroundColorAttributeName value:[[UIColor alloc] initWithHex:@"D8D821"] range:NSMakeRange(0, 1)];
    [astr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(1, 1)];
    [astr addAttribute:NSForegroundColorAttributeName value:[[UIColor alloc] initWithHex:@"32C99A"] range:NSMakeRange(2, 1)];
    
    operateBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    operateBtn.frame = CGRectMake(CGRectGetMaxX(sl.frame)+10, CGRectGetMinY(hf.frame), 80.f, 40.f);
    operateBtn.layer.borderColor = [UIColor grayColor].CGColor;
    operateBtn.layer.borderWidth = 1.f;
    operateBtn.layer.cornerRadius = 4.f;
    [operateBtn setAttributedTitle:astr forState:(UIControlStateNormal)];
    [operateBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [operateBtn addTarget:self action:@selector(hourAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:operateBtn];
    
    UIButton *loudBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    loudBtn.frame = CGRectMake((WIDTH - 80)/2, CGRectGetMaxY(hf.frame) + 60.f, 80.f, 40.f);
    [loudBtn setTitle:@"下发" forState:(UIControlStateNormal)];
    loudBtn.layer.borderWidth = 1.f;
    loudBtn.layer.cornerRadius = 4.f;
    loudBtn.layer.borderColor = [[UIColor alloc] initWithHex:@"32C99A"].CGColor;
    [loudBtn setTitleColor:[[UIColor alloc] initWithHex:@"32C99A"] forState:(UIControlStateNormal)];
    [loudBtn addTarget:self action:@selector(loudAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:loudBtn];
    
    UITextView *tv = [UITextView new];
    tv.text = @"  APP端流程如下：产生40ms的STX，静默40ms，产生40ms的1，静默40ms，依次类推，直到产生40ms校验值，结束.";
    tv.textAlignment = NSTextAlignmentJustified;
    tv.textColor = [UIColor grayColor];
    tv.frame = CGRectMake(0, 0, WIDTH - 60.f, 60.f);
    tv.center = CGPointMake(WIDTH / 2, HEIGHT - 40.f);
    [self.view addSubview:tv];
}

- (void)hourAction:(UIButton*)sender{
    NSArray *opretions = @[@"O",@"F"];
    
    [ActionSheetMultipleStringPicker showPickerWithTitle:@"时间选择" rows:@[containerH,container,container,opretions] initialSelection:@[@0,@0,@0,@1] doneBlock:^(ActionSheetMultipleStringPicker *picker, NSArray *selectedIndexes, id selectedValues) {
        NSLog(@"selectedIndexes:%@",selectedIndexes);
        NSLog(@"selectedvalues:%@",selectedValues);
        [hf setTitle:selectedValues[0] forState:(UIControlStateNormal)];
        [mf setTitle:selectedValues[1] forState:(UIControlStateNormal)];
        [sf setTitle:selectedValues[2] forState:(UIControlStateNormal)];
        if (keyArr) {
            [keyArr removeAllObjects];
        }else{
            keyArr = [NSMutableArray array];
        }
        [keyArr addObject:@"STX"];
        for (int i = 0; i < selectedIndexes.count; i++) {
            if (i < 3) {
                NSString *numStr = [(NSString*)selectedValues[i] substringWithRange:NSMakeRange(0, 1)];
                [keyArr addObject:numStr];
                NSString *numStr1 = [(NSString*)selectedValues[i] substringWithRange:NSMakeRange(1, 1)];
                [keyArr addObject:numStr1];
            }else{
                NSString *contStr = (NSString*)selectedValues[i];
                [keyArr addObject:contStr];
                
                NSMutableAttributedString *astr = [[NSMutableAttributedString alloc]initWithString:@"开/关"];
                if ([contStr isEqualToString:@"O"]) {
                    [astr addAttribute:NSForegroundColorAttributeName value:[[UIColor alloc] initWithHex:@"32C99A"] range:NSMakeRange(0, 1)];
                    [astr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(1, 1)];
                    [astr addAttribute:NSForegroundColorAttributeName value:[[UIColor alloc] initWithHex:@"D8D821"] range:NSMakeRange(2, 1)];
                }else{
                    [astr addAttribute:NSForegroundColorAttributeName value:[[UIColor alloc] initWithHex:@"D8D821"] range:NSMakeRange(0, 1)];
                    [astr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(1, 1)];
                    [astr addAttribute:NSForegroundColorAttributeName value:[[UIColor alloc] initWithHex:@"32C99A"] range:NSMakeRange(2, 1)];
                }
                [operateBtn setAttributedTitle:astr forState:(UIControlStateNormal)];
            }
        }
        [keyArr addObject:[self sumAndModulo:keyArr]];
        NSLog(@"key array -->%@",keyArr);
    } cancelBlock:^(ActionSheetMultipleStringPicker *picker) {
        
    } origin:sender];
    
}

- (NSString*)sumAndModulo:(NSArray<NSString*> *)dataArr{
    int sum = 0;
    int resultNum = 0;
    for (int i = 1; i < dataArr.count-1; i++) {
        sum += [dataArr[i] intValue];
    }
    while (sum != 0) {
        resultNum += sum%10;
        sum /= 10;
    }
    NSLog(@"resultNum--%i",resultNum);
    return [NSString stringWithFormat:@"%i",resultNum];
}


@end












