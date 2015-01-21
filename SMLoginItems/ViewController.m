@import ServiceManagement;
#import "LoginItem.h"
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) BOOL showNonSandboxedItems;
@property (nonatomic) NSArray *items;
@property (weak) IBOutlet NSTableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.doubleAction = @selector(doubleClickedTableView:);
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    [self loadItems];
}

- (void)loadItems
{
    CFArrayRef CFJobs = SMCopyAllJobDictionaries(kSMDomainUserLaunchd);
    NSArray *jobs = CFBridgingRelease(CFJobs);
    NSMutableArray *jobNames = [NSMutableArray new];
    if (jobs && [jobs count] > 0) {
        for (NSDictionary *job in jobs) {
            NSString *label = job[@"Label"];
            if ([label hasPrefix:@"com.apple."]) {
                continue;
            }

            LoginItem *item = [LoginItem itemFromServiceManagementDictionary:job];
            [jobNames addObject:item];

            NSLog(@"%@", job);
        }
    }

    self.items = [jobNames copy];
}

- (IBAction)refresh:(id)sender
{
    [self loadItems];
}

- (void)doubleClickedTableView:(NSTableView *)sender
{
    LoginItem *item = self.items[sender.selectedRow];
    if (item.executablePath) {
        NSURL *fileURL = [NSURL fileURLWithPath:item.executablePath];
        [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[fileURL]];
    }

    NSLog(@"YEa!");
}

@end
