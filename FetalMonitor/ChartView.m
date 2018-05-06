#import "ChartView.h"
#import "SVProgressHUD.h"
#import "UIColor16.h"

@implementation ChartView
{
    CGPoint updateOpt1;
    CGPoint updateOpt2;
    NSMutableArray *_heartArr;
    NSMutableArray *_pressArr;
    NSMutableArray *_moveArr;
    int arrayNum;
    int addPointCount;
    int page;
    float perPointValue;
    
    NSUserDefaults *defaults;
    NSTimeInterval perMin;
    
    float perRowHeight;
    CGSize viewBoundSize;
    
    UIBezierPath *heartPath;
    UIBezierPath *pressPath;
    UIBezierPath *movePath;
    UIBezierPath *heartYPath;
    UIBezierPath *heartY2Path;
    UIBezierPath *heartY3Path;
    UIBezierPath *heartXPath;
    UIBezierPath *heartX2Path;
    UIBezierPath *pressYPath;
    UIBezierPath *pressY2Path;
    UIBezierPath *pressY3Path;
    UIBezierPath *pressXPath;
    UIBezierPath *pressX2Path;
    
    //绘图模式
    int drawMode;  //0:不分页   1:分页
    
    int _showPage;
    
    int cellCount;
    int fhrCellCount;
    int tocoCellCount;
    int maxFhr;
    int minFhr;
    int maxToco;
    int minToco;
    int abscissaHeight;
}

-(id)initWithFrame:(CGRect)frame andBottomHeight:(int)height{
    self = [super initWithFrame:frame];
    if (self) {
        
        viewBoundSize = self.frame.size;

        fhrCellCount = 15;
        tocoCellCount = 10;
        cellCount = fhrCellCount + tocoCellCount;
        maxFhr = 210;
        minFhr = 60;
        maxToco = 100;
        minToco = 0;
        abscissaHeight = 30;
        
        perRowHeight = (viewBoundSize.height - abscissaHeight) / cellCount;
        
        //self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor whiteColor];
        _heartArr = [NSMutableArray array];
        _pressArr = [NSMutableArray array];
        _moveArr = [NSMutableArray array];
        
        _sizePerMin = 64;
        page = 1;
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        perMin = 60;
        
    }
    
    return self;
}

//胎心基线Y(分页)
-(void)drawPageBaseY:(int)showPage{
    
    CGFloat sizePerSec = _sizePerMin / 60;
    CGFloat secPerScreen = self.frame.size.width / sizePerSec;
    
    CGFloat beginSec = secPerScreen * showPage;
    CGFloat endSec = beginSec + secPerScreen;
    
    //每分钟实线
    UIBezierPath *baseY = [[UIBezierPath alloc] init];
    [[UIColor blackColor] set];
    [baseY setLineWidth:0.2];
    
    for (int i = (int)beginSec + 1; i <= (int)endSec; i++) {
        if (i % 60 == 0) {
            CGFloat pointx = (i - beginSec) * sizePerSec;
            [baseY moveToPoint:CGPointMake(pointx, 0)];
            [baseY addLineToPoint:CGPointMake(pointx, fhrCellCount * perRowHeight)];
        }
    }
    [baseY stroke];
    
    //每厘米虚线
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *minValue = [userDefault objectForKey:@"speed"];
    int x = 0;
    switch (minValue.intValue) {
        case 1:
            x = 65535;
            break;
        case 2:
            x = 30;
            break;
        case 3:
            x = 20;
            break;
        default:
            break;
    }
    
    UIBezierPath *baseY_2 = [[UIBezierPath alloc] init];
    [[UIColor blackColor] set];
    [baseY_2 setLineWidth:0.2];
    
    for (int i = (int)beginSec + 1; i <= (int)endSec; i++) {
        if (i % x == 0 && i % 60 != 0) {
            CGFloat pointx = (i - beginSec) * sizePerSec;
            CGFloat lengths[] = {5,5};
            [baseY_2 setLineDash:lengths count:2 phase:2];
            [baseY_2 moveToPoint:CGPointMake(pointx, 0)];
            [baseY_2 addLineToPoint:CGPointMake(pointx, fhrCellCount * perRowHeight)];
        }
    }
    
    [baseY_2 stroke];

}


