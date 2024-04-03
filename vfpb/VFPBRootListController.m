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

-(void)donate {
    NSLog(@"Thank you!");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.bitcoinqrcodemaker.com/pay/?type=2&style=bitcoin&address=bc1qasj8x4wuenh2g5t6ergawa3svldmzx7gcwema5"]];

}

@end
