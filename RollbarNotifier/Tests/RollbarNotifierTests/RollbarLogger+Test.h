//
//  RollbarLogger+Test.h
//  
//
//  Created by Andrey Kornich on 2020-06-02.
//

@class NSThread;

@interface RollbarLogger (Test)

- (NSThread *)_rollbarThread;

- (void)_test_doNothing;

@end
