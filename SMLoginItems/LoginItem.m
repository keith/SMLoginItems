#import "LoginItem.h"

@interface LoginItem ()

@property (nonatomic, readwrite) NSString *bundleIdentifier;
@property (nonatomic, readwrite) NSString *executablePath;
@property (nonatomic, readwrite) NSString *applicationName;

@end

@implementation LoginItem

+ (instancetype)itemFromServiceManagementDictionary:(NSDictionary *)dictionary
{
    LoginItem *item = [LoginItem new];
    [item setupWithServiceManagementDictionary:dictionary];
    return item;
}

- (void)setupWithServiceManagementDictionary:(NSDictionary *)dictionary
{
    self.executablePath = dictionary[@"Program"];
    NSString *bundlePath = [[[self.executablePath
                              stringByDeletingLastPathComponent]
                             stringByDeletingLastPathComponent]
                            stringByDeletingLastPathComponent];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *label = dictionary[@"Label"];
    if (!bundle || !bundle.bundleIdentifier) {
        self.bundleIdentifier = label;
        self.executablePath = nil;
    } else {
        self.bundleIdentifier = bundle.bundleIdentifier;
    }

    NSDictionary *bundleInfo = bundle.infoDictionary;
    self.applicationName = bundleInfo[(NSString *)kCFBundleNameKey];
}

- (NSString *)applicationName
{
    if (_applicationName) {
        return _applicationName;
    }

    return self.bundleIdentifier;
}

+ (BOOL)jobIsSandboxed:(NSDictionary *)job
{
    if (!job[@"PID"]) {
        return YES;
    }

    if (job[@"EnableTransactions"]) {
        return YES;
    }

    if (!job[@"ProgramArguments"]) {
        return YES;
    }

    if ([job[@"OnDemand"] isEqual:@0]) {
        return YES;
    }

    return NO;
}

@end
