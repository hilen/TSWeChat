//
//  NSNotificationCenter+Block.swift
//  TSWeChat
//
//  Created by Hilen on 12/18/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

//https://gist.github.com/brentdax/64845dc0b3fec0a27d87


import Foundation

public extension NSNotificationCenter {
    func addObserver<T: AnyObject>(observer: T, name aName: String?, object anObject: AnyObject?, queue: NSOperationQueue? = NSOperationQueue.mainQueue(), handler: (observer: T, notification: NSNotification) -> Void) -> AnyObject {
        let observation = addObserverForName(aName, object: anObject, queue: queue) { [unowned observer] note in
            handler(observer: observer, notification: note)
        }
        
        ObservationRemover(observation).makeRetainedBy(observer)
        
        return observation
    }
}

private class ObservationRemover: NSObject {
    let observation: NSObjectProtocol
    
    init(_ obs: NSObjectProtocol) {
        observation = obs
        super.init()
    }
    
    func makeRetainedBy(owner: AnyObject) {
        observationRemoversForObject(owner).addObject(self)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(observation)
    }
}

private var ObservationRemoverKey: UnsafePointer<Void> = nil

private func observationRemoversForObject(object: AnyObject) -> NSMutableArray {
    if ObservationRemoverKey == nil {
        withUnsafePointer(&ObservationRemoverKey) { pointer in
            ObservationRemoverKey = UnsafePointer<Void>(pointer)
        }
    }
    
    var retainedRemovers = objc_getAssociatedObject(object, ObservationRemoverKey) as! NSMutableArray?
    if retainedRemovers == nil {
        retainedRemovers = NSMutableArray()
        objc_setAssociatedObject(object, ObservationRemoverKey, retainedRemovers, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    return retainedRemovers!
}