//胎心基线Y
-(void)drawBaseY{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *minValue = [userDefault objectForKey:@"speed"];
    
    UIBezierPath *baseY = [[UIBezierPath alloc] init];
    [[UIColor blackColor] set];
    [baseY setLineWidth:0.3];
    
    NSLog(@"heartY");
    
    for (int i = 0; i < self.frame.size.width / _sizePerMin + 2; i++) {
        [baseY moveToPoint:CGPointMake((i+1)*_sizePerMin, 0)];
        [baseY addLineToPoint:CGPointMake((i+1)*_sizePerMin, fhrCellCount * perRowHeight)];
    }
    
    [baseY stroke];
        
    UIBezierPath *baseY_2 = [[UIBezierPath alloc] init];
    [[UIColor blackColor] set];
    [baseY_2 setLineWidth:0.2];
    
    for (int i = 0; i < self.frame.size.width / 64 + 2; i++) {
        if ((i+1) % minValue.intValue != 0) {
            CGFloat lengths[] = {5,5};
            [baseY_2 setLineDash:lengths count:2 phase:2];
            [baseY_2 moveToPoint:CGPointMake((i+1)*64, 0)];
            [baseY_2 addLineToPoint:CGPointMake((i+1)*64, fhrCellCount * perRowHeight)];
        }
        
    }
    
    [baseY_2 stroke];
    
    UIBezierPath *baseY_3 = [[UIBezierPath alloc] init];
    [[UIColor colorWithWhite:0 alpha:0.5] set];
    [baseY_3 setLineWidth:0.1];
    float minCount = self.frame.size.width / (64 * minValue.intValue) + 2;
    float perSep = 64.0 * minValue.floatValue / 6.0;
    for (int i = 0; i < minCount * 6; i++) {
        CGFloat lengths[] = {5,5};
        [baseY_3 setLineDash:lengths count:2 phase:2];
        [baseY_3 moveToPoint:CGPointMake(((float)i+1.0)*perSep, 0)];
        [baseY_3 addLineToPoint:CGPointMake(((float)i+1.0)*perSep, fhrCellCount * perRowHeight)];
    }
    
    [baseY_3 stroke];
}


// 绘制toco纵坐标（分页）
-(void)showPageCoordinate
{
    CGFloat sizePerSec = _sizePerMin / 60;
    CGFloat secPerScreen = self.frame.size.width / sizePerSec;
    
    CGFloat beginSec = secPerScreen * _showPage;
    CGFloat endSec = beginSec + secPerScreen;
    
    NSMutableParagraphStyle *paragStyle = [[NSMutableParagraphStyle alloc] init];
    paragStyle.alignment = NSTextAlignmentCenter;
    
    for (int i = (int)beginSec + 1; i <= (int)endSec; i++)
    {
        if (i % 60 == 0)
        {
            CGFloat pointx = (i - beginSec) * sizePerSec;
            int n = maxFhr;
            for(int j = 0; j < fhrCellCount; j+=3)
            {
                NSString *xValue = [[NSString alloc] initWithFormat:@"%d",n];
                [xValue drawInRect:CGRectMake(pointx, j * perRowHeight, 22, 10) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:7],NSForegroundColorAttributeName:[UIColor blackColor],NSParagraphStyleAttributeName:paragStyle}];
                
                n -= 30;
            }
        }
    }
 
    for (int i = (int)beginSec + 1; i <= (int)endSec; i++)
    {
        if (i % 60 == 0)
        {
            CGFloat pointx = (i - beginSec) * sizePerSec;
            int n = maxToco;
            for(int j = 0; j <= tocoCellCount; j+=2)
            {
                NSString *xValue = [[NSString alloc] initWithFormat:@"%d",n];
                [xValue drawInRect:CGRectMake(pointx, perRowHeight * fhrCellCount + abscissaHeight + perRowHeight * j, 22, 10) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:7],NSForegroundColorAttributeName:[UIColor blackColor],NSParagraphStyleAttributeName:paragStyle}];
                
                n -= 20;
            }
        }
    }
}

//胎心基线X（分页）
-(void)drawPageBaseX:(int)showPage{
    
    CGFloat sizePerSec = _sizePerMin / 60;
    CGFloat secPerScreen = self.frame.size.width / sizePerSec;
    
    CGFloat beginSec = secPerScreen * showPage;
    CGFloat endSec = beginSec + secPerScreen;
    
    NSMutableParagraphStyle *paragStyle = [[NSMutableParagraphStyle alloc] init];
    paragStyle.alignment = NSTextAlignmentLeft;
    
    NSString *timeFlag = [defaults objectForKey:@"time"];
    NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"createTime"];
    if (!beginTime) {
        beginTime = [NSDate date];
    }
    
    if ([timeFlag isEqualToString:@"abs"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        for (int i = (int)beginSec + 1; i <= (int)endSec; i++) {
            if (i % 60 == 0) {
                CGFloat pointx = (i - beginSec) * sizePerSec;
                NSDate *xTime = [beginTime dateByAddingTimeInterval:i];
                NSString *xTimeStr = [formatter stringFromDate:xTime];
                [xTimeStr drawInRect:CGRectMake(pointx, fhrCellCount * perRowHeight + 7.5, 55, 10) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:7],NSForegroundColorAttributeName:[UIColor blackColor],NSParagraphStyleAttributeName:paragStyle}];
            }
        }
        
    }else{
        for (int i = (int)beginSec + 1; i <= (int)endSec; i++) {
            if (i % 60 == 0) {
                CGFloat pointx = (i - beginSec) * sizePerSec;
                NSString *xValue = [[NSString alloc] initWithFormat:@"%d%@",i/60,@"'"];
                [xValue drawInRect:CGRectMake(pointx, fhrCellCount * perRowHeight + 7.5, 22, 10) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:7],NSForegroundColorAttributeName:[UIColor blackColor],NSParagraphStyleAttributeName:paragStyle}];
            }
            
        }
    }
    
    
    UIBezierPath *baseX = [[UIBezierPath alloc] init];
    [[UIColor blackColor] set];
    [baseX setLineWidth:0.2];
    
    NSLog(@"heartX");
    
    for (int i=0; i<fhrCellCount / 3 + 1; i++) {
        [baseX moveToPoint:CGPointMake(0, perRowHeight * 3 * i)];
        [baseX addLineToPoint:CGPointMake(self.frame.size.width, perRowHeight * 3 * i)];
    }
    
    [baseX stroke];
    
    UIBezierPath *baseX_2 = [[UIBezierPath alloc] init];
    [[UIColor colorWithWhite:0 alpha:0.5] set];
    [baseX_2 setLineWidth:0.1];
    
    for (int i=0; i<fhrCellCount + 1; i++) {
        if (i % 3 != 0) {
            [baseX_2 moveToPoint:CGPointMake(0, perRowHeight * i)];
            [baseX_2 addLineToPoint:CGPointMake(self.frame.size.width, perRowHeight * i)];
        }
        
    }
    
    [baseX_2 stroke];
    
}

