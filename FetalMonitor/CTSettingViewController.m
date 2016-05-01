#import "CTSettingViewController.h"

@interface CTSettingViewController ()

@end

@implementation CTSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // tableview选中cell后不保留默认的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
