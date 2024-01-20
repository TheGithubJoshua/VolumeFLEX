#import <Preferences/PSListController.h>

@interface VFPBRootListController : PSListController

@end

@interface NSTask : NSObject
@property(copy)NSArray* arguments;
@property(copy)NSString* launchPath;
- (void)launch;
@end