//胎心基线X
-(void)drawBaseX{
    
    NSMutableParagraphStyle *paragStyle = [[NSMutableParagraphStyle alloc] init];
    paragStyle.alignment = NSTextAlignmentLeft;
    
    NSString *timeFlag = [defaults objectForKey:@"time"];
    NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"createTime"];
    if (!beginTime) {
        beginTime = [NSDate date];
    }
    
    if ([timeFlag isEqualToString:@"abs"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        for (int i = 0; i < self.frame.size.width / _sizePerMin + 3; i++) {
            NSDate *xTime = [beginTime dateByAddingTimeInterval:perMin*i];
            NSString *xTimeStr = [formatter stringFromDate:xTime];
            [xTimeStr drawInRect:CGRectMake(i*_sizePerMin, fhrCellCount * perRowHeight + 7.5, 55, 10) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:7],NSForegroundColorAttributeName:[UIColor blackColor],NSParagraphStyleAttributeName:paragStyle}];
        }
        
    }else{
        for (int i = 0; i < self.frame.size.width / _sizePerMin + 3; i++) {
            NSString *xValue = [[NSString alloc] initWithFormat:@"%d%@",i,@"'"];
            [xValue drawInRect:CGRectMake(i*_sizePerMin, fhrCellCount * perRowHeight + 7.5, 22, 10) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:7],NSForegroundColorAttributeName:[UIColor blackColor],NSParagraphStyleAttributeName:paragStyle}];
        }
    }
    
    UIBezierPath *baseX = [[UIBezierPath alloc] init];
    [[UIColor blackColor] set];
    [baseX setLineWidth:0.3];
    
    NSLog(@"heartX");
    
    for (int i=0; i<fhrCellCount / 3 + 1; i++) {
        [baseX moveToPoint:CGPointMake(0, perRowHeight * 3 * i)];
        [baseX addLineToPoint:CGPointMake(self.frame.size.width, perRowHeight * 3 * i)];
    }
    
    [baseX stroke];
        
    UIBezierPath *baseX_2 = [[UIBezierPath alloc] init];
    [[UIColor colorWithWhite:0 alpha:0.5] set];
    [baseX_2 setLineWidth:0.1];
    
    for (int i=0; i<fhrCellCount + 1; i++) {
        if (i % 3 != 0) {
            [baseX_2 moveToPoint:CGPointMake(0, perRowHeight * i)];
            [baseX_2 addLineToPoint:CGPointMake(self.frame.size.width, perRowHeight * i)];
        }
    }
    
    [baseX_2 stroke];
    
}

