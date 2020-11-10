//
//  RollbarReceptionist.h
//  
//
//  Created by Andrey Kornich on 2020-10-08.
//

#ifndef RollbarReceptionist_h
#define RollbarReceptionist_h

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/// Pattern Description:
/// The Receptionist design pattern addresses the general problem of redirecting an event occurring in one execution context of an application
/// to another execution context for handling.
///
/// A KVO notification invokes the observeValueForKeyPath:ofObject:change:context: method implemented by an observer.
/// If the change to the property occurs on a secondary thread, the observeValueForKeyPath:ofObject:change:context: code executes on that same thread.
/// The central object in this pattern, the receptionist, acts as a thread intermediary.
/// A receptionist object is assigned as the observer of a model object’s property.
/// The receptionist implements observeValueForKeyPath:ofObject:change:context: to redirect the notification received on a secondary thread to another
/// execution context—the main operation queue, in this case. When the property changes, the receptionist receives a KVO notification. The receptionist
/// immediately adds a block operation to the main operation queue; the block contains code—specified by the client—that updates the user interface
/// appropriately.
///
/// When to use the Pattern:
/// You can adopt the Receptionist design pattern whenever you need to bounce off work to another execution context for handling.
/// When you observe a notification, or implement a block handler, or respond to an action message and you want to ensure that your code executes in the
/// appropriate execution context, you can implement the Receptionist pattern to redirect the work that must be done to that execution context.
/// With the Receptionist pattern, you might even perform some filtering or coalescing of the incoming data before you bounce off a task to process the data.
/// For example, you could collect data into batches, and then at intervals dispatch those batches elsewhere for processing.
///
/// One common situation where the Receptionist pattern is useful is key-value observing. In key-value observing, changes to the value of a model object’s
/// property are communicated to observers via KVO notifications. However, changes to a model object can occur on a background thread. This results in
/// a thread mismatch, because changes to a model object’s state typically result in updates to the user interface, and these must occur on the main thread.
/// In this case, you want to redirect the KVO notifications to the main thread. where the updates to an application’s user interface can occur.
///
/// Usage Example:
///
/// RollbarReceptionist *receptionist =
///     [RollbarReceptionist receptionistForKeyPath:@"value" object:model queue:mainQueue task:^(NSString *keyPath, id object, NSDictionary *change) {
///         NSView *viewForModel = [modelToViewMap objectForKey:model];
///         NSColor *newColor = [change objectForKey:NSKeyValueChangeNewKey];
///         [[[viewForModel subviews] objectAtIndex:0] setFillColor:newColor];
///     }];

/// Defines the Receptionist task block type
typedef void (^RollbarReceptionistTaskBlock)(NSString *keyPath, id object, NSDictionary *change);

/// Defines the Receptionist interface
@interface RollbarReceptionist : NSObject {
    @private
    id observedObject;
    NSString *observedKeyPath;
    RollbarReceptionistTaskBlock task;
    NSOperationQueue *queue;
}

/// Creates a fully-configured Receptionist instance
/// @param path a KVO key-path to observe
/// @param obj a KVO object to observe
/// @param queue a queue to process an observed event on
/// @param task a task to execute on an observed event
+ (instancetype)receptionistForKeyPath:(NSString *)path
                                object:(id)obj
                                 queue:(NSOperationQueue *)queue
                                  task:(RollbarReceptionistTaskBlock)task;
@end

NS_ASSUME_NONNULL_END

#endif //RollbarReceptionist_h
