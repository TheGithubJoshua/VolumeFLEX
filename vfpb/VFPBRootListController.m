#import <Foundation/Foundation.h>
#import "VFPBRootListController.h"
#import <rootless.h>
#include <spawn.h>

@implementation VFPBRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)respring {
    NSLog(@"1010");
    // Function to spawn a process using posix_spawn
    const char *killallPath = [ROOT_PATH_NS("/usr/bin/killall") UTF8String];
       const char *backboarddArg = "backboardd";

       // Construct arguments array
       const char *argv[] = {killallPath, backboarddArg, NULL};

       // Spawn the process
       pid_t pid;
       posix_spawn(&pid, killallPath, NULL, NULL, (char *const *)argv, NULL);

       // Check if the spawn was successful
       if (pid > 0) {
           // Successfully spawned the process
           NSLog(@"Spawned process with PID: %d", pid);
       } else {
           // Failed to spawn the process
           NSLog(@"Failed to spawn process");
       }
}

-(void)donate {
    NSLog(@"Thank you!");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.bitcoinqrcodemaker.com/pay/?type=2&style=bitcoin&address=bc1qasj8x4wuenh2g5t6ergawa3svldmzx7gcwema5"]];

}

@end