//宫缩基线Y（分页）
-(void)drawPageSecY:(int)showPage{
    
    CGFloat sizePerSec = _sizePerMin / 60;
    CGFloat secPerScreen = self.frame.size.width / sizePerSec;
    
    CGFloat beginSec = secPerScreen * showPage;
    CGFloat endSec = beginSec + secPerScreen;
    
    //每分钟实线
    UIBezierPath *baseY = [[UIBezierPath alloc] init];
    [[UIColor blackColor] set];
    [baseY setLineWidth:0.2];
    
    for (int i = (int)beginSec + 1; i <= (int)endSec; i++) {
        if (i % 60 == 0) {
            CGFloat pointx = (i - beginSec) * sizePerSec;
            [baseY moveToPoint:CGPointMake(pointx, perRowHeight * fhrCellCount + abscissaHeight)];
            [baseY addLineToPoint:CGPointMake(pointx, perRowHeight * fhrCellCount + abscissaHeight + perRowHeight * 10)];
        }
        
    }
    
    [baseY stroke];
    
    
    //每厘米虚线
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *minValue = [userDefault objectForKey:@"speed"];
    int x = 0;
    switch (minValue.intValue) {
        case 1:
            x = 65535;
            break;
        case 2:
            x = 30;
            break;
        case 3:
            x = 20;
            break;
        default:
            break;
    }
    
    UIBezierPath *baseY_2 = [[UIBezierPath alloc] init];
    [[UIColor blackColor] set];
    [baseY_2 setLineWidth:0.2];
    for (int i = (int)beginSec + 1; i <= (int)endSec; i++) {
        if (i % x == 0 && i % 60 != 0) {
            CGFloat pointx = (i - beginSec) * sizePerSec;
            CGFloat lengths[] = {5,5};
            [baseY_2 setLineDash:lengths count:2 phase:2];
            [baseY_2 moveToPoint:CGPointMake(pointx, perRowHeight * fhrCellCount + abscissaHeight)];
            [baseY_2 addLineToPoint:CGPointMake(pointx, perRowHeight * fhrCellCount + abscissaHeight + perRowHeight * tocoCellCount)];
        }
    }
    
    [baseY_2 stroke];
    
}


//宫缩基线Y
-(void)drawSecY{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *minValue = [userDefault objectForKey:@"speed"];
    
    UIBezierPath *baseY = [[UIBezierPath alloc] init];
    [[UIColor blackColor] set];
    [baseY setLineWidth:0.3];
    
    for (int i=0; i < self.frame.size.width / _sizePerMin + 3; i++) {
        [baseY moveToPoint:CGPointMake((i+1)*_sizePerMin, perRowHeight * fhrCellCount + abscissaHeight)];
        [baseY addLineToPoint:CGPointMake((i+1)*_sizePerMin, perRowHeight * fhrCellCount + abscissaHeight + perRowHeight * tocoCellCount)];
    }
    
    [baseY stroke];
    
    UIBezierPath *baseY_2 = [[UIBezierPath alloc] init];
    [[UIColor blackColor] set];
    [baseY_2 setLineWidth:0.2];
    for (int i = 0; i < self.frame.size.width / 64 + 2; i++) {
        if ((i+1) % minValue.intValue != 0) {
            CGFloat lengths[] = {5,5};
            [baseY_2 setLineDash:lengths count:2 phase:2];
            [baseY_2 moveToPoint:CGPointMake((i+1)*64, perRowHeight * fhrCellCount + abscissaHeight)];
            [baseY_2 addLineToPoint:CGPointMake((i+1)*64, perRowHeight * fhrCellCount + abscissaHeight + perRowHeight * tocoCellCount)];
        }
    }
    
    [baseY_2 stroke];
    
    
    UIBezierPath *baseY_3 = [[UIBezierPath alloc] init];
    [[UIColor colorWithWhite:0 alpha:0.5] set];
    [baseY_3 setLineWidth:0.1];
    float minCount = self.frame.size.width / (64 * minValue.intValue) + 2;
    float perSep = 64.0 * minValue.floatValue / 6.0;
    for (int i = 0; i < minCount * 6; i++) {
        CGFloat lengths[] = {5,5};
        [baseY_3 setLineDash:lengths count:2 phase:2];
        [baseY_3 moveToPoint:CGPointMake(((float)i+1.0)*perSep, perRowHeight * fhrCellCount + abscissaHeight)];
        [baseY_3 addLineToPoint:CGPointMake(((float)i+1.0)*perSep, perRowHeight * fhrCellCount + abscissaHeight + perRowHeight * tocoCellCount)];
    }
    
    [baseY_3 stroke];
    
}

//宫缩基线X（分页）
-(void)drawPageSecX:(int)showPage
{
    UIBezierPath *baseX = [[UIBezierPath alloc] init];
    [[UIColor blackColor] set];
    [baseX setLineWidth:0.2];
    
    for (int i=0; i < 6; i++)
    {
        [baseX moveToPoint:CGPointMake(0, perRowHeight * fhrCellCount + abscissaHeight + perRowHeight * 2 * i)];
        [baseX addLineToPoint:CGPointMake(self.frame.size.width, perRowHeight * fhrCellCount + abscissaHeight + perRowHeight * 2 * i)];
    }
    
    [baseX stroke];
    
    UIBezierPath *baseX_2 = [[UIBezierPath alloc] init];
    [[UIColor colorWithWhite:0 alpha:0.5] set];
    [baseX_2 setLineWidth:0.1];
    
    for (int i=0; i<11; i++)
    {
        if (i % 2 != 0)
        {
            [baseX_2 moveToPoint:CGPointMake(0, perRowHeight * fhrCellCount + abscissaHeight + perRowHeight * i)];
            [baseX_2 addLineToPoint:CGPointMake(self.frame.size.width, perRowHeight * fhrCellCount + abscissaHeight + perRowHeight * i)];
        }
    }
    
    [baseX_2 stroke];
}

