#import <UIKit/UIKit.h>
#import "PWRecordListModel.h"

@interface MonitorHistoryRecordViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    // 选择视图数组
    NSMutableArray *categoryArray;
    // 选择视图
    UIView *categoryView;
    // 列表
    UITableView *tableView;
    // 选择类型
    NSInteger currentCategory;
    // 切换之前的类型
    NSInteger previousCategory;
    // 记录tableview的位置
    NSMutableDictionary *dictionary;
    PWRecordListModel *monitorData;
    UIAlertView *remindAlertView;
}

// 已上传数据源
@property (nonatomic, strong) NSMutableArray *uploadsTableArray;
// 未上传数据源
@property (nonatomic, strong) NSMutableArray *unUploadTableArray;

@end
