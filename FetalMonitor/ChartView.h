#import <UIKit/UIKit.h>

@protocol ChartViewDelegate <NSObject>

-(void)pointToScreenEdge:(int)paintPage;

@end

@interface ChartView : UIView

@property (nonatomic, strong) NSObject<ChartViewDelegate> *delegate;
@property (nonatomic) float sizePerMin;
@property (nonatomic) int maxAlarm;
@property (nonatomic) int minAlarm;
@property (nonatomic) int rate;

-(id)initWithFrame:(CGRect)frame andBottomHeight:(int)height;

-(void)draw:(NSMutableArray *)heartArr andPressArr:(NSMutableArray *)pressArr andMoveArr:(NSMutableArray *)moveArr;
-(void)drawAll:(NSMutableArray *)heartArr andPressArr:(NSMutableArray *)pressArr andMoveArr:(NSMutableArray *)moveArr;
-(void)drawByPage:(int)showPage andHeartArr:(NSMutableArray *)heartArr andPressArr:(NSMutableArray *)pressArr andMoveArr:(NSMutableArray *)moveArr;

-(void)refreshView;

-(void)clearData;

@end