//宫缩基线X
-(void)drawSecX{
    
    UIBezierPath *baseX = [[UIBezierPath alloc] init];
    [[UIColor blackColor] set];
    [baseX setLineWidth:0.3];
    
    for (int i=0; i<6; i++) {
        [baseX moveToPoint:CGPointMake(0, perRowHeight * fhrCellCount + abscissaHeight + perRowHeight * 2 * i)];
        [baseX addLineToPoint:CGPointMake(self.frame.size.width, perRowHeight * fhrCellCount + abscissaHeight + perRowHeight * 2 * i)];
    }
    
    [baseX stroke];
        
    UIBezierPath *baseX_2 = [[UIBezierPath alloc] init];
    [[UIColor colorWithWhite:0 alpha:0.5] set];
    [baseX_2 setLineWidth:0.1];
    
    for (int i=0; i<11; i++) {
        if (i % 2 != 0) {
            [baseX_2 moveToPoint:CGPointMake(0, perRowHeight * fhrCellCount + abscissaHeight + perRowHeight * i)];
            [baseX_2 addLineToPoint:CGPointMake(self.frame.size.width, perRowHeight * fhrCellCount + abscissaHeight + perRowHeight * i)];
        }
        
    }
        
    [baseX_2 stroke];
    
}

//画胎心(分页)
-(void)drawPageHeartBeat:(int)showPage{
    CGFloat sizePerSec = _sizePerMin / 60;
    CGFloat secPerScreen = self.frame.size.width / sizePerSec;
    
    CGFloat beginSec = secPerScreen * showPage;
    CGFloat endSec = beginSec + secPerScreen;
    
    NSMutableArray *subArr = [NSMutableArray array];
    
    NSArray *tmpArray = [NSArray arrayWithArray:_heartArr];
    
    for (NSDictionary *dic in tmpArray) {
        NSNumber *valueX = [[dic allKeys] firstObject];
        if (valueX.floatValue / _rate >= beginSec && valueX.floatValue / _rate <= endSec) {
            [subArr addObject:dic];
        }
    }
    
    NSDictionary *firstPointDic = [subArr firstObject];
    CGPoint firstPoint = [self transDataBypage:showPage andPointDic:firstPointDic andMode:0];
    
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    //            [[UIColor blackColor] set];
    [linePath setLineWidth:1];
    
    [linePath moveToPoint:firstPoint];
    
    if (subArr.count > 0) {
        
        BOOL isLastPaint = YES;
        for (int i=0; i<subArr.count; i++) {
            NSDictionary *pointDic = subArr[i];
            CGPoint point = [self transDataBypage:showPage andPointDic:pointDic andMode:0];
            BOOL isPaint = YES;
            if (i>0) {
                //小于30的点不绘制
                if (point.y > fhrCellCount * perRowHeight) {
                    isPaint = NO;
                }
                
                //两个点之间大于30，第二个点不绘制
                NSDictionary *frontOptDic = subArr[i-1];
                CGPoint frontOpt = [self transDataBypage:showPage andPointDic:frontOptDic andMode:0];
                if (abs(frontOpt.y - point.y) > 30 * (perRowHeight / 10)){
                    isPaint = NO;
                }
                
                //大于等于240的点绘制在240上
                if (point.y<0) {
                    point = CGPointMake(point.x, 0);
                }
                
                
                if (point.x - frontOpt.x > 5) {
                    isLastPaint = NO;
                }
                
                if (isPaint) {
                    if (isLastPaint) {
                        [self insertMorePointFromFrontPoint:frontOpt andCurrPoint:point andPath:linePath];
                        [linePath addLineToPoint:point];
                    }else{
                        [linePath moveToPoint:point];
                    }
                    isLastPaint = YES;
                }else{
                    isLastPaint = NO;
                }
                
            }
            
        }
        
        //                [linePath stroke];
        heartPath = linePath;
    }

    
}

//画胎心
-(void)drawHeartBeat{
    
    
    NSDictionary *firstPointDic = [_heartArr firstObject];
    CGPoint firstPoint = [self transData:firstPointDic andMode:0];
    
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    [[UIColor16 colorWithHexString:@"#0078ff"] set];
    [linePath setLineWidth:1];
    
    [linePath moveToPoint:firstPoint];
    
    if (_heartArr.count > 0) {
        
        BOOL isLastPaint = YES;
        for (int i=0; i<_heartArr.count; i++) {
            NSDictionary *pointDic = _heartArr[i];
            CGPoint point = [self transData:pointDic andMode:0];
            BOOL isPaint = YES;
            if (i>0) {
                //小于30的点不绘制
                if (point.y > fhrCellCount * perRowHeight) {
                    isPaint = NO;
                }
                
                //两个点之间大于30，第二个点不绘制
                NSDictionary *frontOptDic = _heartArr[i-1];
                CGPoint frontOpt = [self transData:frontOptDic andMode:0];
                if (abs(frontOpt.y - point.y) > 30 * (perRowHeight / 10)){
                    isPaint = NO;
                }
                
                //大于等于240的点绘制在240上
                if (point.y<0) {
                    point = CGPointMake(point.x, 0);
                }
                
                
                if (point.x - frontOpt.x > 5) {
                    isLastPaint = NO;
                }
                
                if (isPaint) {
                    if (isLastPaint) {
                        [self insertMorePointFromFrontPoint:frontOpt andCurrPoint:point andPath:linePath];
                        [linePath addLineToPoint:point];
                    }else{
                        [linePath moveToPoint:point];
                    }
                    isLastPaint = YES;
                }else{
                    isLastPaint = NO;
                }
                
            }
            
        }
        
        [linePath stroke];
        
    }
}

