//
//  RollbarKSCrashInstallation.h
//  
//
//  Created by Andrey Kornich on 2020-10-28.
//

@import KSCrash_Installations;

NS_ASSUME_NONNULL_BEGIN

@interface RollbarKSCrashInstallation : KSCrashInstallation

+ (instancetype)sharedInstance;
- (void)sendAllReports;

@end

NS_ASSUME_NONNULL_END
