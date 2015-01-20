@import ServiceManagement;
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) BOOL showNonSandboxedItems;
@property (nonatomic) NSArray *items;

@end

@interface F: NSObject

@property (nonatomic) NSString *l;
@end

@implementation F

+ (instancetype)f:(NSString *)a
{
    F *f = [[F alloc] init];
    f.l = a;
    return f;
}

@end

@implementation ViewController

- (void)viewDidAppear
{
    [super viewDidAppear];

    CFArrayRef CFJobs = SMCopyAllJobDictionaries(kSMDomainUserLaunchd);
    NSArray *jobs = CFBridgingRelease(CFJobs);
    NSMutableArray *jobNames = [NSMutableArray new];
    if (jobs && [jobs count] > 0) {
        for (NSDictionary *job in jobs) {
            NSString *label = job[@"Label"];
            if ([label hasPrefix:@"com.apple."]) {
                continue;
            }

//            [jobNames addObject:label];
            [jobNames addObject:[F f:label]];
            NSLog(@"%@", job);
        }
    }

    self.items = [jobNames copy];
}

- (IBAction)refresh:(id)sender
{
}

@end