//画宫缩（分页）
-(void)drawPressByPage:(int)showPage{
    CGFloat sizePerSec = _sizePerMin / 60;
    CGFloat secPerScreen = self.frame.size.width / sizePerSec;
    
    CGFloat beginSec = secPerScreen * showPage;
    CGFloat endSec = beginSec + secPerScreen;
    
    NSMutableArray *subArr = [NSMutableArray array];
    
    NSArray *tmpArray = [NSArray arrayWithArray:_pressArr];
    
    for (NSDictionary *dic in tmpArray) {
        NSNumber *valueX = [[dic allKeys] firstObject];
        if (valueX.floatValue / _rate >= beginSec && valueX.floatValue / _rate <= endSec) {
            [subArr addObject:dic];
        }
    }
    
    if (subArr.count > 0) {
        
        NSDictionary *firstPointDir = subArr[0];
        //    CGPoint firstPoint = CGPointMake(0, 31 * perRowHeight + 23.5);
        CGPoint firstPoint = [self transDataBypage:showPage andPointDic:firstPointDir andMode:1];
        
        UIBezierPath *linePath = [[UIBezierPath alloc] init];
        //                [[UIColor blackColor] set];
        [linePath setLineWidth:1];
        [linePath moveToPoint:firstPoint];
        
        BOOL isPaint = YES;
        
        for (int i=0; i<subArr.count; i++) {
            if (i>0) {
                NSDictionary *frontOptDic = subArr[i-1];
                CGPoint frontOpt = [self transDataBypage:showPage andPointDic:frontOptDic andMode:1];
                
                NSDictionary *pointDic = subArr[i];
                CGPoint point = [self transDataBypage:showPage andPointDic:pointDic andMode:1];
                
                if (point.x - frontOpt.x > 5) {
                    isPaint = NO;
                }
                
                if (isPaint) {
                    [self insertMorePointFromFrontPoint:frontOpt andCurrPoint:point andPath:linePath];
                    [linePath addLineToPoint:point];
                }else{
                    [linePath moveToPoint:point];
                    isPaint = YES;
                }
            }
        }
        
        //                [linePath stroke];
        pressPath = linePath;
        
    }
    
    
}


//画宫缩
-(void)drawPress
{
    if (_pressArr.count > 0)
    {
        NSDictionary *firstPointDir = _pressArr[0];
        //    CGPoint firstPoint = CGPointMake(0, 31 * perRowHeight + 23.5);
        CGPoint firstPoint = [self transData:firstPointDir andMode:1];
        
        UIBezierPath *linePath = [[UIBezierPath alloc] init];
        [[UIColor16 colorWithHexString:@"#5a6089"] set];
        [linePath setLineWidth:1];
        [linePath moveToPoint:firstPoint];
        
        BOOL isPaint = YES;
        
        for (int i=0; i<_pressArr.count; i++) {
            if (i>0) {
                NSDictionary *frontOptDic = _pressArr[i-1];
                CGPoint frontOpt = [self transData:frontOptDic andMode:1];
                
                NSDictionary *pointDic = _pressArr[i];
                CGPoint point = [self transData:pointDic andMode:1];
                
                if (point.x - frontOpt.x > 5) {
                    isPaint = NO;
                }
                
                if (isPaint) {
                    [self insertMorePointFromFrontPoint:frontOpt andCurrPoint:point andPath:linePath];
                    [linePath addLineToPoint:point];
                }else{
                    [linePath moveToPoint:point];
                    isPaint = YES;
                }
            }
        }
    
        [linePath stroke];
    }
    
    
}

