@import Foundation;

@interface LoginItem : NSObject

@property (nonatomic, readonly) NSString *bundleIdentifier;
@property (nonatomic, readonly) NSString *executablePath;
@property (nonatomic, readonly) NSString *applicationName;

+ (instancetype)itemFromServiceManagementDictionary:(NSDictionary *)dictionary;

@end
