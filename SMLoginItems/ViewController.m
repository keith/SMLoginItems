@import ServiceManagement;
#import "LoginItem.h"
#import "ViewController.h"

@interface ViewController ()

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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CFArrayRef jobDictionaries = SMCopyAllJobDictionaries(kSMDomainUserLaunchd);
#pragma clang diagnostic pop
    NSArray *jobs = CFBridgingRelease(jobDictionaries);
    NSMutableArray *sandboxedItems = [NSMutableArray new];
    for (NSDictionary *job in jobs) {
        NSString *label = job[@"Label"];
        if ([label hasPrefix:@"com.apple."]) {
            continue;
        }

        if ([LoginItem jobIsSandboxed:job]) {
            LoginItem *item = [LoginItem itemFromServiceManagementDictionary:job];
            [sandboxedItems addObject:item];
        }
    }

    self.items = [sandboxedItems copy];
}

- (IBAction)refresh:(id)sender
{
    [self loadItems];
}

- (void)doubleClickedTableView:(NSTableView *)sender
{
    LoginItem *item = self.items[sender.selectedRow];
    NSURL *fileURL;
    if (item.executablePath) {
        fileURL = [NSURL fileURLWithPath:item.executablePath];
    } else if (item.bundleIdentifier) {
        fileURL = [[NSWorkspace sharedWorkspace]
                   URLForApplicationWithBundleIdentifier:item.bundleIdentifier];
    } else {
        return;
    }

    if (fileURL) {
        [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[fileURL]];
    }
}

@end