//画胎动(分页)
-(void)drawMoveByPage:(int)showPage{
    
    CGFloat sizePerSec = _sizePerMin / 60;
    CGFloat secPerScreen = self.frame.size.width / sizePerSec;
    
    CGFloat beginSec = secPerScreen * showPage;
    CGFloat endSec = beginSec + secPerScreen;
    
    NSMutableArray *subArr = [NSMutableArray array];
    
    NSArray *tmpArray = [NSArray arrayWithArray:_moveArr];
    
    for (NSDictionary *dic in tmpArray) {
        NSNumber *valueX = [[dic allKeys] firstObject];
        if (valueX.floatValue / _rate >= beginSec && valueX.floatValue / _rate <= endSec) {
            [subArr addObject:dic];
        }
    }
    
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    //            [[UIColor redColor] set];
    
    [linePath setLineWidth:1];
    
    if (subArr.count > 0) {
        
        for (int i=0; i<subArr.count; i++) {
            NSDictionary *pointDic = subArr[i];
            NSNumber *valueX = [[pointDic allKeys] firstObject];
            NSNumber *valueY = [[pointDic allValues] firstObject];
            if (valueY.intValue > 0) {
                [linePath moveToPoint:CGPointMake((valueX.floatValue / _rate - beginSec) * sizePerSec, fhrCellCount * perRowHeight - 5)];
                [linePath addLineToPoint:CGPointMake((valueX.floatValue / _rate - beginSec) * sizePerSec, fhrCellCount * perRowHeight)];
            }
        }
        
        //                [linePath stroke];
        movePath = linePath;
    }
    
    
    
}

//画胎动
-(void)drawMove{
    
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    [[UIColor redColor] set];
    
    [linePath setLineWidth:1];
    
    if (_moveArr.count > 0) {
        
        for (int i=0; i<_moveArr.count; i++) {
            NSDictionary *pointDic = _moveArr[i];
            NSNumber *valueX = [[pointDic allKeys] firstObject];
            NSNumber *valueY = [[pointDic allValues] firstObject];
            if (valueY.intValue > 0) {
                [linePath moveToPoint:CGPointMake((valueX.floatValue + 1.0)*perPointValue, fhrCellCount * perRowHeight - 5)];
                [linePath addLineToPoint:CGPointMake((valueX.floatValue + 1.0)*perPointValue, fhrCellCount * perRowHeight)];
            }
        }
        
        [linePath stroke];
        
    }
}

-(void)insertMorePointFromFrontPoint:(CGPoint)frontOpt andCurrPoint:(CGPoint)currOpt andPath:(UIBezierPath *)path{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *minValue = [userDefault objectForKey:@"speed"];
    
    if (minValue.intValue == 2) {
        CGFloat xValue = frontOpt.x + (currOpt.x - frontOpt.x) / 2;
        CGFloat yValue = frontOpt.y + (currOpt.y - frontOpt.y) / 2;
        [path addLineToPoint:CGPointMake(xValue, yValue)];
    }else if (minValue.intValue == 3){
        CGFloat addValueX = (currOpt.x - frontOpt.x) / 3;
        CGFloat addValueY = (currOpt.y - frontOpt.y) / 3;
        
        CGFloat xValue1 = frontOpt.x + addValueX;
        CGFloat yValue1 = frontOpt.y + addValueY;
        [path addLineToPoint:CGPointMake(xValue1, yValue1)];
        
        CGFloat xValue2 = frontOpt.x + addValueX*2;
        CGFloat yValue2 = frontOpt.y + addValueY*2;
        [path addLineToPoint:CGPointMake(xValue2, yValue2)];
    }
    
}

//把字典转成点（分页）
-(CGPoint)transDataBypage:(int)showPage andPointDic:(NSDictionary *)valueDic andMode:(int)mode{
    
    CGFloat sizePerSec = _sizePerMin / 60;
    CGFloat secPerScreen = self.frame.size.width / sizePerSec;
    CGFloat beginSec = secPerScreen * showPage;
    
    switch (mode) {
        case 0:
        {
            NSNumber *valueX = [[valueDic allKeys] firstObject];
            NSNumber *valueY = [[valueDic allValues] firstObject];
            CGPoint drawOpt = CGPointMake((valueX.floatValue / _rate - beginSec) * sizePerSec, (maxFhr / 10) * perRowHeight - valueY.floatValue * (perRowHeight / 10));
            return drawOpt;
        }
            break;
        case 1:
        {
            NSNumber *valueX = [[valueDic allKeys] firstObject];
            NSNumber *valueY = [[valueDic allValues] firstObject];
            CGPoint drawOpt = CGPointMake((valueX.floatValue / _rate - beginSec) * sizePerSec, fhrCellCount * perRowHeight + abscissaHeight + (tocoCellCount * perRowHeight - valueY.floatValue * (perRowHeight / 10)));
            
            return drawOpt;
        }
            break;
        default:
            return CGPointZero;
            break;
    }
    
}

//把字典转成点
-(CGPoint)transData:(NSDictionary *)valueDic andMode:(int)mode{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *minValue = [userDefault objectForKey:@"speed"];
    perPointValue = (minValue.intValue * 64.0) / (60.0 * _rate);
    
    switch (mode) {
        case 0:
        {
            NSNumber *valueX = [[valueDic allKeys] firstObject];
            NSNumber *valueY = [[valueDic allValues] firstObject];
            CGPoint drawOpt = CGPointMake((valueX.floatValue + 1.0)*perPointValue, (maxFhr / 10) * perRowHeight - valueY.floatValue * (perRowHeight / 10));
            return drawOpt;
        }
            break;
        case 1:
        {
            NSNumber *valueX = [[valueDic allKeys] firstObject];
            NSNumber *valueY = [[valueDic allValues] firstObject];
            CGPoint drawOpt = CGPointMake((valueX.floatValue + 1.0)*perPointValue, fhrCellCount * perRowHeight + 23.5 + (tocoCellCount * perRowHeight - valueY.floatValue * (perRowHeight / 10)));
            
            return drawOpt;
        }
            break;
        default:
            return CGPointZero;
            break;
    }
}

-(void)checkPointToScreenEdge{
    NSDictionary *lastPointDic = [_heartArr lastObject];
    
    CGPoint lastOpt = [self transData:lastPointDic andMode:0];
    
    int currPage = lastOpt.x / (viewBoundSize.width - 23.5) + 1;
    NSLog(@"total page is : %d",currPage);
    if (currPage != page) {
        self.frame = CGRectMake(0, 0, (viewBoundSize.width - 23.5) * currPage, self.frame.size.height);
        [self.delegate pointToScreenEdge:currPage];
    }
    page = currPage;
}

//画图(全部)
-(void)drawAll:(NSMutableArray *)heartArr andPressArr:(NSMutableArray *)pressArr andMoveArr:(NSMutableArray *)moveArr{
    
    drawMode = 0;
    
    if (heartArr.count > 0) {
        _heartArr = heartArr;
    }
    
    if (pressArr.count > 0) {
        _pressArr = pressArr;
    }
    
    if (moveArr.count > 0) {
        _moveArr = moveArr;
    }
    
    
    [self setNeedsDisplay];
}

//画图(部分)
-(void)draw:(NSMutableArray *)heartArr andPressArr:(NSMutableArray *)pressArr andMoveArr:(NSMutableArray *)moveArr{
    
    if (heartArr.count > 0) {
        _heartArr = heartArr;
        [self checkPointToScreenEdge];
    }
    
    if (pressArr.count > 0) {
        _pressArr = pressArr;
    }
    
    if (moveArr.count > 0) {
        _moveArr = moveArr;
    }
    
    [self setNeedsDisplayInRect:CGRectMake((viewBoundSize.width - 23.5) * (page - 1), 0, (viewBoundSize.width - 23.5), self.frame.size.height)];
}

//画图(分页)
-(void)drawByPage:(int)showPage andHeartArr:(NSMutableArray *)heartArr andPressArr:(NSMutableArray *)pressArr andMoveArr:(NSMutableArray *)moveArr{
    
    _showPage = showPage;
    drawMode = 1;
    
    if (heartArr.count > 0) {
        _heartArr = heartArr;
    }
    
    if (pressArr.count > 0) {
        _pressArr = pressArr;
    }
    
    if (moveArr.count > 0) {
        _moveArr = moveArr;
    }
    
    [self setNeedsDisplay];
    
}

-(void)refreshView{
    [self setNeedsDisplay];
}

//安全区域
-(void)drawSaveRect{
    float maxY = (maxFhr -  _maxAlarm) / 10 * perRowHeight;
    float minY = (maxFhr -  _minAlarm) / 10 * perRowHeight;
    
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, maxY, self.frame.size.width, minY - maxY)];
    [[UIColor16 colorWithHexString:@"#F599BE" alpha:0.3f] set];
    [rectPath fill];
}

-(void)strokeHeartAndPress
{
    [[UIColor16 colorWithHexString:@"#0078ff"] set];
    [heartPath stroke];
    [[UIColor16 colorWithHexString:@"#5a6089"] set];
    [pressPath stroke];
    [[UIColor blackColor] set];
    [movePath stroke];
}

- (void)drawRect:(CGRect)rect
{
    NSValue *rectValue = [NSValue valueWithCGRect:rect];
    
    [self drawSaveRect];
    
    if (drawMode == 1)
    { //分页
        [self drawPageBaseX:_showPage];
        [self drawPageBaseY:_showPage];
        [self drawPageSecY:_showPage];
        [self drawPageSecX:_showPage];
        [self drawPageHeartBeat:_showPage];
        [self drawPressByPage:_showPage];
        [self drawMoveByPage:_showPage];
        [self strokeHeartAndPress];
        [self showPageCoordinate];
    }
    else if (drawMode == 0)
    { //不分页
//        [self drawBaseY];
//        [self drawBaseX];
//        [self drawSecY];
//        [self drawSecX];
//        [self drawHeartBeat];
//        [self drawPress];
//        [self drawMove];

        [self drawPageBaseX:0];
        [self drawPageBaseY:0];
        [self drawPageSecY:0];
        [self drawPageSecX:0];
        [self drawPageHeartBeat:0];
        [self drawPressByPage:0];
        [self drawMoveByPage:0];
        
        [SVProgressHUD dismiss];
        [self showPageCoordinate];
    }
}

-(void)clearData
{
    [_heartArr removeAllObjects];
    [_pressArr removeAllObjects];
    [_moveArr removeAllObjects];
    
    [self setNeedsDisplay];
}

@end
